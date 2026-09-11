# -*- coding: utf-8 -*-
"""Ужать снимки для справочника: репозиторий не хранилище обоев.

Кадр с виртуалки — 1280x800 и до 700 КБ. Девятнадцать таких весят
больше десяти мегабайт, и каждая пересъёмка добавляет столько же в
историю git, откуда их уже не выкинуть. Для документации хватает 960
пикселей по ширине: на ней видно и кнопки заголовка, и панель.

    python tools/shrink-shots.py            ужать всё в docs/screenshots/keys
    python tools/shrink-shots.py --width 720
"""
import argparse
import io
import os
import sys

from PIL import Image

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SHOTS = os.path.join(HERE, 'docs', 'screenshots', 'keys')


def human(n):
    return '%.0f КБ' % (n / 1024.0)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--width', type=int, default=960)
    ap.add_argument('--dir', default=SHOTS)
    args = ap.parse_args()

    if not os.path.isdir(args.dir):
        print('нет каталога: %s' % args.dir)
        return 1

    before = after = 0
    for name in sorted(os.listdir(args.dir)):
        if not name.endswith('.png'):
            continue
        path = os.path.join(args.dir, name)
        size_before = os.path.getsize(path)
        before += size_before

        img = Image.open(path)
        if img.width > args.width:
            height = int(img.height * args.width / float(img.width))
            img = img.resize((args.width, height), Image.LANCZOS)

        # Палитра из 256 цветов: скриншот интерфейса — это плашки и текст,
        # а не фотография. Обои внутри кадра слегка теряют в плавности
        # градиента, зато файл худеет втрое.
        img = img.convert('RGB').quantize(colors=256, method=Image.MEDIANCUT)
        img.save(path, optimize=True)

        size_after = os.path.getsize(path)
        after += size_after
        print('  %-28s %8s -> %8s' % (name, human(size_before), human(size_after)))

    if before:
        print('\nбыло %s, стало %s (%.0f%%)' %
              (human(before), human(after), 100.0 * after / before))
    return 0


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    sys.exit(main())
