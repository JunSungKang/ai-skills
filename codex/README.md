# Codex Skills

Codex에서 반복적으로 사용하는 개발, 운영, Git 작업을 표준화한 스킬 모음입니다.

## 스킬 목록

| 스킬 | 용도 |
| --- | --- |
| `skill-backend-java21-springboot4` | Java 21 + Spring Boot 4 기반 API 설계와 서버 구현 |
| `skill-frontend-react-vite` | React 19 + TypeScript + Vite 기반 프론트엔드 구현, 수정, 최적화 |
| `skill-database-postgresql` | PostgreSQL 16 스키마 설계, 쿼리 최적화, Flyway 마이그레이션 |
| `skill-backend-sh` | Linux/macOS용 Bash 스크립트 작성과 `test.sh` 검증 |
| `skill-infra-ubuntu` | Ubuntu 24.04 LTS 서버 초기 구축, 보안 설정, 운영 표준화 |
| `skill-git-commit` | 변경 사항을 규칙 기반 한국어 커밋 메시지로 커밋하고 push |
| `skill-git-conflict-resolve` | PR/MR 충돌 분석, 안전 분류, 해결, 검증, 커밋 및 push |

## 디렉터리 구조

```text
codex/
├── README.md
├── skill-backend-java21-springboot4/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── skill-backend-sh/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── skill-database-postgresql/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── skill-frontend-react-vite/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── skill-git-commit/
│   ├── SKILL.md
│   ├── agents/openai.yaml
│   └── scripts/git_commit_push.sh
├── skill-git-conflict-resolve/
│   ├── SKILL.md
│   └── agents/openai.yaml
└── skill-infra-ubuntu/
    ├── SKILL.md
    └── agents/openai.yaml
```

## 스킬 요약

### `skill-backend-java21-springboot4`

Java 21과 Spring Boot 4 기준으로 REST API, 비즈니스 로직, 계층 구조를 구현합니다.

- Controller, Service, Repository 구조를 사용합니다.
- DTO와 Entity를 분리합니다.
- 생성자 주입, 트랜잭션, Validation을 명시합니다.
- N+1 문제, 예외 처리, 테스트 가능한 구조를 고려합니다.

### `skill-frontend-react-vite`

React 19, TypeScript, Vite 기반 프론트엔드 작업에 사용합니다.

- 함수형 컴포넌트와 Hooks를 사용합니다.
- strict typing을 유지하고 `any` 사용을 최소화합니다.
- React Router DOM 7, Chart.js 등 기존 기술 스택을 우선합니다.
- 접근성, 렌더링 안정성, 컴파일 오류 방지를 함께 확인합니다.

### `skill-database-postgresql`

PostgreSQL 16 기준 데이터베이스 설계와 SQL 작업에 사용합니다.

- Flyway 마이그레이션은 `V1__*.sql` 형식을 따릅니다.
- 인덱스, 제약조건, 트랜잭션 영향을 명시합니다.
- JPA 매핑과 일관성을 유지합니다.
- PostgreSQL 기능을 필요에 맞게 활용합니다.

### `skill-backend-sh`

Linux와 macOS에서 실행 가능한 Bash 스크립트를 작성할 때 사용합니다.

- 최종 산출물은 `script.sh`입니다.
- 검증용 `test.sh`를 작성하고 실행합니다.
- 테스트 성공 후 `test.sh`, `tmp`, `logs` 등 임시 산출물을 정리합니다.
- 실패 시 분석을 위해 로그와 산출물을 보존합니다.

### `skill-infra-ubuntu`

Ubuntu 24.04 계열 LTS 서버의 운영 기준을 만들 때 사용합니다.

- 사용자, SSH, 네트워크, 방화벽, 패키지, 시간 동기화를 설정합니다.
- 디스크, LVM, 로그, 백업, 커널 파라미터를 다룹니다.
- 운영 서버 기준의 보수적이고 검증 가능한 절차를 제공합니다.
- 정보가 부족하면 실행 명령보다 필수 질문을 먼저 정리합니다.

### `skill-git-commit`

현재 변경 사항을 확인하고 커밋부터 push까지 수행할 때 사용합니다.

- `git status --short`, `git diff --stat`로 변경 목적을 파악합니다.
- 커밋 메시지는 한국어로 작성합니다.
- 카테고리는 `feat`, `fix`, `chore`, `etc`, `design`, `perf` 중 하나를 사용합니다.
- 현재 브랜치에 커밋한 뒤 `origin/<현재 브랜치>`로 push합니다.

### `skill-git-conflict-resolve`

GitHub PR 또는 MR 충돌을 안전하게 해결할 때 사용합니다.

- 충돌 파일과 양쪽 변경 의도를 먼저 분석합니다.
- 기존 기능, public API, 테스트, 보안, 데이터 안정성을 우선 보존합니다.
- 위험하거나 의미가 불명확한 충돌은 자동 해결하지 않습니다.
- 해결 후 충돌 마커, 테스트, 빌드, 최종 통합 상태를 확인하고 push합니다.

## 사용 기준

- 사용자가 스킬 이름을 직접 언급하면 해당 스킬을 우선 사용합니다.
- 요청 내용이 특정 스킬의 설명과 명확히 일치하면 해당 스킬을 사용합니다.
- 여러 스킬이 필요한 경우 작업 순서를 정하고 필요한 최소 스킬만 사용합니다.
- 각 스킬의 상세 규칙은 해당 디렉터리의 `SKILL.md`를 기준으로 합니다.

## 관리 기준

- 새 스킬은 `skill-<domain>-<name>` 형식의 디렉터리로 추가합니다.
- 각 스킬은 반드시 `SKILL.md`를 포함합니다.
- Codex 에이전트 설정이 필요한 경우 `agents/openai.yaml`을 둡니다.
- 실행 보조 스크립트는 해당 스킬 디렉터리의 `scripts/` 아래에 둡니다.
