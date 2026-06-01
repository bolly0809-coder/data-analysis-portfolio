"""
Step 2. Ecommerce ranking data preprocessing

Inputs:
- Raw Coupang/Naver Shopping ranking files collected separately

Outputs used in this portfolio:
- cleaned_ecommerce_ranking.csv

Note:
The full raw collection files are not included in this public repository.
This script documents the preprocessing logic used for the project.
"""

import re
import unicodedata
import numpy as np
import pandas as pd


def to_number(value):
    """Convert price/review-like strings to numeric values."""
    if pd.isna(value):
        return np.nan
    text = str(value)
    text = re.sub(r"[^0-9.]", "", text)
    if text == "":
        return np.nan
    return float(text)


def normalize_product_name(text):
    """Create a conservative product key for duplicate checking."""
    if pd.isna(text):
        return ""

    text = unicodedata.normalize("NFKC", str(text)).lower()
    text = re.sub(r"[\[\]\(\)\{\}|/,_+·ㆍ]", " ", text)
    text = re.sub(r"[^0-9a-zA-Z가-힣\s]", " ", text)

    remove_words = [
        "무료배송", "로켓배송", "로켓직구", "판매자로켓", "쿠팡",
        "정품", "공식", "본사직영", "특가", "행사", "증정",
    ]
    for word in remove_words:
        text = text.replace(word, " ")

    quantity_patterns = [
        r"\b\d+\s*[xX]\s*\d+\b",
        r"\b\d+\s*[xX]\b",
        r"\b[xX]\s*\d+\b",
        r"\b\d+\s*(개|개입|팩|박스|세트|통|병|봉|포|정|캡슐|스틱|개월분|일분)\b",
        r"\b\d+\s*(ea|pack|packs|box|boxes|set|sets|tabs|tablet|tablets|capsule|capsules|stick|sticks)\b",
        r"\b\d+\s*\+\s*\d+\b",
    ]
    for pattern in quantity_patterns:
        text = re.sub(pattern, " ", text)

    text = re.sub(r"\s+", " ", text).strip()
    return text


def add_features(df):
    """Add analysis-ready features."""
    df = df.copy()

    for col in ["price", "original_price", "discount_rate", "review_count", "rating"]:
        if col in df.columns:
            df[col] = df[col].apply(to_number)

    df["product_key"] = df["product_name"].apply(normalize_product_name)
    df["is_top20"] = df["rank"] <= 20
    df["log_review_count"] = np.log1p(df["review_count"].fillna(0))

    df["price_group"] = pd.qcut(
        df["price"].rank(method="first"),
        q=3,
        labels=["low", "mid", "high"],
    )
    df["review_group"] = pd.qcut(
        df["review_count"].rank(method="first"),
        q=3,
        labels=["low", "mid", "high"],
    )
    return df


if __name__ == "__main__":
    print("This script documents preprocessing logic. Run it after preparing the integrated raw table.")
