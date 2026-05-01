---
name: skill-git-conflict-resolve
description: GitHub Pull Request 또는 Merge Request의 코드 충돌을 분석, 안전 분류, 보조 스킬 기반 해결, 최종 통합 점검 후 커밋과 push까지 수행할 때 사용
---

# Git Conflict Resolve

이 스킬은 PR/MR 충돌을 탐지하고 기존 기능 보존을 최우선으로 충돌을 해결한다. 자동 해결 가능한 충돌만 처리하며, 위험하거나 의미가 불명확한 충돌은 수동 검토 대상으로 분류하고 커밋과 push를 중단한다.

## 핵심 원칙

- 충돌을 무조건 자동 해결하지 않는다.
- 양쪽 브랜치의 변경 의도를 모두 분석한 뒤 해결한다.
- 기존 기능, public API, 테스트, 보안, 데이터 안정성을 우선 보존한다.
- 자동 해결 가능한 충돌만 수정한다.
- 기술별 판단이 필요하면 보조 스킬을 함께 사용한다.
- 비즈니스 로직, 보안, 권한, 결제, 데이터 마이그레이션 충돌은 수동 검토 대상으로 분류한다.
- 검증 실패 가능성이 있거나 기존 기능 영향 가능성이 있으면 커밋과 push를 중단한다.
- 커밋과 push 직전에 최종 마지막 1번의 통합 점검을 반드시 수행한다.

## 사용 가능한 보조 스킬

- `skill-backend-java21-springboot4`: Java 21, Spring Boot 4, Controller, Service, Repository, DTO, Entity, Mapper, Gradle, Maven, Spring Security, Validation, Transaction, backend test/build 충돌
- `skill-database-postgresql`: SQL, PostgreSQL DDL/DML, migration, schema, index, constraint, sequence, trigger, function, view, Flyway, Liquibase 충돌
- `skill-frontend-react-vite`: React, Vite, TypeScript, JavaScript, package.json, lockfile, CSS, Tailwind, styled-components, Router, 상태 관리, API client, frontend test/lint/typecheck/build 충돌

## 자동 해결 가능 충돌

- import/export 정렬 충돌
- 문서 순서 충돌
- 단순 설정 병합
- lockfile 재생성 가능한 충돌
- 중복 의존성 제거
- formatter로 정규화 가능한 충돌
- 테스트로 검증 가능한 단순 코드 병합

## 자동 해결 금지 충돌

- 인증/인가 로직 충돌
- 결제 로직 충돌
- 개인정보 처리 로직 충돌
- 데이터 삭제/마이그레이션 충돌
- 권한 정책 충돌
- 암호화/토큰/세션 처리 충돌
- API 계약 변경 충돌
- 운영 인프라 설정 충돌
- 테스트로 의미 검증이 어려운 충돌
- 기존 기능 영향 여부를 판단할 수 없는 충돌
- 양쪽 브랜치 변경 중 하나를 제거해야 하는 충돌

## 기존 기능 영향 방지 기준

- 기존 public API 시그니처를 임의로 변경하지 않는다.
- 기존 DB schema, migration 순서, 데이터 삭제 로직을 임의로 변경하지 않는다.
- 기존 테스트를 삭제하거나 약화하지 않는다.
- 기존 인증, 인가, 보안 로직을 단순 병합하지 않는다.
- 기존 화면 흐름, 라우팅, 상태 관리 구조를 임의로 바꾸지 않는다.
- 기존 설정값, 환경 변수, profile 설정을 임의로 제거하지 않는다.
- 의미가 불명확한 충돌은 자동 해결하지 않는다.

## 실행 명령 흐름

대상 브랜치는 사용자가 지정한 브랜치를 우선 사용한다. 지정이 없으면 PR/MR base branch, upstream branch, 원격 기본 브랜치 순서로 추론한다. 추론할 수 없으면 사용자에게 대상 브랜치를 요청한다.

```bash
git branch --show-current
git status --short
git status --porcelain
git branch "backup/conflict-resolve-$(date +%Y%m%d-%H%M%S)"
git stash push -u -m "conflict-resolve-backup-$(date +%Y%m%d-%H%M%S)"
git fetch --all --prune
git merge origin/<target-branch>
git status --short
git diff --name-only --diff-filter=U
```

사용자가 rebase를 명시했거나 저장소 정책이 rebase인 경우:

```bash
git fetch --all --prune
git rebase origin/<target-branch>
git status --short
git diff --name-only --diff-filter=U
```

검증 및 커밋 직전 공통 명령:

```bash
git diff --check
git grep -n "<<<<<<<\\|=======\\|>>>>>>>" -- .
git status --short
git branch --show-current
git push origin <current-branch>
```

## 충돌 해결 절차

