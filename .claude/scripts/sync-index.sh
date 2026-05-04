#!/bin/bash
# sync-index.sh
# 목적: LLM 디렉토리에서 INDEX.md 없는 새 폴더를 찾아 자동 생성하고,
#       루트 INDEX.md의 디렉토리 목록도 최신 상태로 업데이트한다.

BASE="$HOME/Library/Mobile Documents/com~apple~CloudDocs/LLM"
LOG="$BASE/.claude/scripts/sync-index.log"
SKIP=("_archive" ".git" ".obsidian" ".superset" ".claude" "node_modules" "tilnote-work")

echo "[$(date '+%Y-%m-%d %H:%M:%S')] sync-index 시작" >> "$LOG"

for dir in "$BASE"/*/; do
  dirname=$(basename "$dir")

  # 스킵 목록 확인
  skip=false
  for s in "${SKIP[@]}"; do
    [[ "$dirname" == "$s" ]] && skip=true && break
  done
  $skip && continue

  # INDEX.md가 없으면 Claude 헤드리스로 생성
  if [[ ! -f "$dir/INDEX.md" ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 새 디렉토리 발견: $dirname — INDEX.md 생성 중..." >> "$LOG"

    claude -p "
워크스페이스: $BASE
대상 디렉토리: $dir

이 디렉토리의 INDEX.md를 생성해줘.
규칙:
1. 디렉토리 안의 파일과 하위 폴더를 전부 읽는다.
2. 첫 줄: 이 폴더의 목적을 한 문장으로 정의한다.
3. 파일 목록을 표(파일명 | 내용 설명)로 정리한다.
4. 하위 폴더가 있으면 폴더별로 섹션을 나눈다.
5. Claude가 이 폴더로 작업할 때 알아야 할 주의사항을 마지막에 적는다.
6. 언어는 한국어, 형식은 Markdown.

파일을 $dir/INDEX.md 에 저장해줘.
" --allowedTools "Read,Glob,Write" 2>> "$LOG"

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 완료: $dirname/INDEX.md 생성됨" >> "$LOG"
  fi
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] sync-index 완료" >> "$LOG"
