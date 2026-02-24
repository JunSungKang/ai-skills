# Claude Code Skills

> **개인 개발용 Claude Code SKILL 모음집입니다.**
> 개인적인 개발 생산성 향상을 목적으로 직접 설계하고 제작하여 사용 중입니다.
>
> 자유롭게 가져다 사용하셔도 됩니다. 단, **출처를 반드시 명시**해 주세요.

---

## 소개

Claude Code의 [SKILL 기능](https://docs.anthropic.com/ko/docs/claude-code/skills)을 활용한 전문가 페르소나 모음입니다.
각 스킬은 특정 도메인에 특화된 고경력 전문가 역할을 수행하며, `/skill-name` 형태로 호출하여 사용합니다.

---

## 스킬 목록

| 스킬 | 설명 | 사용 예시 |
|------|------|-----------|
| `skill-backend-java` | 15년차+ Java/Spring Boot 백엔드 풀스택 개발자 | `/skill-backend-java REST API 설계` |
| `skill-backend-python` | 15년차+ Python 백엔드 풀스택 개발자 | `/skill-backend-python FastAPI 서버 구축` |
| `skill-frontend-dev` | 15년차+ Next.js/React 프론트엔드 풀스택 개발자 | `/skill-frontend-dev 로그인 페이지 구현` |
| `skill-blogger` | 1000만 구독자 기술 블로거 | `/skill-blogger /path/to/document.md` |
| `skill-presentation` | 20년차+ 프레젠테이션 전문가 | `/skill-presentation AI 트렌드 세미나` |
| `skill-project-manager` | 30년차+ 프로젝트 매니저(PM) | `/skill-project-manager 요구사항 검토` |
| `skill-security-expert` | 30년차+ 정보보안 전문가 (ISMS-P/CSAP) | `/skill-security-expert 코드 보안 감사` |
| `skill-skill-creator` | 10년차+ AI 도구 SKILL 생성 전문가 | `/skill-skill-creator 새 스킬 역할 설명` |

---

## 스킬 상세

### `skill-backend-java`
- **역할**: Java/Spring Boot 기반 서버 사이드 코드 작성 · 리뷰 · 최적화
- **주요 작업**: 백엔드 API 개발, 서비스 로직, DB 설계, 마이크로서비스
- **산출물**: 개발 완료 후 산출물 문서 자동 생성

### `skill-backend-python`
- **역할**: Python 기반 서버 사이드 코드 작성 · 리뷰 · 최적화
- **주요 작업**: Python API, 데이터 파이프라인, ML 서빙, 자동화 스크립트
- **산출물**: 개발 완료 후 산출물 문서 자동 생성

### `skill-frontend-dev`
- **역할**: Next.js/React 기반 프론트엔드 코드 작성 · 리뷰 · 최적화
- **주요 작업**: UI 구현, 성능 최적화, 컴포넌트 설계
- **산출물**: 개발 완료 후 산출물 문서 자동 생성

### `skill-blogger`
- **역할**: 기술 문서를 외부 공개용 블로그 포스팅으로 변환
- **지원 포맷**: PDF, Markdown, TXT, Docx, PPTX 등
- **특징**: 내부 기밀 정보는 제외, 공개 정보 기반으로만 작성

### `skill-presentation`
- **역할**: 강의 · 세미나 · 발표 자료 제작
- **출력 형식**: PPTX(python-pptx 스크립트) + HTML(CSS/JS)
- **특징**: 페이지별 발표 스크립트 요약 제공

### `skill-project-manager`
- **역할**: 프로젝트 전반 평가 및 수정 권고 보고서 작성
- **주요 작업**: 요구사항 명세, 기능명세, 개발 산출물 검수, 일정/리소스 관리

### `skill-security-expert`
- **역할**: 보안 취약점 분석 및 개선 권고 보고서 작성
- **자격**: ISMS-P / CSAP 인증심사원 수준
- **주요 작업**: 보안 검토, 컴플라이언스 평가, 보안 아키텍처 리뷰, 코드 보안 감사

### `skill-skill-creator`
- **역할**: Claude Code의 SKILL을 설계하고 생성
- **특징**: 기존 스킬 디렉토리 아키텍처를 분석 후 적합한 스킬 생성
- **주의**: 반드시 SKILL 디렉토리 경로를 먼저 제공해야 동작

---

## 디렉토리 구조

```
skills/
├── README.md
├── skill-backend-java/
│   ├── SKILL.md          # 스킬 정의 및 프롬프트
│   ├── template.md       # 출력 템플릿
│   ├── examples/         # 사용 예시
│   └── refs/             # 참고 자료
├── skill-backend-python/
├── skill-blogger/
├── skill-frontend-dev/
├── skill-presentation/
├── skill-project-manager/
├── skill-security-expert/
└── skill-skill-creator/
```

---

## 사용 방법

Claude Code에서 스킬 디렉토리를 설정한 후, 슬래시 명령어로 호출합니다.

```bash
# Claude Code settings.json 에 skills 경로 설정
# "skillsDirectory": "/path/to/skills"

# 사용 예
/skill-backend-java 사용자 인증 API 개발해줘
/skill-security-expert 이 코드의 보안 취약점을 분석해줘
/skill-blogger /docs/tech-notes.md
```

---

## 라이선스 및 출처

이 저장소는 개인 개발 목적으로 제작 및 관리되고 있습니다.

**자유롭게 사용 및 수정하실 수 있으나, 사용 시 반드시 출처를 밝혀 주세요.**

```
출처: https://github.com/[username]/claude-skills
```

---

*Last updated: 2026-02-25*
