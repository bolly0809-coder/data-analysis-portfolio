"""
공급망 배송 지연 리스크 대시보드
================================
XGBoost 모델을 기반으로 주문의 배송 지연 리스크를 시각화한다.

실행 방법:
    streamlit run dashboard/app.py
"""

import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import matplotlib.font_manager as fm
import seaborn as sns
import pickle
import warnings
import os
from pathlib import Path

warnings.filterwarnings('ignore')

APP_DIR = Path(__file__).resolve().parent
PROJECT_DIR = APP_DIR.parent if APP_DIR.name == 'dashboard' else APP_DIR

def resolve_path(*candidates):
    for candidate in candidates:
        path = Path(candidate)
        if path.exists():
            return path
    raise FileNotFoundError(f'파일을 찾을 수 없습니다: {candidates}')

# 한글 폰트 설정
font_regular = 'C:/Windows/Fonts/malgun.ttf'
font_bold    = 'C:/Windows/Fonts/malgunbd.ttf'

if os.path.exists(font_regular):
    fm.fontManager.addfont(font_regular)
if os.path.exists(font_bold):
    fm.fontManager.addfont(font_bold)

plt.rcParams['font.family']        = 'Malgun Gothic'
plt.rcParams['font.sans-serif']    = ['Malgun Gothic']
plt.rcParams['axes.unicode_minus'] = False
plt.rcParams['figure.dpi']         = 100

# ── 페이지 기본 설정 ───────────────────────────────────────────────
st.set_page_config(
    page_title='배송 지연 리스크 대시보드',
    page_icon='📦',
    layout='wide'
)

# ── 모델 및 데이터 로드 (캐시 적용 — 새로고침해도 다시 안 불러옴) ──
@st.cache_resource
def load_model():
    """저장된 XGBoost 모델과 피처 컬럼 목록을 불러오는 함수"""
    model_path = resolve_path(PROJECT_DIR / 'dashboard' / 'model.pkl', APP_DIR / 'model.pkl', PROJECT_DIR / 'model.pkl')
    feature_path = resolve_path(PROJECT_DIR / 'dashboard' / 'feature_cols.pkl', APP_DIR / 'feature_cols.pkl', PROJECT_DIR / 'feature_cols.pkl')
    with open(model_path, 'rb') as f:
        model = pickle.load(f)
    with open(feature_path, 'rb') as f:
        feature_cols = pickle.load(f)
    return model, feature_cols

@st.cache_data
def load_data():
    """원본 데이터와 전처리 데이터를 불러오는 함수"""
    raw_path = resolve_path(PROJECT_DIR / 'data' / 'raw' / 'DataCoSupplyChainDataset.csv', PROJECT_DIR / 'DataCoSupplyChainDataset.csv')
    processed_path = resolve_path(PROJECT_DIR / 'data' / 'processed' / 'data_preprocessed.csv', PROJECT_DIR / 'data_preprocessed.csv')
    df_raw = pd.read_csv(raw_path, encoding='latin1')
    df_processed = pd.read_csv(processed_path)
    return df_raw, df_processed

model, feature_cols = load_model()
df_raw, df_processed = load_data()

# 전체 데이터에 리스크 스코어 산출
X_all = df_processed.drop(columns=['Late_delivery_risk'])
X_all = X_all.reindex(columns=feature_cols, fill_value=0)  # 컬럼 순서 맞추기
all_proba = model.predict_proba(X_all)[:, 1]

df_raw['risk_score'] = (all_proba * 100).round(1)
def classify_risk(score):
    if score < 40:
        return '낮음'
    elif score < 70:
        return '보통'
    else:
        return '높음'

df_raw['risk_level'] = df_raw['risk_score'].apply(classify_risk)

# ── 헤더 ────────────────────────────────────────────────────────────
st.title('📦 공급망 배송 지연 리스크 대시보드')
st.caption('DataCo Smart Supply Chain | XGBoost 기반 리스크 스코어링')
st.divider()

# ── 상단 요약 지표 (4개 카드) ───────────────────────────────────────
total     = len(df_raw)
high_cnt  = (df_raw['risk_level'] == '높음').sum()
mid_cnt   = (df_raw['risk_level'] == '보통').sum()
low_cnt   = (df_raw['risk_level'] == '낮음').sum()
avg_score = df_raw['risk_score'].mean()

