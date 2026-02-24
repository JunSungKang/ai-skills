# 문서 형식별 처리 방법

## 지원 문서 형식

| 형식 | 확장자 | 처리 방법 |
|------|--------|----------|
| Markdown | .md | Read 도구로 직접 읽기 |
| 텍스트 | .txt | Read 도구로 직접 읽기 |
| PDF | .pdf | Read 도구로 읽기 (텍스트 추출) |
| Word | .docx, .doc | Bash로 변환 후 읽기 |
| PowerPoint | .pptx, .ppt | Bash로 텍스트 추출 후 읽기 |

---

## 형식별 처리 절차

### Markdown / TXT
```
Read 도구 → 직접 내용 분석 → 포스팅 작성
```

### PDF
```
Read 도구로 읽기 시도
→ 실패 시: Bash로 텍스트 추출 도구 활용
  예) python -c "import pdfplumber; ..."
  또는 pdftotext (설치된 경우)
```

### DOCX
```
Bash: python -c "
from docx import Document
doc = Document('{경로}')
for para in doc.paragraphs:
    print(para.text)
" 2>/dev/null
```

### PPTX / PPT
```
Bash: python -c "
from pptx import Presentation
prs = Presentation('{경로}')
for slide in prs.slides:
    for shape in slide.shapes:
        if shape.has_text_frame:
            for para in shape.text_frame.paragraphs:
                print(para.text)
" 2>/dev/null
```

---

## 절대경로 검증 로직

### 검증 규칙
```
Windows 절대경로: [A-Z]:\ 또는 [A-Z]:/ 로 시작
Unix 절대경로: / 로 시작
네트워크 경로: \\ 로 시작 (Windows UNC)
```

### 상대경로 패턴 (거부)
```
./ 로 시작
../ 로 시작
드라이브 문자 없이 폴더명으로 시작
```

---

## 이미지 추출 처리

### 이미지가 포함된 문서 처리 원칙
1. 포스팅에서 이미지 참조가 필요한 경우 → `img/{post-title}/` 디렉토리 생성
2. 이미지 파일은 원본에서 복사 가능 시 복사, 불가 시 이미지 설명으로 대체
3. 다이어그램·스크린샷은 내부 정보 제거 후 사용

### 이미지 삽입 마크다운 형식
```markdown
![그림 설명](img/{post-title}/image-name.png)
```

### 이미지 없이 설명으로 대체하는 경우
```markdown
> **[그림]** 시스템 아키텍처 개요
> 클라이언트 → API Gateway → 마이크로서비스 → 데이터베이스
> (3-Tier 구조의 일반적인 MSA 패턴)
```

---

## 토큰 절약 전략

1. **선택적 읽기**: 목차/헤더 먼저 파악 → 핵심 섹션만 읽기
2. **대용량 문서**: 앞부분(개요) + 뒷부분(결론) 우선, 중간 선택적
3. **반복 내용**: 첫 출현만 분석, 이후 동일 패턴 건너뜀
4. **코드 위주 문서**: 코드는 핵심 로직만 발췌, 전체 복사 금지
