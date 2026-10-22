"""Compone las capturas de pantalla de Jergadle con marcos de dispositivo.

Uso:
    python scripts/make_screenshots.py

Convierte las capturas crudas (tomadas en el navegador) en imagenes listas
para publicar: las moviles con un marco de telefono y la de escritorio con
un marco de navegador, todas con sombra suave.
"""

import os
from PIL import Image, ImageDraw, ImageFilter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SHOTS = os.path.join(ROOT, "docs", "screenshots")

BG = (0x12, 0x12, 0x13, 255)
FRAME = (0x1C, 0x1C, 0x1E, 255)
FRAME_LIGHT = (0xE8, 0xE8, 0xE6, 255)
ACCENT = (0xE0, 0xA9, 0x3B, 255)

FONT_BOLD = r"C:\Windows\Fonts\arialbd.ttf"
FONT = r"C:\Windows\Fonts\arial.ttf"


def rounded_mask(size, radius):
    mask = Image.new("L", size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, size[0] - 1, size[1] - 1),
                                           radius=radius, fill=255)
    return mask


def drop_shadow(img, radius=28, offset=(0, 14), blur=18, opacity=110):
    """Devuelve un lienzo con la sombra de la imagen."""
    pad = blur * 3
    canvas = Image.new("RGBA", (img.width + pad * 2, img.height + pad * 2), (0, 0, 0, 0))
    alpha = img.split()[3] if img.mode == "RGBA" else Image.new("L", img.size, 255)
    shadow = Image.new("RGBA", img.size, (0, 0, 0, opacity))
    shadow.putalpha(alpha.filter(ImageFilter.GaussianBlur(blur)))
    canvas.alpha_composite(shadow, (pad + offset[0], pad + offset[1]))
    canvas.alpha_composite(img, (pad, pad))
    return canvas


def phone_mockup(screen, label):
    """Enmarca una captura movil en un telefono."""
    bezel = 12
    radius = 46
    sw, sh = screen.size
    device_w = sw + bezel * 2
    device_h = sh + bezel * 2

    device = Image.new("RGBA", (device_w, device_h), FRAME)
    d = ImageDraw.Draw(device)
    # Borde mas claro para que se lea el contorno sobre fondo oscuro.
    d.rounded_rectangle((0, 0, device_w - 1, device_h - 1), radius=radius + bezel,
                        outline=(0x3A, 0x3A, 0x3C, 255), width=2)
    # Mascarana superior (notch).
    d.rounded_rectangle(
        (device_w / 2 - 46, 6, device_w / 2 + 46, 30), radius=12,
        fill=(0x08, 0x08, 0x09, 255),
    )

    screen_rgba = screen.convert("RGBA")
    screen_rgba.putalpha(rounded_mask((sw, sh), radius))
    device.alpha_composite(screen_rgba, (bezel, bezel))

    shadowed = drop_shadow(device)
    return compose_label(shadowed, label)


def browser_mockup(screen, label):
    """Enmarca una captura de escritorio en una ventana de navegador."""
    bar = 46
    sw, sh = screen.size
    win = Image.new("RGBA", (sw, sh + bar), FRAME_LIGHT)
    d = ImageDraw.Draw(win)

    # Barra de titulo con los tres puntos y la URL.
    d.ellipse((22, 18, 34, 30), fill=(0xFF, 0x5F, 0x57, 255))
    d.ellipse((42, 18, 54, 30), fill=(0xFE, 0xBC, 0x2E, 255))
    d.ellipse((62, 18, 74, 30), fill=(0x28, 0xC8, 0x40, 255))
    d.rounded_rectangle((96, 12, sw - 24, 36), radius=12, fill=(0xF2, 0xF2, 0xF0, 255))
    d.text((114, 18), "jergadle.vercel.app", font=ImageFont_truetype(FONT, 15),
           fill=(0x6E, 0x6E, 0x6E))

    screen_rgba = screen.convert("RGBA")
    win.alpha_composite(screen_rgba, (0, bar))
    shadowed = drop_shadow(win, radius=12, offset=(0, 10), blur=16, opacity=100)
    return compose_label(shadowed, label)


def ImageFont_truetype(path, size):
    from PIL import ImageFont
    return ImageFont.truetype(path, size)


def compose_label(img, label):
    """Anade una barra de caption con el titulo de la captura."""
    from PIL import ImageFont
    cap_h = 64
    out = Image.new("RGBA", (img.width, img.height + cap_h), (0, 0, 0, 0))
    out.alpha_composite(img, (0, 0))
    d = ImageDraw.Draw(out)
    d.rectangle((0, img.height, out.width, img.height + cap_h - 1), fill=(0x1A, 0x1A, 0x1B, 255))
    d.line((0, img.height, out.width, img.height), fill=(0x30, 0x30, 0x32, 255), width=1)
    d.text((18, img.height + 20), label, font=ImageFont.truetype(FONT_BOLD, 22),
           fill=(0xF2, 0xF2, 0xF2, 255))
    d.ellipse((out.width - 34, img.height + 28, out.width - 20, img.height + 42),
              fill=ACCENT)
    return out


