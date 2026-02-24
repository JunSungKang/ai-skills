# 백엔드 개발 산출물 예시 (Python)

## 기본 정보
| 항목 | 내용 |
|------|------|
| 작업일 | 2026-02-20 |
| 담당 | 시니어 백엔드 개발자 (Python) |
| 작업 유형 | 기능개발 |
| 작업명 | 파일 업로드 비동기 처리 및 진행률 API 구현 |

## 작업 요약
대용량 파일 업로드 시 동기 처리로 인한 타임아웃 문제를 해결하기 위해 Celery 기반 비동기 처리를 도입했습니다. 업로드 진행률을 WebSocket 또는 SSE로 실시간 전달하는 API도 함께 구현했습니다.

## 변경 파일 목록
| 파일 경로 | 변경 유형 | 변경 내용 |
|-----------|-----------|-----------|
| `app/api/v1/upload.py` | 수정 | 비동기 업로드 엔드포인트 추가 |
| `app/tasks/file_tasks.py` | 추가 | Celery 파일 처리 태스크 |
| `app/services/upload_service.py` | 수정 | 비동기 처리 로직 분리 |
| `app/api/v1/progress.py` | 추가 | SSE 진행률 스트리밍 엔드포인트 |
| `app/core/celery_app.py` | 추가 | Celery 앱 설정 |
| `tests/test_upload.py` | 수정 | 비동기 테스트 케이스 추가 |

## 변경 내역
### 비동기 업로드 처리 (upload.py)
- **변경 전**: 파일 업로드 → 동기 처리 → 응답 (30초+ 타임아웃 발생)
- **변경 후**: 파일 업로드 → task_id 즉시 반환 → Celery 백그라운드 처리
- **변경 이유**: 100MB+ 파일 처리 시 HTTP 타임아웃 및 사용자 경험 저하

### SSE 진행률 스트리밍 (progress.py)
- **변경 전**: 없음
- **변경 후**: `/api/v1/upload/{task_id}/progress` SSE 엔드포인트 추가
- **변경 이유**: 사용자에게 실시간 처리 진행 상황 제공

## 성능 개선율
| 지표 | 변경 전 | 변경 후 | 개선율 |
|------|---------|---------|--------|
| API 응답시간 | 35,000ms | 120ms | 99.6% ↑ |
| 처리량 (req/s) | 2 | 45 | 2,150% ↑ |
| 타임아웃 발생률 | 68% | 0% | 100% ↑ |
| 메모리 사용량 | 1.2 GB | 380 MB | 68% ↓ |

## 주요 구현 내용
```python
# app/api/v1/upload.py
from fastapi import APIRouter, UploadFile
from app.tasks.file_tasks import process_file_task

router = APIRouter()

@router.post("/upload", status_code=202)
async def upload_file(file: UploadFile) -> dict:
    """파일 업로드 → 비동기 처리 시작"""
    # 임시 저장
    temp_path = await save_temp_file(file)

    # Celery 태스크 등록
    task = process_file_task.delay(str(temp_path), file.filename)

    return {"task_id": task.id, "status": "processing"}


# app/api/v1/progress.py - SSE 스트리밍
from fastapi.responses import StreamingResponse
import asyncio

@router.get("/upload/{task_id}/progress")
async def get_progress(task_id: str):
    async def event_stream():
        while True:
            progress = await get_task_progress(task_id)
            yield f"data: {progress.model_dump_json()}\n\n"

            if progress.status in ("completed", "failed"):
                break
            await asyncio.sleep(0.5)

    return StreamingResponse(event_stream(), media_type="text/event-stream")
```

## API 변경 사항
| 메서드 | 엔드포인트 | 변경 내용 |
|--------|-----------|-----------|
| POST | /api/v1/upload | 즉시 완료 → task_id 반환 (202 Accepted) |
| GET | /api/v1/upload/{task_id}/progress | 신규 추가 (SSE) |
| GET | /api/v1/upload/{task_id}/status | 신규 추가 (폴링 대안) |

## 영향 범위
- **영향 모듈/서비스**: UploadService, FileProcessor
- **DB 스키마 변경**: 있음 (upload_tasks 테이블 추가, Alembic 마이그레이션 포함)
- **하위 호환성**: 변경 (응답 구조 변경, 클라이언트 수정 필요)
- **마이그레이션 필요**: 있음 (Celery + Redis 인프라 추가 필요)

## 테스트 확인
- [x] 단위 테스트 통과 (pytest)
- [x] 통합 테스트 통과 (pytest-asyncio)
- [x] API 동작 확인 (Swagger UI)
- [x] 타입 체크 통과 (mypy --strict)

## 후속 작업 및 알려진 이슈
- 파일 처리 실패 시 재시도 로직 구현 필요 (Celery retry 설정)
- 임시 파일 정리 스케줄러 추가 필요 (APScheduler로 24시간 후 삭제)
- 100GB 이상 파일에 대한 청크 업로드(multipart) 지원 검토 필요
