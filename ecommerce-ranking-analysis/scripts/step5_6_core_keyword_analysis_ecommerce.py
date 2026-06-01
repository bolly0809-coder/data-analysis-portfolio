"""
Step 5~6. Core EDA and keyword analysis for ecommerce ranking project

Inputs:
- cleaned_ecommerce_ranking.csv
- ranking_view_ecommerce.csv
- unique_product_ecommerce.csv

Outputs:
- platform/ranking summaries
- overlap summary
- keyword frequency summary

This script documents the analysis logic used for the portfolio project.
"""

import pandas as pd
import numpy as np


KEYWORD_DICT = {
    "비타민": ["비타민", "vitamin"],
    "유산균": ["유산균", "프로바이오틱스", "probiotics"],
    "오메가3": ["오메가3", "omega"],
    "루테인": ["루테인", "lutein"],
    "밀크씨슬": ["밀크씨슬", "실리마린"],
    "마그네슘": ["마그네슘", "magnesium"],
    "칼슘": ["칼슘", "calcium"],
    "아연": ["아연", "zinc"],
    "홍삼": ["홍삼", "인삼"],
    "단백질": ["단백질", "프로틴", "protein"],
    "다이어트": ["다이어트", "diet"],
    "관절": ["관절", "joint"],
    "효소": ["효소"],
    "코엔자임": ["코엔자임", "coq10", "코큐텐"],
    "콜라겐": ["콜라겐", "collagen"],
    "아르기닌": ["아르기닌", "arginine"],
    "장건강": ["장건강"],
    "면역": ["면역"],
    "여성": ["여성", "우먼", "woman", "women"],
    "남성": ["남성", "맨", "man", "men"],
    "어린이": ["어린이", "키즈", "kids", "아이"],
    "부모님/시니어": ["부모님", "시니어", "어르신"],
    "프리미엄": ["프리미엄", "premium"],
    "대용량": ["대용량"],
    "분말/스틱": ["분말", "스틱", "파우더"],
    "캡슐/정": ["캡슐", "정", "타블렛", "tablet"],
    "선물/세트": ["선물", "세트", "기프트"],
    "국내/인증": ["국내", "인증", "식약처"],
    "혈행": ["혈행"],
    "피로/활력": ["피로", "활력", "에너지"],
    "수면/스트레스": ["수면", "스트레스"],
    "저당/무첨가": ["저당", "무첨가", "무설탕"],
}


def summarize_by_platform(unique_df):
    return unique_df.groupby("platform").agg(
        unique_product_count=("product_key", "nunique"),
        median_price=("price", "median"),
        mean_price=("price", "mean"),
        median_review_count=("review_count", "median"),
        mean_review_count=("review_count", "mean"),
        median_rating=("rating", "median"),
        mean_rating=("rating", "mean"),
    ).reset_index()


def summarize_by_ranking(ranking_df):
    return ranking_df.groupby(["platform", "ranking_type"]).agg(
        row_count=("product_name", "count"),
        unique_product_count=("product_key", "nunique"),
        median_price=("price", "median"),
        median_review_count=("review_count", "median"),
        median_rating=("rating", "median"),
    ).reset_index()


def overlap_summary(df, a_label, b_label):
    a = set(df.loc[df["ranking_type"] == a_label, "product_key"])
    b = set(df.loc[df["ranking_type"] == b_label, "product_key"])
    inter = a & b
    union = a | b
    return {
        "comparison": f"{a_label} vs {b_label}",
        "a_count": len(a),
        "b_count": len(b),
        "overlap_count": len(inter),
        "union_count": len(union),
        "jaccard": round(len(inter) / len(union), 4) if union else 0,
        "overlap_rate_a": round(len(inter) / len(a), 4) if a else 0,
        "overlap_rate_b": round(len(inter) / len(b), 4) if b else 0,
    }


def match_keywords(title):
    text = str(title).lower()
    matched = []
    for keyword, patterns in KEYWORD_DICT.items():
        if any(p.lower() in text for p in patterns):
            matched.append(keyword)
    return matched


def keyword_summary(df, group_name="전체"):
    total_products = df["product_key"].nunique()
    rows = []
    for keyword in KEYWORD_DICT:
        mask = df["matched_keywords"].apply(lambda x: keyword in x)
        product_count = df.loc[mask, "product_key"].nunique()
        mention_count = df.loc[mask, "matched_keywords"].apply(lambda xs: xs.count(keyword)).sum()
        rows.append({
            "group": group_name,
            "keyword": keyword,
            "product_count": product_count,
            "mention_count": mention_count,
            "product_ratio": round(product_count / total_products, 4) if total_products else 0,
        })
    return pd.DataFrame(rows).sort_values("mention_count", ascending=False)


if __name__ == "__main__":
    ranking_df = pd.read_csv("ranking_view_ecommerce.csv")
    unique_df = pd.read_csv("unique_product_ecommerce.csv")

    platform_summary = summarize_by_platform(unique_df)
    ranking_summary = summarize_by_ranking(ranking_df)

    overlap_rows = []
    overlap_rows.append(overlap_summary(ranking_df[ranking_df["platform"] == "coupang"], "쿠팡랭킹순", "판매량순"))
    overlap_rows.append(overlap_summary(ranking_df[ranking_df["platform"] == "naver_shopping"], "많이구매한BEST_일간", "많이구매한BEST_주간"))
    overlap_df = pd.DataFrame(overlap_rows)

    unique_df["matched_keywords"] = unique_df["product_name"].apply(match_keywords)
    ranking_df["matched_keywords"] = ranking_df["product_name"].apply(match_keywords)
    kw_overall = keyword_summary(unique_df, "전체")

    platform_summary.to_csv("step5_platform_unique_summary.csv", index=False, encoding="utf-8-sig")
    ranking_summary.to_csv("step5_ranking_summary.csv", index=False, encoding="utf-8-sig")
    overlap_df.to_csv("step5_overlap_summary.csv", index=False, encoding="utf-8-sig")
    kw_overall.to_csv("step6_keyword_overall.csv", index=False, encoding="utf-8-sig")
