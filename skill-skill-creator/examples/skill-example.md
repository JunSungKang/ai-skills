# SKILL 생성 보고서 예시

## 기본 정보
| 항목 | 내용 |
|------|------|
| 생성일 | 2026-02-24 |
| 스킬명 | skill-data-analyst |
| 저장 경로 | `/Users/user/.claude/skills/skill-data-analyst/` |
| 분석한 기존 스킬 | `skill-backend-python`, `skill-project-manager` |

---

## 아키텍처 분석 결과
- **기존 스킬 수**: 5개
- **공통 명명 규칙**: `skill-{역할}` 소문자 하이픈 구분
- **공통 frontmatter 패턴**: `name`, `description`, `argument-hint`, `allowed-tools`
- **출력 경로 패턴**: `./outputs/{스킬명}/YYYY-MM-DD_{유형}-{작업명}.md`
- **refs 구조**: 기술 스택, 체크리스트, 가이드 등 상세 참조를 별도 파일로 분리

---

## 생성된 파일 목록
| 파일 | 설명 |
|------|------|
| `SKILL.md` | 주요 지침 (87줄) |
| `template.md` | 분석 보고서 템플릿 |
| `examples/analysis-example.md` | 데이터 분석 보고서 예시 |
| `refs/data-tools.md` | 분석 도구 및 라이브러리 참조 |

---

## SKILL 설계 요약
- **역할**: 10년차 이상 데이터 분석가 (Python/SQL 특화)
- **description**: 데이터 탐색, 시각화, 인사이트 도출 및 보고서 작성. EDA, 대시보드, A/B 테스트 분석에 사용하세요.
- **주요 제약**: Git 자동화 금지, 토큰 최소화, 민감 데이터 노출 금지
- **출력 경로**: `./outputs/data-analyst/YYYY-MM-DD_{분석명}.md`

---

## 생성된 SKILL.md 미리보기

```markdown
---
name: skill-data-analyst
description: 10년차 이상 데이터 분석가. Python/SQL 기반으로 데이터 탐색, 시각화,
  인사이트 도출 및 보고서를 작성합니다. EDA, 대시보드, A/B 테스트 분석에 사용하세요.
argument-hint: [분석 대상 또는 비즈니스 질문]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---
```

---

## 검증 체크리스트
- [x] SKILL.md 500줄 이하 확인 (87줄)
- [x] frontmatter 필드 완성 확인
- [x] Git 자동화 금지 제약 포함 확인
- [x] 출력 경로 규칙 포함 확인
- [x] template.md 생성 확인
- [x] examples/ 예시 파일 확인
- [x] refs/ 참조 파일 확인