def save(img, name):
    os.makedirs(SHOTS, exist_ok=True)
    path = os.path.join(SHOTS, name)
    img.save(path, "PNG")
    print(f"  docs/screenshots/{name}  {img.width}x{img.height}")


def build():
    from PIL import ImageFont

    jobs = [
        ("s06_tablero.png", "1_tablero.png", "Adivinaste la jerga del día", "phone"),
        ("s01_home.png", "2_inicio.png", "Jergadle · la jerga peruana de 5 letras", "phone"),
        ("s02_juego.png", "3_juego.png", "Cada intento revela verde, amarillo o gris", "phone"),
        ("s03_victoria.png", "4_victoria.png", "Al ganar, te explica qué significa en el Perú", "phone"),
        ("s04_claro.png", "5_tema_claro.png", "Modo claro y oscuro", "phone"),
        ("s05_web.png", "6_web.png", "También en la web, en el navegador", "browser"),
    ]

    print("Capturas:")
    for src, dst, label, kind in jobs:
        path = os.path.join(ROOT, src)
        if not os.path.exists(path):
            print(f"  (falta {src})")
            continue
        screen = Image.open(path).convert("RGBA")
        if kind == "phone":
            out = phone_mockup(screen, label)
        else:
            out = browser_mockup(screen, label)
        save(out, dst)


def count_words():
    """Cuenta las jergas del diccionario para no escribir un numero fijo."""
    import re
    path = os.path.join(ROOT, "lib", "data", "peruvian_words.dart")
    try:
        with open(path, encoding="utf-8") as f:
            return len(re.findall(r"word: '[A-ZÑ]{5}'", f.read()))
    except OSError:
        return 0


def build_carousel():
    """Compone un carrusel 1200x1200 con las tres pantallas principales."""
    from PIL import ImageFont

    words = count_words()
    names = ["1_tablero.png", "4_victoria.png", "2_inicio.png"]
    paths = [os.path.join(SHOTS, n) for n in names]
    paths = [p for p in paths if os.path.exists(p)]
    if len(paths) < 2:
        return

    W = H = 1200
    canvas = Image.new("RGBA", (W, H), BG)
    d = ImageDraw.Draw(canvas)

    title_font = ImageFont.truetype(FONT_BOLD, 62)
    sub_font = ImageFont.truetype(FONT, 26)
    d.text((60, 48), "JERGADLE", font=title_font, fill=(0xE0, 0xA9, 0x3B, 255))
    d.text((60, 124),
           f"El Wordle peruano · {words} jergas limeñas de 5 letras",
           font=sub_font, fill=(0xF2, 0xF2, 0xF2, 255))

    n = len(paths)
    gap = 28
    top = 180
    foot = 130
    avail = W - 120 - gap * (n - 1)
    cell_w = avail // n
    cell_h_max = H - top - foot
    ratio = 1040 / 522  # proporcion de las capturas con marco
    cell_h = min(int(cell_w * ratio), cell_h_max)

    x = 60
    for p in paths:
        im = Image.open(p).convert("RGBA")
        scale = min(cell_w / im.width, cell_h / im.height)
        im = im.resize((int(im.width * scale), int(im.height * scale)), Image.LANCZOS)
        y = top + (cell_h_max - im.height) // 2
        canvas.alpha_composite(im, (x, y))
        x += cell_w + gap

    # Pie con la llamada a la accion.
    cta_font = ImageFont.truetype(FONT_BOLD, 34)
    foot_font = ImageFont.truetype(FONT, 24)
    # Triangulo de "play" dibujado (Arial no tiene el glifo).
    d.polygon([(62, H - foot + 24), (62, H - foot + 54), (86, H - foot + 39)],
              fill=ACCENT)
    d.text((100, H - foot + 24), "jergadle.vercel.app", font=cta_font, fill=ACCENT)
    d.text((60, H - foot + 72),
           f"{words} jergas limeñas · 6 intentos al día · Android y web · código abierto",
           font=foot_font, fill=(0x9A, 0x9A, 0x9A, 255))

    d.rectangle((0, H - 14, W // 3, H), fill=(0x53, 0x8D, 0x4E, 255))
    d.rectangle((W // 3, H - 14, W * 2 // 3, H), fill=(0xB5, 0x9F, 0x3B, 255))
    d.rectangle((W * 2 // 3, H - 14, W, H), fill=(0x3A, 0x3A, 0x3C, 255))

    save(canvas.convert("RGB"), "carrusel.png")


if __name__ == "__main__":
    build()
    build_carousel()
    print("Listo.")