1. 현재 브랜치와 대상 브랜치를 확인한다.
2. `git status --short`로 작업 트리 상태를 확인한다.
3. 변경 사항이 있으면 백업 브랜치를 만들고 필요 시 stash를 생성한다.
4. 원격 저장소를 fetch 한다.
5. 대상 브랜치 기준으로 merge 또는 rebase를 시도한다.
6. 충돌 발생 시 `git diff --name-only --diff-filter=U`로 충돌 파일 목록을 수집한다.
7. 각 파일의 확장자, 경로, 충돌 내용, 양쪽 변경 의도를 분석한다.
8. 각 충돌을 `단순 텍스트 충돌`, `코드 의미 충돌`, `의존성 충돌`, `설정 파일 충돌`, `데이터베이스 충돌`, `문서 충돌`, `자동 해결 금지 충돌` 중 하나로 분류한다.
9. 기존 기능 영향 가능성을 평가한다.
10. 기술 지식이 필요한 충돌은 해당 보조 스킬을 함께 사용한다.
11. 자동 해결 가능한 충돌만 수정한다.
12. 보조 스킬 기준에 맞춰 formatter, lint, typecheck, test, build, migration 검증을 실행한다.
13. 충돌 마커가 남아 있는지 검사한다.
14. 기존 기능 영향 여부를 재확인한다.
15. 최종 마지막 1번의 통합 점검을 수행한다.
16. 검증 통과 시 `fix` 카테고리의 한글 커밋 메시지를 생성한다.
17. `git commit` 후 현재 브랜치로 push 한다.
18. 검증 실패 또는 위험 충돌 발견 시 커밋과 push를 중단한다.

## 파일별 분류 기준

- `.java`, `build.gradle`, `pom.xml`, `application.yml`, `application.properties`: `skill-backend-java21-springboot4` 사용
- `.sql`, `db/migration/**`, `migrations/**`, `flyway/**`, `liquibase/**`: `skill-database-postgresql` 사용
- `.tsx`, `.ts`, `.jsx`, `.js`, `vite.config.*`, `package.json`, `pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`, CSS 관련 파일: `skill-frontend-react-vite` 사용
- `.md`, `.txt`, 문서 파일: 문서 충돌로 분류하되 코드 계약이나 운영 절차 변경이 포함되면 수동 검토
- 보안, 권한, 결제, 개인정보, 암호화, 토큰, 세션, API 계약, 운영 인프라 경로: 자동 해결 금지 충돌로 분류

## 최종 마지막 1번의 통합 점검

모든 충돌 해결이 끝난 뒤 커밋과 push 직전에 정확히 1회 수행한다. 관련 변경이 있는 영역만 점검한다.

백엔드 관련 변경이 있으면 `skill-backend-java21-springboot4`를 사용해 점검한다.

```bash
./gradlew clean test build
./mvnw clean test package
```

데이터베이스 관련 변경이 있으면 `skill-database-postgresql`를 사용해 점검한다.

```bash
flyway validate
flyway migrate -dryRunOutput=/tmp/flyway-dry-run.sql
```

프론트엔드 관련 변경이 있으면 `skill-frontend-react-vite`를 사용해 점검한다.

```bash
npm run lint
npm run typecheck
npm run build
```

공통 점검:

```bash
git diff --check
git grep -n "<<<<<<<\\|=======\\|>>>>>>>" -- .
```

## 최종 점검 실패 처리

- 컴파일 에러가 발생하면 커밋하지 않는다.
- 빌드 에러가 발생하면 커밋하지 않는다.
- 테스트 실패가 발생하면 커밋하지 않는다.
- migration 검증 실패가 발생하면 커밋하지 않는다.
- 기존 기능 영향 가능성이 확인되면 push하지 않는다.
- 실패 원인, 관련 파일, 사용한 보조 스킬, 필요한 수동 조치를 출력한다.

## 커밋 메시지 규칙

커밋 메시지는 `skill-git-commit`의 규칙을 따른다. 카테고리는 `fix`를 우선 사용하고 반드시 한글로 작성한다.

```text
fix: <메인 메세지>

- <상세 항목 1>
- <상세 항목 2>
```

- 메인 메세지는 카테고리를 제외하고 50자 이내로 충돌 해결 대상을 요약한다.
- 상세 항목은 한 줄 공백 뒤 불릿 포인트로 작성한다.
- 각 상세 항목은 100자 이내로 작성한다.
- 상세 항목은 최대 5개까지 작성한다.

권장 예시:

```text
fix: PR 코드 충돌 해결

- 백엔드 서비스 충돌 정리
- PostgreSQL 마이그레이션 순서 조정
- React 의존성 중복 제거
- 최종 빌드 및 컴파일 점검 완료
```

## 출력 형식

결과는 다음 순서로 짧게 출력한다.

1. 실행한 Git 명령 흐름
2. 충돌 파일별 분류 결과
3. 사용한 보조 스킬
4. 자동 해결한 내용
5. 수동 검토가 필요한 내용
6. 기존 기능 영향 가능성 요약
7. 최종 마지막 1번의 통합 점검 결과
8. 검증 성공 시 생성한 커밋 메시지와 push 결과
9. 검증 실패 시 커밋과 push 중단 사유

