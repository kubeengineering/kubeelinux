#!/usr/bin/env bash
# Пересъёмка всех картинок для справочника по ключам.
#
# План съёмки держится здесь, а не в голове: снимки должны быть
# воспроизводимы. Сломался вид — откатил ВМ на снапшот, прогнал заново,
# получил те же кадры. Каждая строка: имя файла, команда, сцена.
#
#   bash tools/shots-all.sh           снять всё
#   bash tools/shots-all.sh widget    только группу
#
# Перед запуском: ВМ ubuntu-kit поднята, ssh-хост kit отвечает,
# desktop-kit на ней свежий.
set -uo pipefail

HERE=$(cd "$(dirname "$0")/.." && pwd)
SHOT="$HERE/tools/shots.sh"
ONLY="${1:-}"

# имя|команда|сцена|чего ждать
#
# Команды самодостаточны намеренно. Настройки накапливаются: кадр для
# --light, снятый после --opacity 120, показывал не светлую подложку,
# а её отсутствие. Каждая строка должна приводить вид к тому, что
# подписано под картинкой, а не к сумме всего, что снимали до неё.
PLAN='
widget-square|widget --dark --opacity 225 --square|clean|conky
widget-radius|widget --dark --opacity 225 --radius 18|clean|conky
widget-light|widget --light --opacity 225 --radius 12|clean|conky
widget-opacity|widget --dark --radius 12 --opacity 120|clean|conky
widget-colour|widget --colour 8ab4f8 --opacity 225 --radius 12|clean|conky
buttons-size|buttons --size 30 24|nautilus|nautilus
buttons-radius|buttons --radius 0|nautilus|nautilus
buttons-close|buttons --close e06c75|nautilus|nautilus
corners-square|corners --square|nautilus|nautilus
corners-radius|corners --radius 18|nautilus|nautilus
theme-light|theme --light|nautilus|nautilus
theme-dark|theme --dark|nautilus|nautilus
icons-folders|icons --folders blue|nautilus|nautilus
panel-float|panel --float|clean|
panel-size|panel --size 64|clean|
panel-transparent|panel --transparent|clean|
panel-full|panel --full|clean|
terminal-opacity|terminal --opacity 45|terminal|terminal
wall-random|wall --random|clean|
'

# Стенд сначала привести в чувство: без этого apport лезет диалогами
# прямо в кадр, а фоновые обновления Ubuntu кладут ssh по таймауту.
bash "$SHOT" --prepare </dev/null

printf '%s\n' "$PLAN" | while IFS='|' read -r name cmd sc wait_for; do
    [ -n "$name" ] || continue
    case "$name" in \#*) continue ;; esac
    if [ -n "$ONLY" ]; then
        case "$name" in
            "$ONLY"*) : ;;
            *) continue ;;
        esac
    fi
    printf '\n== %s\n' "$name"
    # </dev/null обязателен: без него снимающий скрипт съедает остаток
    # плана из stdin, и снимается ровно первый кадр из группы
    SHOT_WAIT_FOR="$wait_for" bash "$SHOT" "$name" "$cmd" "$sc" </dev/null
done
