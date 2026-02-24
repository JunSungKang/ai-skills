# SKILL 아키텍처 상세 참조

## 디렉토리 구조
```
{skill-name}/
├── SKILL.md           # 주요 지침 (필수, 500줄 이하)
├── template.md        # 산출물 작성 템플릿
├── examples/          # 예시 출력 파일
│   └── {type}-example.md
└── refs/              # 상세 참조 자료 (SKILL.md에서 링크)
    └── {topic}.md
```

> 기존 스킬에서는 `scripts/` 대신 `refs/`를 사용하고 있음 (실제 디렉토리 기준)

---

## SKILL.md frontmatter 필드

| 필드 | 필수 | 설명 | 예시 |
|------|------|------|------|
| `name` | 권장 | 스킬 표시 이름 (소문자, 숫자, 하이픈, 최대 64자) | `skill-backend-java` |
| `description` | 권장 | 역할 + 기능 + 사용 시기. Claude가 자동 선택에 사용 | 아래 참조 |
| `argument-hint` | 권장 | 자동완성 시 표시되는 힌트 | `[작업 설명]` |
| `allowed-tools` | 권장 | 사전 승인 도구 목록 | `Read, Write, Edit, Bash, Glob, Grep` |
| `user-invocable` | 선택 | `/` 메뉴 노출 여부 (기본: true) | `false` |
| `disable-model-invocation` | 선택 | Claude 자동 로드 방지 (기본: false) | `true` |
| `model` | 선택 | 사용할 모델 | `claude-opus-4-6` |
| `context` | 선택 | 서브에이전트 컨텍스트 | `fork` |

### description 작성 패턴
```
{경력/전문성}. {핵심 기능 1~2개}. {사용 시기/트리거 상황}.
```
예: `15년차 이상 Java/Spring Boot 기반 백엔드 풀스택 개발자.
    서버 사이드 코드 작성/리뷰/최적화를 수행하고 개발 완료 후 산출물 문서를 반드시 생성합니다.
    백엔드 API, 서비스 로직, DB 설계, 마이크로서비스 작업에 사용하세요.`

---

## 기존 스킬 명명 규칙
| 스킬 | 패턴 |
|------|------|
| skill-backend-java | `skill-{도메인}-{언어}` |
| skill-backend-python | `skill-{도메인}-{언어}` |
| skill-frontend-dev | `skill-{도메인}-{역할}` |
| skill-project-manager | `skill-{역할}` |
| skill-security-expert | `skill-{역할}` |

→ 신규 스킬 명명: `skill-{역할}` 또는 `skill-{도메인}-{언어/기술}` 패턴 권장

---

## 출력 경로 규칙 (기존 스킬 기준)
```
{작업 프로젝트 루트}/outputs/{스킬명}/
├── YYYY-MM-DD_{유형}-{작업명}.md      # 주요 산출물
└── details/
    └── YYYY-MM-DD_{작업명}_detail.md  # 상세 산출물 (필요 시)
```

| 스킬 | 출력 경로 |
|------|----------|
| skill-backend-java | `./outputs/backend-java/` |
| skill-backend-python | `./outputs/backend-python/` |
| skill-project-manager | `./outputs/pm/` |
| skill-security-expert | `./outputs/security/` |

---

## SKILL.md 핵심 섹션 구성 (기존 패턴)

### 1. 역할 (## 역할)
- 경력 + 전문성 + 핵심 역할 1~2줄

### 2. 핵심 제약 (## 핵심 제약)
**반드시 포함할 제약:**
1. Git 자동화 절대 금지
2. 토큰 최소화 전략
3. 산출물 생성 의무

**도메인별 추가 제약 예시:**
- 보안: 민감 정보 노출 금지
- 데이터: 개인정보 마스킹
- 프레임워크: 특정 패턴/컨벤션 준수

### 3. 작업 프로세스 (## 작업 프로세스)
- Step 1: 분석/파악 (토큰 절약 전략 명시)
- Step 2: 구현/수행
- Step 3: 산출물 생성 (경로 명시, "필수" 강조)

### 4. 출력 경로 규칙 (## 출력 경로 규칙)
- 코드 블록으로 트리 구조 표시
- 파일명 패턴: `YYYY-MM-DD_{유형}-{작업명}.md`

---

## 토큰 최소화 전략 (모든 스킬 공통)
```markdown
### Step 1: 분석 (토큰 절약 우선)
- 요청 사항 파악 후 영향받는 파일만 선택적 읽기
- 핵심 구조 파악: {도메인 특화 항목}
- 기존 컨벤션({패키지/스타일/패턴}) 확인
```

핵심 원칙:
- 전체 파일 대신 필요한 파일만 읽기 (Glob → Grep → 선택적 Read)
- 불필요한 반복 설명 금지
- 상세 참조는 refs/ 파일로 분리하여 필요 시만 로드
- 코드 예시는 핵심 스니펫만 제공

---

## 자주 사용하는 allowed-tools 조합
| 용도 | 도구 조합 |
|------|----------|
| 코드 개발 | `Read, Write, Edit, Bash, Glob, Grep, Task` |
| 문서/보고서 | `Read, Write, Glob, Grep, Task` |
| 분석/검토 | `Read, Glob, Grep, Task` |
| 파일 생성 전용 | `Read, Write, Edit` |
