#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  git_commit_push.sh --category <feat|fix|chore|etc|design|perf> --main "<한글 메인 메세지>" [--detail "<상세 항목>"]... [--files <file>...]
USAGE
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

is_allowed_category() {
  case "$1" in
    feat|fix|chore|etc|design|perf) return 0 ;;
    *) return 1 ;;
  esac
}

contains_hangul() {
  printf '%s' "$1" | grep -Pq '\p{Hangul}'
}

category=""
main_message=""
details=()
files=()
parsing_files=0

while [[ $# -gt 0 ]]; do
  if [[ "$parsing_files" -eq 1 ]]; then
    files+=("$1")
    shift
    continue
  fi

  case "$1" in
    --category)
      category="${2:-}"
      shift 2
      ;;
    --main)
      main_message="${2:-}"
      shift 2
      ;;
    --detail)
      details+=("${2:-}")
      shift 2
      ;;
    --files)
      parsing_files=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "알 수 없는 인자입니다: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Git 저장소가 아니므로 커밋/푸시를 중단합니다." >&2
  exit 1
fi

if [[ -z "$(git status --short)" ]]; then
  echo "변경 파일이 없어 커밋/푸시를 중단합니다."
  exit 0
fi

if ! is_allowed_category "$category"; then
  category="chore"
fi

main_message="$(trim "$main_message")"
main_message="${main_message#feat: }"
main_message="${main_message#fix: }"
main_message="${main_message#chore: }"
main_message="${main_message#etc: }"
main_message="${main_message#design: }"
main_message="${main_message#perf: }"

if [[ -z "$main_message" ]]; then
  echo "메인 메세지가 없어 커밋/푸시를 중단합니다." >&2
  exit 1
fi

if ! contains_hangul "$main_message"; then
  echo "메인 메세지는 한글을 포함해야 합니다." >&2
  exit 1
fi

if ((${#main_message} > 50)); then
  main_message="${main_message:0:50}"
fi

normalized_details=()
numbered_bullet_re='^[0-9]+[.)][[:space:]]+(.+)$'
for detail in "${details[@]}"; do
  detail="$(trim "$detail")"
  case "$detail" in
    -\ *) detail="${detail#- }" ;;
    \*\ *) detail="${detail#\* }" ;;
  esac
  if [[ "$detail" =~ $numbered_bullet_re ]]; then
    detail="${BASH_REMATCH[1]}"
  fi
  detail="$(trim "$detail")"
  [[ -z "$detail" ]] && continue
  if ! contains_hangul "$detail"; then
    echo "상세 항목은 한글을 포함해야 합니다: $detail" >&2
    exit 1
  fi
  if ((${#detail} > 100)); then
    detail="${detail:0:100}"
  fi
  normalized_details+=("$detail")
done

if ((${#normalized_details[@]} > 5)); then
  echo "상세 항목이 5개를 초과했습니다. 커밋을 분리하십시오." >&2
  exit 1
fi

if ((${#files[@]} > 0)); then
  git add -- "${files[@]}"
else
  git add -A
fi

if git diff --cached --quiet; then
  echo "스테이징된 변경이 없어 커밋/푸시를 중단합니다."
  exit 0
fi

message_file="$(mktemp)"
trap 'rm -f "$message_file"' EXIT

{
  printf '%s: %s\n' "$category" "$main_message"
  if ((${#normalized_details[@]} > 0)); then
    printf '\n'
    for detail in "${normalized_details[@]}"; do
      printf -- '- %s\n' "$detail"
    done
  fi
} > "$message_file"

echo "커밋 메시지:"
cat "$message_file"

git commit -F "$message_file"

branch="$(git branch --show-current)"
if [[ -z "$branch" ]]; then
  echo "현재 브랜치를 확인할 수 없어 push를 중단합니다." >&2
  exit 1
fi

if git push origin "$branch"; then
  echo "push 완료: origin/$branch"
else
  echo "push 실패, 1회 재시도합니다." >&2
  sleep 2
  if git push origin "$branch"; then
    echo "push 완료: origin/$branch"
  else
    echo "push 실패. 인증 문제라면 GitHub 인증 또는 토큰을 갱신하십시오." >&2
    exit 1
  fi
fi
