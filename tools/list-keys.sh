#!/usr/bin/env bash
# Все ключи всех команд — прямо из кода разбора аргументов.
#
# Нужен, чтобы справочник не расходился с реальностью: список ключей
# пишется не по памяти, а читается из тех самых case, которые их
# разбирают. Тест полноты справочника опирается на этот же вывод.
#
#   bash tools/list-keys.sh            команда<TAB>ключ
#   bash tools/list-keys.sh --count    сколько ключей у каждой команды
set -uo pipefail

HERE=$(cd "$(dirname "$0")/.." && pwd)
KIT="$HERE/desktop-kit.sh"

[ -f "$KIT" ] || { echo "нет $KIT" >&2; exit 1; }

keys() {
    awk '
        # начало разбора аргументов конкретной команды
        /^cmd_[a-z]+\(\) \{/ {
            name = $1
            sub(/^cmd_/, "", name)
            sub(/\(\).*/, "", name)
            cur = name
            next
        }
        # конец функции — закрывающая скобка в первой колонке
        /^\}/ { cur = ""; next }

        cur == "" { next }

        # Строки вида «--flag)» и «-h|--help)» в case. Скобка обязана
        # стоять сразу за флагом: иначе сюда попадали ключи из вызовов
        # curl внутри той же функции — «--max-time 120 --remove-on-error».
        {
            line = $0
            sub(/^[ \t]+/, "", line)
            if (line !~ /^-{1,2}[a-zA-Z][a-zA-Z0-9-]*(\|-{1,2}[a-zA-Z][a-zA-Z0-9-]*)*\)/) next
            sub(/\).*/, "", line)
            n = split(line, alt, "|")
            for (i = 1; i <= n; i++) {
                k = alt[i]
                if (k !~ /^--[a-z]/) continue
                print cur "\t" k
            }
        }
    ' "$KIT" | sort -u
}

if [ "${1:-}" = "--count" ]; then
    keys | cut -f1 | uniq -c | sort -rn
else
    keys
fi
