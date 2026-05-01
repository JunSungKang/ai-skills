---
name: skill-git-commit
description: 프로젝트와 문서 변경 사항을 GitHub에 규칙 기반 한글 커밋 메시지로 커밋하고 현재 브랜치에 push까지 자동 수행할 때 사용
---

# GitHub Commit And Push

이 스킬은 Git 저장소의 변경 사항을 감지하고, 규칙을 만족하는 한글 커밋 메시지를 생성한 뒤 `git add`, `git commit`, `git push origin <현재 브랜치>`까지 수행한다.

## 실행 원칙

- 변경 파일이 없으면 커밋과 push를 중단한다.
- 사용자가 파일을 지정하면 해당 파일만 add하고, 지정하지 않으면 전체 변경 파일을 add한다.
- 커밋 메시지는 항상 한글로 작성한다. 영문 코드명, 파일명, 명령어는 필요한 경우에만 상세 항목에 허용한다.
- push 실패 시 한 번 재시도한다. 인증 문제로 보이면 사용자에게 인증 처리를 요청한다.
- 불필요한 설명 없이 실행 결과 중심으로 출력한다.

## 커밋 카테고리

허용 카테고리:

- `feat`: 기능 추가 또는 확장
- `fix`: 오류 수정
- `chore`: 설정, 빌드, 의존성, 관리 작업
- `etc`: 문서, 주석, 기타 변경
- `design`: UI, 스타일, 레이아웃 변경
- `perf`: 성능 개선

## 메시지 규칙

형식:

```text
<category>: <메인 메세지>

- <상세 항목 1>
- <상세 항목 2>
```

검증 기준:

- 카테고리는 반드시 허용 목록 중 하나를 사용한다.
- 메인 메세지는 카테고리와 콜론을 제외하고 50자 이내로 작성한다.
- 상세 항목은 불릿 포인트로 작성한다.
- 상세 항목은 항목당 100자 이내로 작성한다.
- 상세 항목은 최대 5개까지 작성한다.
- 상세 항목이 5개를 초과할 만큼 변경 범위가 넓으면 파일 또는 변경 목적별로 커밋을 분리한다.

## 메시지 생성 절차

1. `git status --short`로 변경 파일을 확인한다.
2. `git diff --stat`과 필요한 경우 `git diff -- <file>`로 변경 목적을 파악한다.
3. 카테고리를 하나 선택한다.
4. 메인 메세지는 핵심 변경 한 가지를 한글 50자 이내로 요약한다.
5. 상세 항목은 최대 5개로 묶고, 각 항목을 한글 100자 이내로 작성한다.
6. 상세 항목이 5개를 초과하면 관련 파일끼리 나누어 여러 번 실행한다.

## 자동 실행 명령 흐름

전체 변경 파일을 커밋하고 push할 때:

```bash
git status --short
git diff --stat
git branch --show-current
/home/jskang/.codex/skills/skill-git-commit/scripts/git_commit_push.sh \
  --category feat \
  --main "주요 기능을 추가" \
  --detail "핵심 기능 흐름을 구현" \
  --detail "관련 문서와 설정을 정리"
```

선택 파일만 커밋하고 push할 때:

```bash
git status --short
git diff --stat -- path/to/file
git branch --show-current
/home/jskang/.codex/skills/skill-git-commit/scripts/git_commit_push.sh \
  --category fix \
  --main "저장 오류를 수정" \
  --detail "예외 처리 조건을 보강" \
  --detail "실패 응답 메시지를 정리" \
  --files path/to/file
```

## 스크립트 사용법

```bash
/home/jskang/.codex/skills/skill-git-commit/scripts/git_commit_push.sh \
  --category <feat|fix|chore|etc|design|perf> \
  --main "<한글 메인 메세지>" \
  --detail "<한글 상세 항목>" \
  [--detail "<한글 상세 항목>"] \
  [--files <file> ...]
```

스크립트는 다음을 수행한다.

1. Git 저장소 여부 확인
2. 변경 파일 감지
3. 전체 또는 선택 파일 `git add`
4. 커밋 메시지 규칙 검증 및 가능한 범위의 자동 보정
5. `git commit`
6. 현재 브랜치 확인
7. `git push origin <현재 브랜치>` 실행
8. push 실패 시 1회 재시도

## 예외 처리

- 변경 파일 없음: `변경 파일이 없어 커밋/푸시를 중단합니다.` 출력 후 종료
- staged 변경 없음: `스테이징된 변경이 없어 커밋/푸시를 중단합니다.` 출력 후 종료
- 상세 항목 5개 초과: 커밋을 분리하고 스크립트를 여러 번 실행
- 인증 실패: 사용자에게 GitHub 인증 또는 토큰 갱신을 요청
- push 실패: 재시도 후에도 실패하면 오류를 그대로 출력
