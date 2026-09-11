#!/usr/bin/env bash
# Снимок страницы новой вкладки — единственный кадр, который снимается
# не с экрана виртуалки, а рендером на хосте.
#
# Почему так. Страница — обычный HTML, и снимать её со стенда значит
# сначала поднять там браузер. Firefox в Ubuntu приехал снапом: под
# XWayland он не видит файл авторизации X, а запущенный нативным
# Wayland-клиентом рисуется мимо XWayland — и xrefresh, которым мы
# чиним залипший кадр VirtualBox, его не касается. Кадр остаётся
# старым, и выглядит это как «страница не открылась».
#
# Рендер headless-браузером даёт ровно ту же страницу, снимается за
# секунды и не зависит от состояния стенда. Со стенда берётся только
# сама страница и картинка фона.
#
#   bash tools/shot-newtab.sh                        обычный вид
#   bash tools/shot-newtab.sh newtab-tile "--tile 170 --clock 150"
set -uo pipefail

HERE=$(cd "$(dirname "$0")/.." && pwd)
OUT="$HERE/docs/screenshots/keys"
WORK="${TMPDIR:-/tmp}/dk-newtab"
HOST="kit"
KIT="~/ubuntu-desktop-kit/desktop-kit.sh"
CHROME="/c/Program Files/Google/Chrome/Application/chrome.exe"
SSH="ssh -o ConnectTimeout=10 -o ServerAliveInterval=5"

NAME="${1:-newtab-page}"
ARGS="${2:-}"

say() { printf '    %s\n' "$*"; }

mkdir -p "$WORK" "$OUT"

# Ярлыки нейтральные: в кадре не должно быть ни одного рабочего адреса.
say "собираю страницу на стенде"
$SSH "$HOST" "mkdir -p ~/.local/share/newtab && \
    printf 'GitHub|https://github.com\nWikipedia|https://ru.wikipedia.org\nUbuntu|https://ubuntu.com\nGNOME|https://gnome.org\nArch Wiki|https://wiki.archlinux.org\nHabr|https://habr.com\n' \
        > ~/.local/share/newtab/links.txt && \
    timeout 150 bash $KIT --yes newtab $ARGS --rebuild" >/dev/null 2>&1

$SSH "$HOST" 'cat ~/.local/share/newtab/index.html' > "$WORK/index.html" 2>/dev/null
if [ ! -s "$WORK/index.html" ]; then
    say "страница не собралась — стенд не отвечает?"
    exit 1
fi

# Фон лежит на стенде отдельным файлом: тащим первый попавшийся и
# переписываем на него все ссылки, чтобы страница была самодостаточной.
WALL=$(grep -o 'file:///[^"'"'"')]*\.jpg' "$WORK/index.html" | head -1 | sed 's|^file://||')
if [ -n "$WALL" ]; then
    say "тяну фон: $(basename "$WALL")"
    $SSH "$HOST" "base64 -w0 '$WALL'" > "$WORK/wall.b64" 2>/dev/null
    python - "$WORK" <<'PY'
import base64, io, os, re, sys
work = sys.argv[1]
b64 = os.path.join(work, 'wall.b64')
if os.path.getsize(b64) > 0:
    open(os.path.join(work, 'wall.jpg'), 'wb').write(
        base64.b64decode(open(b64).read().strip()))
page = os.path.join(work, 'index.html')
html = io.open(page, encoding='utf-8').read()
html = re.sub(r'file:///[^"\')]*\.jpg', 'wall.jpg', html)
io.open(page, 'w', encoding='utf-8').write(html)
PY
fi

say "рендерю"
WIN_WORK=$(cygpath -w "$WORK" 2>/dev/null || printf '%s' "$WORK")
WIN_OUT=$(cygpath -w "$OUT/$NAME.png" 2>/dev/null || printf '%s' "$OUT/$NAME.png")
"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --screenshot="$WIN_OUT" --window-size=1280,800 --virtual-time-budget=4000 \
    "file:///$(printf '%s' "$WIN_WORK" | tr '\\' '/')/index.html" >/dev/null 2>&1

if [ -s "$OUT/$NAME.png" ]; then
    say "снято: docs/screenshots/keys/$NAME.png"
    exit 0
fi
say "не снялось"
exit 1
