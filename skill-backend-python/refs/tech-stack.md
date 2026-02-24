# Python 기술 스택 상세 참조

## 언어 & 버전
- **Python 3.11+ / 3.12+**: 성능 개선, 개선된 에러 메시지, 타입 힌팅 강화

## 웹 프레임워크
- **FastAPI**: 비동기, OpenAPI 자동 생성, Pydantic v2 통합 (신규 프로젝트 권장)
- **Django 4.2+ LTS**: ORM, Admin, 배터리 포함 방식 (엔터프라이즈)
- **Flask 3+**: 경량, 마이크로서비스
- **Starlette**: FastAPI 기반 저수준 ASGI

## 데이터 검증 & 시리얼라이제이션
- **Pydantic v2**: 타입 안전 데이터 모델, 10x 성능 향상 (Rust 코어)
- **marshmallow**: Django/Flask 환경
- **attrs**: 데이터 클래스 대안

## ORM & DB
- **SQLAlchemy 2+**: Core & ORM, async 지원
- **Alembic**: DB 마이그레이션
- **Django ORM**: Django 환경
- **asyncpg**: 비동기 PostgreSQL 드라이버
- **psycopg3**: PostgreSQL 드라이버
- **motor**: 비동기 MongoDB 드라이버

## 테스트
- **pytest**: 단위/통합 테스트
- **pytest-asyncio**: 비동기 테스트
- **httpx**: 비동기 HTTP 클라이언트 + 테스트용
- **factory_boy**: 테스트 픽스처
- **Faker**: 테스트 데이터 생성

## 비동기 & 태스크 큐
- **asyncio**: 내장 비동기
- **Celery 5+**: 분산 태스크 큐
- **arq**: asyncio 기반 Redis 큐 (경량)
- **APScheduler**: 스케줄링

## 캐싱 & 메시지
- **Redis (redis-py, aioredis)**: 캐싱, 세션, Pub/Sub
- **Apache Kafka (confluent-kafka)**: 이벤트 스트리밍
- **RabbitMQ (aio-pika)**: 메시지 큐

## 데이터 처리
- **pandas 2+**: 데이터 분석/변환
- **polars**: 고성능 데이터프레임 (Rust 기반)
- **numpy**: 수치 연산
- **pyarrow**: 컬럼형 데이터, Parquet

## 타입 시스템
- **mypy**: 정적 타입 체커
- **pyright**: Microsoft 타입 체커 (VSCode)
- PEP 484, 526, 544, 604, 612 준수

## 코드 품질
- **ruff**: 빠른 린터 (flake8, isort, 통합)
- **black**: 코드 포매터
- **pre-commit**: 커밋 훅

## 보안
- OWASP Top 10 대응
- SQL Injection: SQLAlchemy 파라미터 바인딩
- 인증: JWT (python-jose), OAuth2
- 민감 정보: python-dotenv, Vault
- 의존성 취약점: pip-audit, safety

## 컨테이너 & 배포
- **Docker / Docker Compose**: 컨테이너화
- **gunicorn + uvicorn**: ASGI/WSGI 서버
- **GitHub Actions / GitLab CI**: CI/CD (설정 파일 작성만, 실행 금지)