col1, col2, col3, col4 = st.columns(4)

with col1:
    st.metric('전체 주문 수', f'{total:,}건')
with col2:
    st.metric('🔴 고위험 주문', f'{high_cnt:,}건',
              delta=f'{high_cnt/total*100:.1f}%', delta_color='inverse')
with col3:
    st.metric('🟡 보통 위험 주문', f'{mid_cnt:,}건',
              delta=f'{mid_cnt/total*100:.1f}%', delta_color='off')
with col4:
    st.metric('평균 리스크 스코어', f'{avg_score:.1f}점')

st.divider()

# ── 탭 구성 ─────────────────────────────────────────────────────────
tab1, tab2, tab3 = st.tabs(['📊 전체 현황', '🔍 단일 주문 예측', '📋 고위험 주문 목록'])


# ════════════════════════════════════════════════════════════════════
# TAB 1 — 전체 현황
# ════════════════════════════════════════════════════════════════════
with tab1:
    st.subheader('리스크 스코어 분포')

    col_a, col_b = st.columns(2)

    with col_a:
        # 리스크 스코어 히스토그램
        fig, ax = plt.subplots(figsize=(7, 4))
        ax.hist(df_raw['risk_score'], bins=50, color='#4C9BE8', alpha=0.85, edgecolor='white')
        ax.axvline(x=40, color='#F0AD4E', linestyle='--', linewidth=1.5, label='낮음/보통 경계 (40점)')
        ax.axvline(x=70, color='#E85C5C', linestyle='--', linewidth=1.5, label='보통/높음 경계 (70점)')
        ax.set_xlabel('리스크 스코어')
        ax.set_ylabel('주문 건수')
        ax.set_title('리스크 스코어 분포', fontweight='bold')
        ax.legend()
        st.pyplot(fig)
        plt.close()

    with col_b:
        # 위험 등급 도넛 차트
        level_counts = df_raw['risk_level'].value_counts()
        level_order  = ['낮음', '보통', '높음']
        counts = [level_counts.get(l, 0) for l in level_order]
        colors = ['#5CB85C', '#F0AD4E', '#E85C5C']

        fig, ax = plt.subplots(figsize=(7, 4))
        ax.pie(counts, labels=level_order, colors=colors,
               autopct='%1.1f%%', startangle=90,
               wedgeprops=dict(width=0.6))
        ax.set_title('위험 등급 비율', fontweight='bold')
        st.pyplot(fig)
        plt.close()

    st.divider()
    st.subheader('변수별 고위험 비율')
    st.caption('⚠️ 아래 차트는 모델이 산출한 고위험 스코어 기준입니다. 실제 지연율과 완전히 같은 의미가 아니며, 배송 방식 변수에 대한 모델 의존성이 반영될 수 있습니다.')

    col_c, col_d, col_e = st.columns(3)

    def plot_risk_bar(df, group_col, ax, title):
        """특정 컬럼 기준 고위험 비율 가로 막대 차트를 그리는 함수"""
        risk_rate = df.groupby(group_col)['risk_level'].apply(
            lambda x: (x == '높음').sum() / len(x) * 100
        ).sort_values(ascending=True)

        bar_colors = ['#E85C5C' if v > 30 else '#F0AD4E' if v > 15 else '#5CB85C'
                      for v in risk_rate.values]
        ax.barh(risk_rate.index, risk_rate.values, color=bar_colors)
        ax.set_title(title, fontweight='bold')
        ax.set_xlabel('고위험 비율 (%)')
        for i, v in enumerate(risk_rate.values):
            ax.text(v + 0.3, i, f'{v:.1f}%', va='center', fontsize=8)

    with col_c:
        fig, ax = plt.subplots(figsize=(5, 3.5))
        plot_risk_bar(df_raw, 'Shipping Mode', ax, '배송 방식별')
        plt.tight_layout()
        st.pyplot(fig)
        plt.close()

    with col_d:
        fig, ax = plt.subplots(figsize=(5, 3.5))
        plot_risk_bar(df_raw, 'Market', ax, '마켓별')
        plt.tight_layout()
        st.pyplot(fig)
        plt.close()

    with col_e:
        fig, ax = plt.subplots(figsize=(5, 3.5))
        plot_risk_bar(df_raw, 'Customer Segment', ax, '고객 유형별')
        plt.tight_layout()
        st.pyplot(fig)
        plt.close()


