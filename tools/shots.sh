#!/usr/bin/env bash
# Снимки для справочника по ключам — с тестовой ВМ, а не с рабочей машины.
#
# Почему так. Картинка в документации должна показывать ровно то, что
# делает ключ, и ничего больше: чужие окна, личные файлы и рабочие
# адреса в кадр попадать не должны. Чистая ВМ это гарантирует, а заодно
# делает снимки воспроизводимыми — состояние возвращается снапшотом.
#
# Экран снимается снаружи, через VBoxManage: внутри гостя для этого
# пришлось бы держать gnome-screenshot и ловить его собственное окно.
#
#   bash tools/shots.sh --prepare               усмирить стенд перед съёмкой
#   bash tools/shots.sh buttons-size "buttons --size 28 22"
#   bash tools/shots.sh --scene nautilus        открыть окно в кадре
#   bash tools/shots.sh --list                  что уже снято
#
# Требуется: ВМ ubuntu-kit запущена, ssh-хост kit отвечает.
set -uo pipefail

HERE=$(cd "$(dirname "$0")/.." && pwd)
OUT="$HERE/docs/screenshots/keys"
VM="ubuntu-kit"
VBOX="/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"
HOST="kit"
# Сессия по ssh иногда встаёт колом: ВМ под нагрузкой, а мы ждём вечно.
# Таймауты нужны, чтобы один затык не останавливал весь план съёмки.
SSH="ssh -o ConnectTimeout=10 -o ServerAliveInterval=5 -o ServerAliveCountMax=3"
KIT="~/ubuntu-desktop-kit/desktop-kit.sh"

# Окружение графической сессии: по ssh его нет, а без него gsettings
# пишет в пустоту и ничего не меняется на экране.
# XAUTHORITY нужен из-за XWayland: имя файла случайное и меняется при
# каждом входе, поэтому ищется, а не задаётся константой.
GUI='export DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus; export XAUTHORITY=$(ls /run/user/1000/.mutter-Xwaylandauth* 2>/dev/null | head -1);'

say() { printf '    %s\n' "$*"; }

vbox() { "$VBOX" "$@"; }

shot() {
    local name="$1"
    mkdir -p "$OUT"
    redraw
    vbox controlvm "$VM" screenshotpng "$(cygpath -w "$OUT/$name.png" 2>/dev/null || echo "$OUT/$name.png")" \
        >/dev/null 2>&1
    if [ -s "$OUT/$name.png" ]; then
        say "снято: docs/screenshots/keys/$name.png"
        return 0
    fi
    say "не снялось: $name"
    return 1
}

# Кадр VirtualBox отдаёт из видеопамяти гостя, а GNOME перерисовывает
# только изменившиеся области. Поэтому снимок легко застаёт устаревшую
# картинку: на ней часы идут, а всё остальное — из прошлого. Полтора
# часа ушло на «почему ключ не применился», пока не выяснилось, что
# применился, просто кадр был старый. xrefresh просит перерисовать всё.
redraw() {
    $SSH "$HOST" "$GUI xrefresh -root" >/dev/null 2>&1
    sleep 2
}

# Выйти из режима обзора: он перекрывает окна и портит кадр
esc() {
    $SSH "$HOST" "$GUI xdotool key Escape" >/dev/null 2>&1
    sleep 1
}

# Дождаться окна: приложения стартуют медленнее, чем возвращается ssh,
# а conky после правки конфига перезапускается и пропадает на пару секунд.
# Без ожидания в кадр попадает пустой рабочий стол.
# Ждём ПРОЦЕСС, а не окно. Окна проверять нечем: сессия гостя — Wayland
# с XWayland, и wmctrl видит только старые X-окна. Nautilus на GTK4
# рисуется нативно, в списке не появляется никогда, и проверка по окну
# каждый раз честно ждала своё и врала «окно не появилось».
wait_window() {
    local proc="$1"
    local i
    for i in $(seq 1 10); do
        if $SSH "$HOST" "pgrep -f '$proc' >/dev/null" 2>/dev/null; then
            sleep 3
            return 0
        fi
        sleep 2
    done
    say "процесс '$proc' так и не поднялся"
    return 1
}

