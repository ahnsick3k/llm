"""
틸노트 GA4 데이터 리포트
========================
이 스크립트는 GA4에서 케이스스터디에 필요한 데이터를 뽑아옵니다.

실행 전 필요한 패키지 설치:
  pip install google-analytics-data google-auth-oauthlib

실행 방법:
  python ga4_report.py
"""

import os
import json
from datetime import datetime

from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from google.analytics.data_v1beta import BetaAnalyticsDataClient
from google.analytics.data_v1beta.types import (
    RunReportRequest,
    DateRange,
    Dimension,
    Metric,
    OrderBy,
    FilterExpression,
    Filter,
)

# ── 설정 ──────────────────────────────────────────────────────────────
PROPERTY_ID  = "309589221"
SCOPES       = ["https://www.googleapis.com/auth/analytics.readonly"]
CREDENTIALS  = os.path.join(os.path.dirname(__file__), "credentials.json")
TOKEN_GA     = os.path.join(os.path.dirname(__file__), "token_ga.json")   # 기존 token.json과 별개

# 리포트 기간 설정 (리뉴얼 전·후 비교)
PERIOD_BEFORE = ("2025-09-01", "2025-11-30")   # 리뉴얼 전
PERIOD_AFTER  = ("2025-12-01", "2026-03-25")   # 리뉴얼 후
PERIOD_FULL   = ("2025-09-01", "2026-03-25")   # 전체

# ── 인증 ──────────────────────────────────────────────────────────────
def get_credentials():
    creds = None
    if os.path.exists(TOKEN_GA):
        creds = Credentials.from_authorized_user_file(TOKEN_GA, SCOPES)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(CREDENTIALS, SCOPES)
            creds = flow.run_local_server(port=0)
        with open(TOKEN_GA, "w") as f:
            f.write(creds.to_json())
    return creds


def get_client():
    creds = get_credentials()
    return BetaAnalyticsDataClient(credentials=creds)


# ── 리포트 함수들 ──────────────────────────────────────────────────────

def run_report(client, request):
    """GA4 리포트 실행 후 행(row) 리스트 반환"""
    response = client.run_report(request)
    rows = []
    for row in response.rows:
        d = {response.dimension_headers[i].name: row.dimension_values[i].value
             for i in range(len(response.dimension_headers))}
        m = {response.metric_headers[i].name: row.metric_values[i].value
             for i in range(len(response.metric_headers))}
        rows.append({**d, **m})
    return rows


def report_01_overview(client):
    """1. 전체 개요: 신규유저 / 세션 / 참여율 (전·후 비교)"""
    print("\n" + "="*60)
    print("📊 리포트 1 — 신규유저·세션·참여율 (전·후 비교)")
    print("="*60)

    for label, (start, end) in [("리뉴얼 전", PERIOD_BEFORE), ("리뉴얼 후", PERIOD_AFTER)]:
        rows = run_report(client, RunReportRequest(
            property=f"properties/{PROPERTY_ID}",
            date_ranges=[DateRange(start_date=start, end_date=end)],
            metrics=[
                Metric(name="newUsers"),
                Metric(name="sessions"),
                Metric(name="engagementRate"),
                Metric(name="averageSessionDuration"),
                Metric(name="bounceRate"),
            ],
        ))
        if rows:
            r = rows[0]
            print(f"\n  [{label}] {start} ~ {end}")
            print(f"    신규 유저           : {int(r.get('newUsers', 0)):,}명")
            print(f"    세션 수             : {int(r.get('sessions', 0)):,}회")
            print(f"    참여율              : {float(r.get('engagementRate', 0))*100:.1f}%")
            print(f"    평균 세션 시간       : {float(r.get('averageSessionDuration', 0)):.0f}초")
            print(f"    이탈률              : {float(r.get('bounceRate', 0))*100:.1f}%")


def report_02_monthly_users(client):
    """2. 월별 신규유저 추이 (리뉴얼 전·후 흐름 파악)"""
    print("\n" + "="*60)
    print("📊 리포트 2 — 월별 신규유저 추이")
    print("="*60)

    rows = run_report(client, RunReportRequest(
        property=f"properties/{PROPERTY_ID}",
        date_ranges=[DateRange(start_date=PERIOD_FULL[0], end_date=PERIOD_FULL[1])],
        dimensions=[Dimension(name="yearMonth")],
        metrics=[
            Metric(name="newUsers"),
            Metric(name="sessions"),
            Metric(name="engagementRate"),
        ],
        order_bys=[OrderBy(dimension=OrderBy.DimensionOrderBy(dimension_name="yearMonth"))],
    ))
    print(f"\n  {'월':>8}  {'신규유저':>10}  {'세션':>8}  {'참여율':>8}")
    print("  " + "-"*44)
    for r in rows:
        ym = r.get("yearMonth", "")
        label = f"{ym[:4]}-{ym[4:]}" if len(ym) == 6 else ym
        print(f"  {label:>8}  {int(r.get('newUsers',0)):>10,}  "
              f"{int(r.get('sessions',0)):>8,}  "
              f"{float(r.get('engagementRate',0))*100:>7.1f}%")


