#!/usr/bin/env python3
"""
Generate the root learning-path diagram (assets/learning-path.png) covering
all current chapters, in French, as a grid of numbered cards.
Usage: python .github/scripts/generate-learning-path.py
"""

from PIL import Image, ImageDraw, ImageFont
import os

# Short French labels for the diagram cards (kept intentionally brief —
# the full chapter titles live in generate-chapter-headers.py).
CHAPTERS = [
    ("00", "Terminal"),
    ("01", "Démarrage"),
    ("02", "Premiers pas"),
    ("03", "Contexte"),
    ("04", "Workflows"),
    ("05", "Agents"),
    ("06", "Skills"),
    ("07", "MCP"),
    ("08", "Synthèse"),
    ("09", "Isolation"),
    ("10", "RAG Obsidian"),
    ("11", "Sécurité"),
    ("12", "Acceptation IA"),
    ("13", "/chronicle"),
    ("14", "Tokens"),
    ("15", "Prompts"),
    ("16", "Worktrees"),
    ("17", "mcp2cli"),
    ("18", "n8n"),
]

COLS = 5
CARD_W, CARD_H = 288, 190
GAP_X, GAP_Y = 22, 40
MARGIN = 40

BG = (10, 16, 34)
CARD_BG = (15, 26, 48)
BORDER = (46, 196, 222)
NUMBER_C = (72, 214, 235)
LABEL_C = (255, 255, 255)
ARROW_C = (70, 90, 120)

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(os.path.dirname(SCRIPT_DIR))
FONT_DIR = "/usr/share/fonts/truetype/dejavu"


def font(size, bold=False):
    name = "DejaVuSans-Bold.ttf" if bold else "DejaVuSans.ttf"
    return ImageFont.truetype(os.path.join(FONT_DIR, name), size)


def main():
    rows = (len(CHAPTERS) + COLS - 1) // COLS
    width = MARGIN * 2 + COLS * CARD_W + (COLS - 1) * GAP_X
    height = MARGIN * 2 + rows * CARD_H + (rows - 1) * GAP_Y

    img = Image.new("RGB", (width, height), BG)
    draw = ImageDraw.Draw(img)

    num_font = font(30, bold=True)
    label_font = font(20, bold=True)

    positions = []
    for i, (num, label) in enumerate(CHAPTERS):
        col = i % COLS
        row = i // COLS
        x0 = MARGIN + col * (CARD_W + GAP_X)
        y0 = MARGIN + row * (CARD_H + GAP_Y)
        x1, y1 = x0 + CARD_W, y0 + CARD_H
        positions.append((x0, y0, x1, y1, row, col))

        draw.rounded_rectangle((x0, y0, x1, y1), radius=16, fill=CARD_BG, outline=BORDER, width=2)

        num_text = f"Chapitre {num}"
        nb = draw.textbbox((0, 0), num_text, font=num_font)
        draw.text((x0 + (CARD_W - (nb[2]-nb[0])) / 2, y0 + 28), num_text, font=num_font, fill=NUMBER_C)

        lb = draw.textbbox((0, 0), label, font=label_font)
        lw = lb[2] - lb[0]
        if lw > CARD_W - 30:
            lf = label_font
            size = 20
            while lw > CARD_W - 30 and size > 12:
                size -= 1
                lf = font(size, bold=True)
                lb = draw.textbbox((0, 0), label, font=lf)
                lw = lb[2] - lb[0]
        else:
            lf = label_font
        draw.text((x0 + (CARD_W - lw) / 2, y0 + 110), label, font=lf, fill=LABEL_C)

    # horizontal arrows within each row
    arrow_font = font(22, bold=True)
    for x0, y0, x1, y1, row, col in positions:
        if col < COLS - 1 and (row * COLS + col + 1) < len(CHAPTERS):
            mid_y = (y0 + y1) // 2
            ax0 = x1 + 4
            ax1 = x0 + CARD_W + GAP_X - 4
            draw.line((ax0, mid_y, ax1 - 8, mid_y), fill=ARROW_C, width=3)
            draw.polygon(
                [(ax1 - 8, mid_y - 7), (ax1 - 8, mid_y + 7), (ax1, mid_y)],
                fill=ARROW_C,
            )

    out_path = os.path.join(PROJECT_ROOT, "assets", "learning-path.png")
    img.save(out_path)
    print(f"Saved {out_path} ({width}x{height}, {len(CHAPTERS)} chapters)")


if __name__ == "__main__":
    main()