# setsid обязателен: без него окно живёт ровно до конца ssh-сессии,
# которая его запустила, и снимок застаёт пустой стол.
scene() {
    case "$1" in
        nautilus)
            $SSH "$HOST" "$GUI pkill nautilus 2>/dev/null; sleep 2; \
                setsid nautilus --new-window >/dev/null 2>&1 </dev/null &" >/dev/null 2>&1
            wait_window nautilus
            ;;
        terminal)
            $SSH "$HOST" "$GUI pkill -f gnome-terminal-server 2>/dev/null; sleep 2; \
                setsid gnome-terminal >/dev/null 2>&1 </dev/null &" >/dev/null 2>&1
            wait_window terminal
            ;;
        clean)
            $SSH "$HOST" "$GUI pkill nautilus 2>/dev/null; \
                pkill -f gnome-terminal-server 2>/dev/null; sleep 2" >/dev/null 2>&1
            ;;
    esac
    esc
    sleep 1
}

# Подготовить стенд. Каждая строка здесь — след от потерянного часа.
#
# wmctrl и xdotool           после отката снапшота их может не быть, а
#                            без них не проверить окна и не нажать Esc
# xrefresh (x11-xserver-utils) единственный способ получить свежий кадр
# apport                     лезет диалогом «приложение закрылось» прямо
#                            в кадр, ровно поверх снимаемого окна
# unattended-upgrades,       поднимают load average до 25 на четырёх
# update-notifier            ядрах, после чего ssh отваливается по
#                            таймауту и съёмка встаёт
# conky update_interval      на программном рендеринге Cairo виджет
#                            съедает 98% процессора; раз в пять секунд
#                            он рисует то же самое, но машина жива
prepare() {
    say "готовлю стенд"
    $SSH "$HOST" "sudo apt-get install -y wmctrl xdotool x11-xserver-utils >/dev/null 2>&1; \
        sudo systemctl stop apport.service unattended-upgrades packagekit 2>/dev/null; \
        sudo systemctl mask unattended-upgrades 2>/dev/null; \
        sudo sed -i 's/^enabled=1/enabled=0/' /etc/default/apport 2>/dev/null; \
        pkill -f update-notifier 2>/dev/null; pkill -f apport-gtk 2>/dev/null; \
        sudo rm -f /var/crash/* 2>/dev/null; \
        sed -i 's/^[[:space:]]*update_interval[[:space:]]*=.*/    update_interval = 5,/' \
            ~/.config/conky/main.conf 2>/dev/null; true" >/dev/null 2>&1

    local have
    have=$($SSH "$HOST" "which wmctrl xdotool xrefresh 2>/dev/null | wc -l" 2>/dev/null)
    if [ "${have:-0}" -lt 3 ]; then
        say "не встали нужные программы — снимки будут ненадёжны"
        return 1
    fi
    say "стенд готов: помехи выключены, инструменты на месте"
    return 0
}

case "${1:-}" in
    --prepare)
        prepare
        exit $?
        ;;
    --list)
        ls -1 "$OUT" 2>/dev/null || say "снимков пока нет"
        exit 0
        ;;
    --scene)
        scene "${2:-nautilus}"
        exit 0
        ;;
    --shot)
        esc
        shot "${2:?нужно имя}"
        exit $?
        ;;
    "")
        sed -n '2,20p' "$0"
        exit 0
        ;;
esac

NAME="$1"
CMD="${2:?нужна команда для desktop-kit}"
SCENE="${3:-}"

say "применяю: $CMD"
$SSH "$HOST" "$GUI timeout 120 bash $KIT --yes $CMD" >/dev/null 2>&1
# Оболочке нужно время перерисоваться: тема и CSS подхватываются не мгновенно
sleep "${SHOT_WAIT:-5}"

# Окно открываем ПОСЛЕ применения: кнопки заголовка и углы подхватываются
# при запуске приложения, и снимать надо свежее окно, а не прежнее.
if [ -n "$SCENE" ]; then
    scene "$SCENE"
fi
if [ -n "${SHOT_WAIT_FOR:-}" ]; then
    wait_window "$SHOT_WAIT_FOR"
fi

esc
sleep 1
shot "$NAME"