# ════════════════════════════════════════════════════════════════════
# TAB 2 — 단일 주문 예측
# ════════════════════════════════════════════════════════════════════
with tab2:
    st.subheader('주문 정보를 입력하면 리스크 스코어를 계산합니다')

    col_l, col_r = st.columns([1, 1])

    with col_l:
        st.markdown('**주문 기본 정보**')

        shipping_mode = st.selectbox(
            '배송 방식',
            ['Standard Class', 'Second Class', 'First Class', 'Same Day']
        )
        scheduled_days = st.slider('예정 배송 소요일', 1, 10, 4)
        order_status = st.selectbox(
            '주문 상태',
            ['COMPLETE', 'PENDING', 'PROCESSING', 'CLOSED',
             'PENDING_PAYMENT', 'SUSPECTED_FRAUD', 'ON_HOLD', 'PAYMENT_REVIEW']
        )
        market = st.selectbox(
            '배송 마켓',
            ['USCA', 'Europe', 'LATAM', 'Pacific Asia', 'Africa']
        )

    with col_r:
        st.markdown('**상품 및 고객 정보**')

        customer_segment = st.selectbox(
            '고객 유형',
            ['Consumer', 'Corporate', 'Home Office']
        )
        payment_type = st.selectbox(
            '결제 방식',
            ['DEBIT', 'TRANSFER', 'CASH', 'PAYMENT']
        )
        order_quantity = st.slider('주문 수량', 1, 10, 2)
        discount_rate  = st.slider('할인율 (%)', 0, 30, 5)
        product_price  = st.number_input('상품 가격 ($)', min_value=1.0, max_value=2000.0, value=50.0, step=10.0)
        order_month    = st.selectbox('주문 월', list(range(1, 13)), index=5)
        order_weekday  = st.selectbox('주문 요일', ['월(0)', '화(1)', '수(2)', '목(3)', '금(4)', '토(5)', '일(6)'])

    if st.button('🔍 리스크 스코어 계산', use_container_width=True):
        # 입력값으로 피처 벡터 구성
        # One-Hot Encoding된 피처 컬럼에 맞게 0으로 초기화 후 해당 컬럼만 1로 설정
        input_data = pd.DataFrame(0, index=[0], columns=feature_cols)

        # 수치형 피처 입력
        input_data['Days for shipment (scheduled)'] = scheduled_days
        input_data['Order Item Quantity']            = order_quantity
        input_data['Order Item Discount Rate']       = discount_rate / 100
        input_data['Product Price']                  = product_price
        input_data['Order Item Product Price']       = product_price
        input_data['order_month']                    = order_month
        input_data['order_weekday']                  = int(order_weekday[2])  # '월(0)' → 0

        # 범주형 피처 — One-Hot 방식으로 해당 컬럼에 1 설정
        col_map = {
            f'Shipping Mode_{shipping_mode}':       1,
            f'Market_{market}':                     1,
            f'Customer Segment_{customer_segment}': 1,
            f'Type_{payment_type}':                 1,
            f'Order Status_{order_status}':         1,
        }
        for col, val in col_map.items():
            if col in input_data.columns:
                input_data[col] = val

        # 예측
        risk_proba = model.predict_proba(input_data)[0][1]
        risk_score = round(float(risk_proba * 100), 1)

        # 위험 등급 판단
        if risk_score >= 70:
            level = '🔴 높음'
            color = '#E85C5C'
            msg   = '출고 우선순위, 예상 배송일, 사전 안내 여부를 우선 점검하세요.'
        elif risk_score >= 40:
            level = '🟡 보통'
            color = '#F0AD4E'
            msg   = '모니터링을 강화하고 이상 징후 발생 시 즉시 대응하세요.'
        else:
            level = '🟢 낮음'
            color = '#5CB85C'
            msg   = '정상 배송 가능성이 높습니다.'

        st.divider()
        col_score, col_msg = st.columns([1, 2])

        with col_score:
            st.markdown(f"""
            <div style='text-align:center; padding:20px;
                        border:2px solid {color}; border-radius:12px;'>
                <h2 style='color:{color}; margin:0;'>{risk_score:.1f}점</h2>
                <p style='font-size:18px; margin:6px 0;'>{level}</p>
                <p style='color:gray; font-size:13px; margin:0;'>리스크 스코어 (0~100)</p>
            </div>
            """, unsafe_allow_html=True)

        with col_msg:
            st.info(f'**{level} 위험**\n\n{msg}')
            # 스코어 게이지 바
            fig, ax = plt.subplots(figsize=(6, 1.2))
            ax.barh([''], [100], color='#f0f0f0', height=0.5)
            ax.barh([''], [risk_score], color=color, height=0.5)
            ax.axvline(x=40, color='#F0AD4E', linestyle='--', linewidth=1)
            ax.axvline(x=70, color='#E85C5C', linestyle='--', linewidth=1)
            ax.set_xlim(0, 100)
            ax.set_xlabel('리스크 스코어')
            ax.set_title(f'스코어: {risk_score:.1f}점', fontsize=10)
            ax.set_yticks([])
            plt.tight_layout()
            st.pyplot(fig)
            plt.close()


