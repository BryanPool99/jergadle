"""Genera los iconos de Jergadle (web + Android) y las imagenes de marca.

Uso:
    python scripts/generate_icons.py

El diseno es un tablero 2x2 con los tres colores del juego y la celda
acento con la "J" de Jergadle. La "J" solo se dibuja cuando la celda es lo
suficientemente grande para que se lea (>= 44 px), de modo que el favicon de
16 px se quede en un tablero de cuatro bloques limpios.
"""

import os
from PIL import Image, ImageDraw, ImageFont

# --- Paleta (identica a lib/core/theme/app_theme.dart) ---
BG = (0x12, 0x12, 0x13, 255)
GREEN = (0x53, 0x8D, 0x4E, 255)
YELLOW = (0xB5, 0x9F, 0x3B, 255)
GRAY = (0x3A, 0x3A, 0x3C, 255)
GOLD = (0xE0, 0xA9, 0x3B, 255)
INK = (0x12, 0x12, 0x13, 255)

SS = 4  # supersampling para el antialiasing
FONT_BOLD = r"C:\Windows\Fonts\arialbd.ttf"

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def rounded_rect(draw, box, radius, fill):
    draw.rounded_rectangle(box, radius=radius, fill=fill)


def draw_grid(size, grid_ratio, radius_ratio, gap_ratio, letter=True,
              background=BG, rounded_outer=False):
    """Dibuja el icono de Jergadle en un lienzo de `size` px."""
    canvas = Image.new("RGBA", (size * SS, size * SS), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    s = size * SS

    if rounded_outer:
        rounded_rect(draw, (0, 0, s - 1, s - 1), int(size * 0.22 * SS), background)
    else:
        draw.rectangle((0, 0, s - 1, s - 1), fill=background)

    grid = s * grid_ratio
    gap = s * gap_ratio
    cell = (grid - gap) / 2
    origin = (s - grid) / 2
    radius = max(1, int(cell * radius_ratio))

    colors = [GREEN, YELLOW, GRAY, GOLD]
    for i, color in enumerate(colors):
        row, col = divmod(i, 2)
        x0 = origin + col * (cell + gap)
        y0 = origin + row * (cell + gap)
        rounded_rect(draw, (x0, y0, x0 + cell, y0 + cell), radius, color)

    # La "J" solo si la celda es lo bastante grande para que se lea.
    if letter and cell >= 44 * SS:
        font = ImageFont.truetype(FONT_BOLD, int(cell * 0.72))
        text = "J"
        box = draw.textbbox((0, 0), text, font=font)
        tw, th = box[2] - box[0], box[3] - box[1]
        tx = origin + (cell + gap) + (cell - tw) / 2 - box[0]
        ty = origin + (cell + gap) + (cell - th) / 2 - box[1]
        draw.text((tx, ty), text, font=font, fill=INK)

    return canvas.resize((size, size), Image.LANCZOS)


def save(img, path):
    full = os.path.join(ROOT, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    img.save(full, "PNG")
    print(f"  {path}  {img.size[0]}x{img.size[1]}")


def build_web():
    print("Iconos web:")
    # Pestana del navegador: cuadricula sin letra, esquinas redondeadas.
    save(draw_grid(32, 0.86, 0.16, 0.09, letter=False, rounded_outer=True),
         "web/favicon.png")
    # Iconos PWA: a sangre, con la "J" en version grande.
    save(draw_grid(192, 0.80, 0.16, 0.09), "web/icons/Icon-192.png")
    save(draw_grid(512, 0.80, 0.16, 0.09), "web/icons/Icon-512.png")
    # Maskable: el contenido entra en la zona segura (circulo del 80%).
    save(draw_grid(192, 0.62, 0.16, 0.08), "web/icons/Icon-maskable-192.png")
    save(draw_grid(512, 0.62, 0.16, 0.08), "web/icons/Icon-maskable-512.png")


def build_android():
    print("Iconos Android:")
    densities = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    for folder, size in densities.items():
        path = f"android/app/src/main/res/{folder}/ic_launcher.png"
        save(draw_grid(size, 0.80, 0.16, 0.09), path)


def build_og_image():
    """Imagen de vista previa para los enlaces (1200x630)."""
    print("Imagen para compartir:")
    w, h = 1200, 630
    img = Image.new("RGBA", (w * SS, h * SS), BG)
    draw = ImageDraw.Draw(img)

    # Cuadro de marca a la izquierda.
    grid = 300 * SS
    gap = 26 * SS
    cell = (grid - gap) / 2
    ox, oy = 90 * SS, (h * SS - grid) / 2
    radius = int(cell * 0.16)
    for i, color in enumerate([GREEN, YELLOW, GRAY, GOLD]):
        row, col = divmod(i, 2)
        x0 = ox + col * (cell + gap)
        y0 = oy + row * (cell + gap)
        rounded_rect(draw, (x0, y0, x0 + cell, y0 + cell), radius, color)

    font = ImageFont.truetype(FONT_BOLD, int(cell * 0.72))
    box = draw.textbbox((0, 0), "J", font=font)
    tw, th = box[2] - box[0], box[3] - box[1]
    draw.text(
        (ox + (cell + gap) + (cell - tw) / 2 - box[0],
         oy + (cell + gap) + (cell - th) / 2 - box[1]),
        "J", font=font, fill=INK,
    )

    # Texto.
    title_font = ImageFont.truetype(FONT_BOLD, 96 * SS)
    sub_font = ImageFont.truetype(FONT_BOLD, 34 * SS)
    body_font = ImageFont.truetype(r"C:\Windows\Fonts\arial.ttf", 30 * SS)

    tx = ox + grid + 70 * SS
    draw.text((tx, 170 * SS), "JERGADLE", font=title_font, fill=(0xF2, 0xF2, 0xF2, 255))
    draw.text((tx, 285 * SS), "Wordle peruano", font=sub_font, fill=GOLD)
    draw.text(
        (tx, 345 * SS),
        "84 jergas limeñas de 5 letras. Adivina la del día.",
        font=body_font, fill=(0x9A, 0x9A, 0x9A, 255),
    )
    draw.text(
        (tx, 400 * SS),
        "6 intentos · Rachas · Android y Web",
        font=body_font, fill=(0x9A, 0x9A, 0x9A, 255),
    )

    # Franja inferior con los tres colores.
    bar = 14 * SS
    draw.rectangle((0, h * SS - bar, w * SS / 3, h * SS), fill=GREEN)
    draw.rectangle((w * SS / 3, h * SS - bar, w * SS * 2 / 3, h * SS), fill=YELLOW)
    draw.rectangle((w * SS * 2 / 3, h * SS - bar, w * SS, h * SS), fill=GRAY)

    img = img.resize((w, h), Image.LANCZOS)
    save(img, "web/og-image.png")
    save(img, "docs/og-image.png")


def build_logo():
    """Lockup horizontal para el README."""
    print("Logo:")
    w, h = 900, 220
    img = Image.new("RGBA", (w * SS, h * SS), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    grid = 180 * SS
    gap = 16 * SS
    cell = (grid - gap) / 2
    ox, oy = 10 * SS, (h * SS - grid) / 2
    radius = int(cell * 0.16)
    for i, color in enumerate([GREEN, YELLOW, GRAY, GOLD]):
        row, col = divmod(i, 2)
        x0 = ox + col * (cell + gap)
        y0 = oy + row * (cell + gap)
        rounded_rect(draw, (x0, y0, x0 + cell, y0 + cell), radius, color)

    font = ImageFont.truetype(FONT_BOLD, int(cell * 0.72))
    box = draw.textbbox((0, 0), "J", font=font)
    tw, th = box[2] - box[0], box[3] - box[1]
    draw.text(
        (ox + (cell + gap) + (cell - tw) / 2 - box[0],
         oy + (cell + gap) + (cell - th) / 2 - box[1]),
        "J", font=font, fill=INK,
    )

    title_font = ImageFont.truetype(FONT_BOLD, 78 * SS)
    sub_font = ImageFont.truetype(FONT_BOLD, 26 * SS)
    tx = ox + grid + 46 * SS
    draw.text((tx, 52 * SS), "JERGADLE", font=title_font, fill=(0x1A, 0x1A, 0x1A, 255))
    draw.text((tx, 142 * SS), "WORDLE PERUANO", font=sub_font, fill=(0xB3, 0x7A, 0x16, 255))

    img = img.resize((w, h), Image.LANCZOS)
    save(img, "docs/logo.png")


if __name__ == "__main__":
    build_web()
    build_android()
    build_og_image()
    build_logo()
    print("Listo.")
