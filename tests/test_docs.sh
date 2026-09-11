#!/usr/bin/env bash
# Справочник по ключам не должен расходиться с программой.
#
# Документация, которая врёт, хуже отсутствующей: ей верят и по ней
# действуют. Поэтому список ключей берётся из самого кода, а тест
# падает, если появился ключ без описания или описан несуществующий.
#
#   bash tests/test_docs.sh
set -uo pipefail

HERE=$(cd "$(dirname "$0")/.." && pwd)
DOC="$HERE/docs/keys.md"
LIST="$HERE/tools/list-keys.sh"

OK=0
FAIL=0

ok()   { printf '  \033[32mOK\033[0m   %s\n' "$*"; OK=$((OK + 1)); }
fail() { printf '  \033[31mFAIL\033[0m %s\n' "$*"; FAIL=$((FAIL + 1)); }

[ -f "$DOC" ] || { echo "нет $DOC"; exit 1; }

printf '\n== ключи описаны\n'

# --help, --dry-run, --yes и --quiet есть у каждой команды и вынесены
# в общую таблицу — по разу, а не двадцать три.
COMMON="--help --dry-run --yes --quiet"

missing=""
while IFS=$'\t' read -r cmd key; do
    [ -n "$key" ] || continue
    case " $COMMON " in
        *" $key "*) continue ;;
    esac
    if ! grep -qF -- "\`$key" "$DOC"; then
        missing="$missing $cmd$key"
    fi
done < <(bash "$LIST")

if [ -z "$missing" ]; then
    ok "каждый ключ из кода описан в docs/keys.md"
else
    fail "ключи без описания:$missing"
fi

printf '\n== команды на месте\n'

for c in $(bash "$LIST" | cut -f1 | sort -u); do
    if grep -q "^## $c\$" "$DOC"; then
        ok "раздел $c"
    else
        fail "нет раздела для команды $c"
    fi
done

printf '\n== картинки существуют\n'

# Ссылка на несуществующий файл — обычное дело в документации и самое
# заметное: вместо картинки пустая рамка. Проверяем все разом.
broken=""
while read -r img; do
    [ -n "$img" ] || continue
    if [ ! -s "$HERE/docs/$img" ]; then
        broken="$broken $img"
    fi
done < <(grep -o '!\[[^]]*\]([^)]*)' "$DOC" | sed 's/.*(\(.*\))/\1/')

if [ -z "$broken" ]; then
    ok "все картинки на месте"
else
    fail "нет файлов:$broken"
fi

printf '\n'
if [ "$FAIL" = "0" ]; then
    printf 'все проверки прошли (%d)\n' "$OK"
    exit 0
fi
printf 'провалено: %d из %d\n' "$FAIL" "$((OK + FAIL))"
exit 1