# ════════════════════════════════════════════════════════════════════
# TAB 3 — 고위험 주문 목록
# ════════════════════════════════════════════════════════════════════
with tab3:
    st.subheader('고위험 주문 목록 (리스크 스코어 70점 이상)')

    # 필터 옵션
    col_f1, col_f2, col_f3 = st.columns(3)
    with col_f1:
        filter_market = st.multiselect(
            '마켓 필터',
            options=df_raw['Market'].unique().tolist(),
            default=[]
        )
    with col_f2:
        filter_shipping = st.multiselect(
            '배송 방식 필터',
            options=df_raw['Shipping Mode'].unique().tolist(),
            default=[]
        )
    with col_f3:
        min_score = st.slider('최소 리스크 스코어', 70, 100, 70)

    # 필터 적용
    high_risk_df = df_raw[df_raw['risk_score'] >= min_score].copy()
    if filter_market:
        high_risk_df = high_risk_df[high_risk_df['Market'].isin(filter_market)]
    if filter_shipping:
        high_risk_df = high_risk_df[high_risk_df['Shipping Mode'].isin(filter_shipping)]

    high_risk_df = high_risk_df.sort_values('risk_score', ascending=False)

    st.caption(f'조건에 해당하는 주문: {len(high_risk_df):,}건')

    # 표시할 컬럼만 선택
    display_cols = [
        'Order Id', 'Shipping Mode', 'Market', 'Customer Segment',
        'Category Name', 'Days for shipment (scheduled)',
        'Order Profit Per Order', 'risk_score'
    ]
    display_cols = [c for c in display_cols if c in high_risk_df.columns]

    # 예정 배송일 정수로 변환 (소수점 제거)
    if 'Days for shipment (scheduled)' in high_risk_df.columns:
        high_risk_df['Days for shipment (scheduled)'] = high_risk_df['Days for shipment (scheduled)'].fillna(0).astype(int)

    st.dataframe(
        high_risk_df[display_cols].head(200).rename(columns={
            'Order Id':                      '주문 ID',
            'Shipping Mode':                 '배송 방식',
            'Market':                        '마켓',
            'Customer Segment':              '고객 유형',
            'Category Name':                 '카테고리',
            'Days for shipment (scheduled)': '예정 배송일',
            'Order Profit Per Order':        '주문 이익($)',
            'risk_score':                    '리스크 스코어',
        }),
        use_container_width=True,
        height=400
    )

    # 고위험 주문 카테고리 분포
    st.divider()
    st.subheader('고위험 주문 카테고리 분포 (TOP 10)')

    cat_counts = high_risk_df['Category Name'].value_counts().head(10)

    fig, ax = plt.subplots(figsize=(10, 4))
    ax.barh(cat_counts.index[::-1], cat_counts.values[::-1], color='#E85C5C', alpha=0.85)
    ax.set_xlabel('주문 건수')
    ax.set_title('고위험 주문 카테고리 TOP 10', fontweight='bold')
    for i, v in enumerate(cat_counts.values[::-1]):
        ax.text(v + 10, i, f'{v:,}건', va='center', fontsize=9)
    plt.tight_layout()
    st.pyplot(fig)
    plt.close()

# ── 푸터 ────────────────────────────────────────────────────────────
st.divider()
st.caption('DataCo Smart Supply Chain Dataset | XGBoost 배송 지연 리스크 스코어링 프로젝트')