def report_03_all_events(client):
    """3. 모든 이벤트 목록 + 발생 횟수 (어떤 데이터가 쌓였는지 확인)"""
    print("\n" + "="*60)
    print("📊 리포트 3 — 이벤트 전체 목록 (전체 기간)")
    print("="*60)

    rows = run_report(client, RunReportRequest(
        property=f"properties/{PROPERTY_ID}",
        date_ranges=[DateRange(start_date=PERIOD_FULL[0], end_date=PERIOD_FULL[1])],
        dimensions=[Dimension(name="eventName")],
        metrics=[Metric(name="eventCount")],
        order_bys=[OrderBy(
            metric=OrderBy.MetricOrderBy(metric_name="eventCount"),
            desc=True,
        )],
        limit=50,
    ))

    print(f"\n  {'이벤트명':<40}  {'발생 횟수':>10}")
    print("  " + "-"*54)
    for r in rows:
        print(f"  {r.get('eventName',''):<40}  {int(r.get('eventCount',0)):>10,}")

    print("\n  ★ 위 목록에서 '첫 글 작성', 'Agent 사용' 관련 이벤트명을 확인하세요.")
    return [r.get("eventName","") for r in rows]


def report_04_new_user_events(client):
    """4. 신규유저(가입 7일 이내) 행동 패턴"""
    print("\n" + "="*60)
    print("📊 리포트 4 — 신규유저 행동 패턴 (전·후 비교)")
    print("="*60)

    for label, (start, end) in [("리뉴얼 전", PERIOD_BEFORE), ("리뉴얼 후", PERIOD_AFTER)]:
        rows = run_report(client, RunReportRequest(
            property=f"properties/{PROPERTY_ID}",
            date_ranges=[DateRange(start_date=start, end_date=end)],
            dimensions=[Dimension(name="newVsReturning")],
            metrics=[
                Metric(name="sessions"),
                Metric(name="engagementRate"),
                Metric(name="averageSessionDuration"),
                Metric(name="eventCount"),
            ],
        ))
        print(f"\n  [{label}] {start} ~ {end}")
        print(f"  {'구분':<15}  {'세션':>8}  {'참여율':>8}  {'평균시간(초)':>12}  {'이벤트수':>10}")
        print("  " + "-"*60)
        for r in rows:
            nv = r.get("newVsReturning", "")
            label_nv = "신규 유저" if nv == "new" else "재방문 유저" if nv == "returning" else nv
            print(f"  {label_nv:<15}  {int(r.get('sessions',0)):>8,}  "
                  f"{float(r.get('engagementRate',0))*100:>7.1f}%  "
                  f"{float(r.get('averageSessionDuration',0)):>12.0f}  "
                  f"{int(r.get('eventCount',0)):>10,}")


def report_05_page_path(client):
    """5. 페이지별 이탈 — 에디터 진입 후 어디서 나가는지"""
    print("\n" + "="*60)
    print("📊 리포트 5 — 주요 페이지 방문·이탈 (전체 기간)")
    print("="*60)

    rows = run_report(client, RunReportRequest(
        property=f"properties/{PROPERTY_ID}",
        date_ranges=[DateRange(start_date=PERIOD_FULL[0], end_date=PERIOD_FULL[1])],
        dimensions=[Dimension(name="pagePath")],
        metrics=[
            Metric(name="sessions"),
            Metric(name="bounceRate"),
            Metric(name="engagementRate"),
        ],
        order_bys=[OrderBy(
            metric=OrderBy.MetricOrderBy(metric_name="sessions"),
            desc=True,
        )],
        limit=20,
    ))

    print(f"\n  {'페이지 경로':<35}  {'세션':>8}  {'이탈률':>8}  {'참여율':>8}")
    print("  " + "-"*64)
    for r in rows:
        path = r.get("pagePath", "")[:34]
        print(f"  {path:<35}  {int(r.get('sessions',0)):>8,}  "
              f"{float(r.get('bounceRate',0))*100:>7.1f}%  "
              f"{float(r.get('engagementRate',0))*100:>7.1f}%")


def report_06_device(client):
    """6. 기기별 (모바일 vs 웹 비중 확인)"""
    print("\n" + "="*60)
    print("📊 리포트 6 — 기기 유형별 접속 비중")
    print("="*60)

    rows = run_report(client, RunReportRequest(
        property=f"properties/{PROPERTY_ID}",
        date_ranges=[DateRange(start_date=PERIOD_FULL[0], end_date=PERIOD_FULL[1])],
        dimensions=[Dimension(name="deviceCategory")],
        metrics=[
            Metric(name="sessions"),
            Metric(name="engagementRate"),
        ],
        order_bys=[OrderBy(
            metric=OrderBy.MetricOrderBy(metric_name="sessions"),
            desc=True,
        )],
    ))

    print(f"\n  {'기기':<12}  {'세션':>8}  {'참여율':>8}")
    print("  " + "-"*32)
    for r in rows:
        print(f"  {r.get('deviceCategory',''):<12}  "
              f"{int(r.get('sessions',0)):>8,}  "
              f"{float(r.get('engagementRate',0))*100:>7.1f}%")


# ── 메인 ──────────────────────────────────────────────────────────────

def main():
    print("\n🔐 Google Analytics 인증 중...")
    print("   (브라우저가 열리면 Google 계정으로 로그인하고 권한을 허용해주세요)\n")

    client = get_client()
    print("✅ 인증 완료!\n")

    report_01_overview(client)
    report_02_monthly_users(client)
    report_03_all_events(client)
    report_04_new_user_events(client)
    report_05_page_path(client)
    report_06_device(client)

    print("\n" + "="*60)
    print("✅ 리포트 완료!")
    print("   위 데이터를 스크린샷 찍거나 터미널 출력을 복사해서 공유해주세요.")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()
