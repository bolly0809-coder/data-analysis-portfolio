"""
Step 7. Visualization script for ecommerce ranking analysis

Inputs:
- unique_product_ecommerce_with_keywords.csv
- step5_overlap_summary.csv
- step6_keyword_overall.csv

Outputs:
- SVG charts under images/

This script documents the visualization logic used for the portfolio project.
"""

from pathlib import Path
import math
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


BASE_DIR = Path(".")
IMAGE_DIR = BASE_DIR / "images"
IMAGE_DIR.mkdir(exist_ok=True)


def set_korean_font():
    """Set a Korean font if available. Safe to skip when unavailable."""
    try:
        from matplotlib import font_manager
        font_path = "/usr/share/fonts/truetype/nanum/NanumGothic.ttf"
        font_manager.fontManager.addfont(font_path)
        plt.rcParams["font.family"] = "NanumGothic"
        plt.rcParams["axes.unicode_minus"] = False
    except Exception:
        pass


def plot_price_distribution(unique_df):
    order = ["coupang", "naver_shopping"]
    labels = ["쿠팡", "네이버쇼핑"]
    data = [unique_df.loc[unique_df["platform"] == p, "price"].dropna() for p in order]

    plt.figure(figsize=(9, 5.5))
    plt.boxplot(data, tick_labels=labels, showfliers=False)
    plt.title("플랫폼별 가격 분포")
    plt.xlabel("플랫폼")
    plt.ylabel("가격(원)")
    plt.grid(axis="y", alpha=0.3)
    plt.tight_layout()
    plt.savefig(IMAGE_DIR / "price_distribution_by_platform.svg")
    plt.close()


def plot_review_distribution(unique_df):
    order = ["coupang", "naver_shopping"]
    labels = ["쿠팡", "네이버쇼핑"]
    data = [unique_df.loc[unique_df["platform"] == p, "review_count"].dropna() for p in order]

    plt.figure(figsize=(9, 5.5))
    plt.boxplot(data, tick_labels=labels, showfliers=False)
    plt.yscale("log")
    plt.title("플랫폼별 리뷰 수 분포")
    plt.xlabel("플랫폼")
    plt.ylabel("리뷰 수(log scale)")
    plt.grid(axis="y", alpha=0.3)
    plt.tight_layout()
    plt.savefig(IMAGE_DIR / "review_distribution_by_platform.svg")
    plt.close()


def plot_price_vs_review(unique_df):
    label_map = {"coupang": "쿠팡", "naver_shopping": "네이버쇼핑"}

    plt.figure(figsize=(9, 5.5))
    for platform, label in label_map.items():
        temp = unique_df[unique_df["platform"] == platform]
        plt.scatter(temp["price"], temp["review_count"], label=label, alpha=0.7)

    plt.yscale("log")
    plt.title("가격과 리뷰 수 관계")
    plt.xlabel("가격(원)")
    plt.ylabel("리뷰 수(log scale)")
    plt.legend()
    plt.grid(alpha=0.3)
    plt.tight_layout()
    plt.savefig(IMAGE_DIR / "price_vs_review_scatter.svg")
    plt.close()


def plot_keyword_top20(keyword_df):
    kw = keyword_df.sort_values("mention_count", ascending=False).head(20)
    kw = kw.sort_values("mention_count", ascending=True)

    plt.figure(figsize=(9, 7))
    plt.barh(kw["keyword"], kw["mention_count"])
    plt.title("상품명 소구 키워드 TOP20")
    plt.xlabel("언급 횟수")
    plt.ylabel("키워드")
    plt.grid(axis="x", alpha=0.3)
    plt.tight_layout()
    plt.savefig(IMAGE_DIR / "keyword_top20.svg")
    plt.close()


def plot_overlap(overlap_df):
    x = np.arange(len(overlap_df))
    width = 0.35

    plt.figure(figsize=(9, 5.5))
    plt.bar(x - width / 2, overlap_df["overlap_count"], width, label="겹침 상품 수")
    plt.bar(x + width / 2, overlap_df["union_count"], width, label="합집합 상품 수")
    plt.xticks(x, overlap_df["comparison"], rotation=15, ha="right")
    plt.title("랭킹 기준별 상품 구성 겹침 비교")
    plt.ylabel("상품 수")
    plt.legend()
    plt.grid(axis="y", alpha=0.3)
    plt.tight_layout()
    plt.savefig(IMAGE_DIR / "ranking_overlap_comparison.svg")
    plt.close()


if __name__ == "__main__":
    set_korean_font()

    unique_df = pd.read_csv("data/unique_product_ecommerce_with_keywords.csv")
    keyword_df = pd.read_csv("data/step6_keyword_overall.csv")
    overlap_df = pd.read_csv("data/step5_overlap_summary.csv")

    plot_price_distribution(unique_df)
    plot_review_distribution(unique_df)
    plot_price_vs_review(unique_df)
    plot_keyword_top20(keyword_df)
    plot_overlap(overlap_df)
