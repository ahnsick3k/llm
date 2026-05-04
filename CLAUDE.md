# 프로젝트 개요

틸노트(Tilnote) IR 덱 + Beautiful Sudoku iOS 앱 개발 병행 중.

# 현재 작업 상태

## 틸노트 IR 덱
- **초안 완성 (2026-04-04)** — 다음 단계: Google Slides 실제 제작

## Beautiful Sudoku iOS 앱 (`Sudoku/sudoku/`)
- **개발 진행 중 (2026-04-30 ~ 2026-05-04)**

### 완성된 기능
- [x] 게임 화면: 보드, 하트(생명), 타이머, 힌트, 지우기
- [x] 커스텀 키패드 (시스템 키보드 대체) — Dock+패드 단일 컴포넌트
- [x] 셀 탭 → 키패드 올라옴 / 재탭 → 내려감
- [x] 완성된 숫자 키패드 비활성화 (다크모드 호환 포함)
- [x] 게임오버(하트 소진) / 클리어 모달
- [x] 난이도 6단계: Baby·Easy·Normal·Hard·Master·Doctor
- [x] 홈화면: Drum Picker (1드래그=1스냅), 블러 보드 미리보기, 고정 배경 선택 하이라이트
- [x] xAI 디자인 시스템 (Light/Dark 어댑티브)
- [x] 다크/라이트 모드 Toggle (메뉴)
- [x] 메뉴화면: New Game·Restart·난이도 목록·테마 토글
- [x] 샵화면: 힌트5·힌트10·하트+1
- [x] 홈→게임 동일 퍼즐 전달 (blur 미리보기 = 실제 게임 판)
- [x] 난이도별 클리어 점수 차등 (500~4000점)

### 남은 작업
- [ ] Drum Picker 선택 인식성 개선
- [ ] TestFlight 빌드 및 내부 테스트
- [ ] App Store 등록 준비

## Beautiful Sudoku 웹앱 (`Sudoku/sudoku-web/`)
- **배포 완료 (2026-05-04)**
- **URL**: https://sudoku-one-tau.vercel.app
- **GitHub**: https://github.com/ahnsick3k/sudoku

### 완성된 기능
- [x] Next.js 16 + Tailwind v4 + TypeScript
- [x] iOS 앱과 동일한 6단계 난이도 (100개 퍼즐 × 6난이도)
- [x] 3×3 커스텀 키패드 + 키보드 입력 (1-9, Backspace, Escape)
- [x] Heroicons 전체 적용
- [x] 44px 터치 영역 (Apple HIG 기준)
- [x] 다크/라이트 모드 Toggle 스위치 컴포넌트
- [x] 홈화면: Drum Picker, 블러 보드 미리보기
- [x] 게임화면: 보드, 하트, 타이머, 힌트, 지우기
- [x] 메뉴·샵 바텀시트
- [x] Google Analytics 연동 (G-0YYCWGGJXK)
- [x] xAI 디자인 시스템 (Design.md 문서화)
- [x] Vercel 배포 완료

# 중요한 결정사항

## 케이스스터디
- **가짜 수치 전부 삭제**: 기존 버전의 90% 이탈률 등 전부 허구였음. 실데이터로만 재구성.
- **핵심 수치**: 가입자 1,519명 중 250명만 첫 글 작성 → 첫글 작성률 16.5% (GA4 실측)

## IR 덱
- **Ask 금액**: 1억 3,000만 원 (CMK 임팩트프레너 최대 금액 전액)
- **유료 사용자**: 30명 확정 (프로 21 + 플래티넘 7)
- **인프라 비용**: 현재 월 150만 → 확충 시 최대 500만 범위
- **GitHub**: https://github.com/ahnsick3k/llm

# 다음 세션에서 할 일

1. Google Slides로 실제 IR 덱 제작 (12슬라이드 구조)
2. CMK 임팩트프레너 공모 지원서 작성 (https://www.cmk-impactpreneur.kr/Apply)
3. Beautiful Sudoku iOS TestFlight 빌드
4. Beautiful Sudoku 웹앱 추가 개선 (필요 시)

# 주의사항

- GA4 데이터는 2025.11.01 ~ 2026.03.26 기준
- first_note_created 이벤트는 2026.01.25부터 트래킹 시작 (그 이전 모두 0)
- 3월 19일 스파이크(107건) 원인 불명 — 케이스스터디에 사용하지 않을 것

---

# Claude 행동 지침 (Claude Behavioral Guidelines)

이 파일은 iCloud Drive 워크스페이스 전반에 적용되는 Claude의 기본 행동 원칙을 정의합니다.

---

## 0. 비개발자 대상 커뮤니케이션

- 사용자는 비개발자다. 개발 전문 용어(예: git, repository, submodule, commit, branch, tracked 등)는 최대한 쓰지 않는다.
- 꼭 써야 할 경우 바로 옆에 괄호로 쉬운 말로 풀어 설명한다. 예: `커밋 (변경 내용 저장)`
- 명령어를 알려줄 때는 "이 명령어가 무엇을 하는지"를 먼저 일상적인 말로 설명한다.
- 기술적 선택지를 제시할 때는 비유나 실생활 예시를 활용한다.

## 1. 모르면 모른다

- 확신할 수 없는 내용은 **"모르겠습니다"** 또는 **"확인이 필요합니다"** 라고 명시한다.
- 추측을 사실처럼 제시하지 않는다.
- 불확실성 수준을 명시한다: `확실`, `추정`, `불확실`, `모름` 중 하나를 사용한다.

## 2. 출처 없으면 철회 또는 웹검색

- 근거 출처를 제시할 수 없는 주장은 즉시 철회하거나, 웹검색을 수행해 출처를 확보한다.
- 웹검색을 통해 출처를 보완한 경우 반드시 다음 태그를 응답 상단에 표시한다:

  ```
  [🔍 출처 부재로 웹검색 수행]
  ```

- 검색 결과에서 출처를 찾지 못한 경우, 해당 주장을 철회하고 이를 명시한다:

  ```
  [⚠️ 출처 미확인 — 해당 내용을 철회합니다]
  ```

## 3. 인용은 원문 그대로

- 문헌·발언·데이터를 인용할 때는 **원문을 변형하지 않고** 그대로 인용한다.
- 인용부호(`" "`)와 출처(저자, 문서명, 날짜, URL 등)를 함께 표기한다.
- 요약이 필요한 경우 인용과 요약을 명확히 분리한다:
  - **원문 인용**: `" … "` — 원문 그대로
  - **요약**: `[요약] …` — 내용을 재서술한 경우 명시

---

## 적용 범위

- 이 지침은 이 워크스페이스의 모든 대화 및 문서 작업에 적용된다.
- 개별 프로젝트 디렉토리에 `CLAUDE.md`가 있는 경우, 해당 파일이 우선 적용된다.

---

## 4. 세션 관리 루틴

### 세션 시작
```bash
tmux a  # 기존 세션 이어붙기
# 또는
tmux new-session -A -s main  # 없으면 새로 생성
```

### 세션 종료 (작업 이어갈 경우)
```bash
Ctrl + b, d  # tmux detach — 세션 백그라운드 유지
```

### 세션 마무리 루틴
1. Claude에게 요청: `CLAUDE.md 현재 상태로 업데이트해줘`
2. git 커밋:
```bash
git add .
git commit -m "YYYY-MM-DD: 작업 요약"
```

### 역할 분리
| 저장소 | 내용 |
|--------|------|
| `CLAUDE.md` | 현재 상태, 다음 할 일 (항상 최신) |
| `git log` | 날짜별 작업 히스토리 |

### 환경
- 접속: Termius → Tailscale → 맥북 SSH
- 맥북 잠자기 방지: 배터리 설정 → "Prevent automatic sleeping on power adapter when the display is off" 활성화

---

_최종 업데이트: 2026-05-04_

<!-- code-review-graph MCP tools -->
## MCP Tools: code-review-graph

**IMPORTANT: This project has a knowledge graph. ALWAYS use the
code-review-graph MCP tools BEFORE using Grep/Glob/Read to explore
the codebase.** The graph is faster, cheaper (fewer tokens), and gives
you structural context (callers, dependents, test coverage) that file
scanning cannot.

### When to use graph tools FIRST

- **Exploring code**: `semantic_search_nodes` or `query_graph` instead of Grep
- **Understanding impact**: `get_impact_radius` instead of manually tracing imports
- **Code review**: `detect_changes` + `get_review_context` instead of reading entire files
- **Finding relationships**: `query_graph` with callers_of/callees_of/imports_of/tests_for
- **Architecture questions**: `get_architecture_overview` + `list_communities`

Fall back to Grep/Glob/Read **only** when the graph doesn't cover what you need.

### Key Tools

| Tool | Use when |
|------|----------|
| `detect_changes` | Reviewing code changes — gives risk-scored analysis |
| `get_review_context` | Need source snippets for review — token-efficient |
| `get_impact_radius` | Understanding blast radius of a change |
| `get_affected_flows` | Finding which execution paths are impacted |
| `query_graph` | Tracing callers, callees, imports, tests, dependencies |
| `semantic_search_nodes` | Finding functions/classes by name or keyword |
| `get_architecture_overview` | Understanding high-level codebase structure |
| `refactor_tool` | Planning renames, finding dead code |

### Workflow

1. The graph auto-updates on file changes (via hooks).
2. Use `detect_changes` for code review.
3. Use `get_affected_flows` to understand impact.
4. Use `query_graph` pattern="tests_for" to check coverage.
