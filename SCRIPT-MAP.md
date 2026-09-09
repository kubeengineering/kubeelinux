# Карта desktop-kit.sh

Всего 10483 строк, 421 КБ, примерно 143 тыс. токенов целиком.

**Не читай файл целиком.** Найди место здесь или через `grep -n`, потом
`Read` с `offset`/`limit` на 40–80 строк и `Edit` по найденному фрагменту.

Пересобрать карту после правок: `bash tools/make-map.sh > SCRIPT-MAP.md`

## Рецепты: что где править

| Задача | Куда смотреть |
|---|---|
| Размер, цвет, подсветка кнопок заголовка | `cmd_buttons` — строка 2312, разбор ключей в начале, CSS ниже |
| Значки заголовка: откуда берутся | `install_fluent_glyphs` — строка 2628, адрес в $FLUENT_ICONS |
| Почему значков не видно | `diagnose_buttons` — строка 2181 |
| Скругление окон и меню | `cmd_corners` — строка 3163 |
| Тема окон, схема, переключение светлая/тёмная | `cmd_theme` — строка 4010 |
| Разбор имени темы на варианты | `theme_variant_of` — строка 3703, рядом theme_base_of, theme_swap_variant |
| Поиск парного варианта темы | `theme_find_variant` — строка 3785 |
| Добавить тему в банк | `theme_repo_for` — строка 3292, плюс themes_bank ниже |
| Список и установка тем банка | `cmd_themes` — строка 3403 |
| Проверка темы на совместимость с кнопками | `themes_check` — строка 3530 |
| Тема значков и цвет папок | `cmd_icons` — строка 4510 |
| Шрифты интерфейса | `cmd_font` — строка 4650 |
| Виджет conky: подложка, цвет, плотность | `cmd_widget` — строка 4952 |
| Прозрачность и палитра терминала | `cmd_terminal` — строка 5219 |
| Страница новой вкладки Chrome | `cmd_newtab` — строка 5421, разметка в heredoc ниже по функции |
| Плитки без python3 | `newtab_tiles_plain` — строка 5355 |
| Смена обоев по порядку | `cmd_wall` — строка 6160 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 5831 |
| Чистка банка обоев | `prune_wallpapers` — строка 6091 |
| Горячие клавиши | `cmd_keys` — строка 7451 |
| Панель Dash to Panel | `cmd_panel` — строка 7535 |
| Своя тема для приложения | `cmd_app` — строка 6452 |
| Локальная апка по http | `cmd_serve` — строка 6610 |
| Откат: общая логика | `cmd_revert` — строка 7034 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 7018 |
| Что показывает status | `cmd_status` — строка 6723 |
| Полный перечень изменяемого | `help_settings` — строка 10282 |
| Общий текст справки | `usage` — строка 10221 |
| Диспетчер команд (добавить новую) | ищи `случай) cmd_` в самом конце файла: `grep -n 'cmd_status "$@"' desktop-kit.sh` |
| Правила предшественника look.sh | `strip_legacy_css` — строка 1931 |
| Резервные копии и откат файлов | `backup_once` 1728, `restore_backup` 1758 |
| Блоки правил в gtk.css | `css_append` 1995, `css_strip` 1897 |
| Запомнить значение для отката | `remember` 1863 / `recall` 1879 |
| Наши текущие настройки | `state_set` 1833 / `state_get` 1848 |

## Правишь -> гоняй (вместо полного прогона)

Полный selftest --full нужен только перед выкладкой. После точечной
правки достаточно её группы плюс зависимых:

```
bash tools/check.sh "ГРУППА [ГРУППА]"
```

| Правишь | Гоняй группы | Почему ещё и вторые |
|---|---|---|
| cmd_buttons, install_fluent_glyphs, CSS кнопок | buttons refresh presets | refresh переприменяет кнопки, presets их разворачивает |
| cmd_corners, CSS углов | corners presets overview | overview показывает наборы углов |
| theme_* (разбор имён, варианты) | theme | — |
| cmd_theme | theme revert | revert theme читает те же ключи |
| theme_repo_for, themes_bank, cmd_themes | themes | — |
| cmd_icons | icons buttons | buttons строит наследника поверх темы значков |
| cmd_font, apply_font | font | — |
| cmd_widget, widget_modules | widget tune | tune widget зовёт cmd_widget |
| cmd_terminal, apply_wal_palette | terminal revert | откат терминала читает те же ключи |
| cmd_newtab, генерация страницы | newtab wall | wall пересобирает страницу |
| cmd_wall | wall | — |
| cmd_wallpapers, prune | wallpapers | — |
| cmd_keys / cmd_panel / cmd_app / cmd_serve | keys / panel / app / serve | — |
| cmd_revert, restore_backup, revert_* | revert refresh | refresh тоже читает состояние |
| remember/recall, state_*, backup_once, css_* | core revert | это фундамент отката |
| preset_* | presets overview | обзор печатает наборы |
| ask_*, tune_* | tune | — |
| cmd_refresh | refresh | — |
| отчёт selftest, упаковка архива | report | — |
| usage, help_* | help | — |

Правило: правка в ДВУХ местах из таблицы — гоняй обе строки.
Перед git push: полный прогон плюс tests/test_kit.sh и tests/test_variants.sh.

## Команды

| Команда | Реализация | Справка | Тесты |
|---|---|---|---|
| `buttons` | 2312 | 2129 | 8785 |
| `corners` | 3163 | 2720 | 8930 |
| `theme` | 4010 | 3238 | 8957 |
| `themes` | 3403 | 3334 | 9662 |
| `icons` | 4510 | 4448 | 9131 |
| `font` | 4650 | 4637 | 9204 |
| `widget` | 4952 | 4720 | 9236 |
| `terminal` | 5219 | 5192 | 9307 |
| `newtab` | 5421 | 5377 | 9336 |
| `wallpapers` | 5831 | 5790 | 9420 |
| `wall` | 6160 | 6135 | 9386 |
| `serve` | 6610 | 6590 | 9584 |
| `app` | 6452 | 6264 | 9552 |
| `keys` | 7451 | 7263 | 9462 |
| `panel` | 7535 | 7489 | 9506 |
| `audit` | 7645 | — | — |
| `status` | 6723 | — | — |
| `selftest` | 8243 | 7661 | — |
| `revert` | 7034 | 6818 | 9605 |

## Секции файла

    3  desktop-kit — единый инструмент настройки десктопа Ubuntu 24.04 / GNOME 46
    5  Одна команда на каждую подсистему, единый откат, единый лог,
    6  самопроверка прямо на рабочей машине.
    15  ЧТО ЗДЕСЬ УЧТЕНО (каждый пункт стоил отдельного круга отладки)
    144  Обзор команды: что сейчас, что можно
    266  tabby — стеклянный терминал
    501  look — готовые образы рабочего стола
    686  profile — снимок оформления целиком
    1053  Банк тем значков
    1390  Тема для GTK4-приложений
    1473  Пресеты: именованные наборы параметров
    1559  Вопросы пользователю
    2126  buttons — кнопки заголовка окна
    2717  corners — скругление окон
    2740  tune — настройка вопросами
    3235  theme — тема GTK
    3324  themes — банк готовых тем
    4445  icons — тема значков и цвет папок
    4634  font — шрифт интерфейса
    4717  widget — виджет conky
    5189  terminal — GNOME Terminal
    5350  newtab — страница новой вкладки Chrome
    5742  wallpapers / wall — банк обоев и смена
    6261  app — тема отдельного приложения
    6587  serve — локальная апка по http
    6720  status — что применено
    6815  revert — откат
    7260  keys — горячие клавиши
    7486  panel — Dash to Panel
    7642  audit — снимок системы
    7658  selftest — проверка на живой машине
    7701  Каркас самопроверки: песочница с подставными внешними программами
    10218  help и диспетчер

## Пути и константы

    38  VERSION="1.0"
    39  SELF=$(readlink -f "$0")
    60  STATE_DIR="$HOME/.local/state/desktop-kit"
    61  BACKUP_DIR="$STATE_DIR/backups"
    62  LOG_FILE="$STATE_DIR/desktop-kit.log"
    63  BEFORE="$STATE_DIR/before.env"
    67  CONKY_DIR="$HOME/.config/conky"
    68  CONKY_CONF="$CONKY_DIR/main.conf"
    69  CONKY_LUA="$CONKY_DIR/desktop-kit-bg.lua"
    70  NEWTAB_DIR="$HOME/.local/share/newtab"
    71  NEWTAB_LINKS="$NEWTAB_DIR/links.txt"
    72  BIN_DIR="$HOME/bin"
    76  APP_MARK="# создано desktop-kit"
    79  SYS_THEMES="${DK_SYS_THEMES:-/usr/share/themes}"
    80  SYS_ICONS="${DK_SYS_ICONS:-/usr/share/icons}"
    81  SYS_APPS="${DK_SYS_APPS:-/usr/share/applications}"
    83  FLUENT_ICONS="https://raw.githubusercontent.com/vinceliuice/Fluent-icon-theme/master/src/symbolic/actions"
    84  WALLHAVEN="https://wallhaven.cc/api/v1/search"
    88  DRY_RUN=0
    89  ASSUME_YES=0
    90  QUIET=0
    282  TABBY_CONF="$HOME/.config/tabby/config.yaml"
    283  TABBY_MARK_BEGIN="/* dk:tabby-begin */"
    284  TABBY_MARK_END="/* dk:tabby-end */"
    699  PROFILE_DIR="$STATE_DIR/profiles"
    1555  PRESET_ARGS=""
    1556  PRESET_USED=""
    1567  ASK_ANSWER=""
    1831  KIT_STATE="$STATE_DIR/state.env"
    1916  LEGACY_CSS_MARK="look-begin"

## Где генерируется CSS

    2425  css_append buttons "$CSS3" "$(cat <<EOF
    2441  css_append buttons "$CSS4" "$(cat <<EOF
    2463  css_append buttons "$CSS3" "$(cat <<EOF
    2531  css_append buttons "$CSS4" "$(cat <<EOF
    3196  css_append corners "$CSS3" "$(cat <<EOF
    3214  css_append corners "$CSS4" "$(cat <<EOF

Селекторы, которые чаще всего правятся:
    2427  headerbar button.titlebutton,
    2429  button.titlebutton {
    2434  headerbar button.titlebutton image,
    2436  button.titlebutton image {
    2443  windowcontrols > button,
    2449  windowcontrols > button > image {
    2466  headerbar button.titlebutton,
    2468  button.titlebutton {
    2476  headerbar button.titlebutton image,
    2478  button.titlebutton image {
    2487  headerbar button.titlebutton:hover,
    2489  button.titlebutton:hover {
    2495  headerbar button.titlebutton:hover image,
    2496  button.titlebutton:hover image {

## Ключи состояния

Для отката (пишутся один раз, файл before.env):
    remember COLOR_SCHEME
    remember DTP_ANCHORS
    remember DTP_CUSTOM
    remember DTP_LENGTHS
    remember DTP_OPACITY
    remember DTP_SIZES
    remember FOLDER_COLOUR
    remember GTK_THEME
    remember ICON_THEME
    remember SHELL_THEME
    remember TERM_BG
    remember TERM_FG
    remember TERM_FONT
    remember TERM_OPACITY
    remember TERM_PALETTE
    remember TERM_SYSFONT
    remember TERM_THEMECOLORS
    remember TERM_TRANSPARENT

Наши текущие настройки (перезаписываются, файл state.env):
    state_set BTN_ARGS
    state_set BTN_CLOSE
    state_set BTN_H
    state_set BTN_ICON
    state_set BTN_PREV_ICON
    state_set BTN_RADIUS
    state_set BTN_W
    state_set CONKY_ALPHA
    state_set CONKY_INK
    state_set CONKY_RADIUS
    state_set CORNERS_ARGS
    state_set CORNERS_RADIUS
    state_set KEYS_OURS
    state_set NEWTAB_CLOCK
    state_set NEWTAB_TILE
    state_set WEATHER_CITY

## Самопроверка

    группы:      core buttons corners theme icons font widget terminal newtab wall wallpapers keys panel app serve revert themes look profile tabby refresh tune report presets overview help
    каркас:      sandbox_new 7727, sandbox_run 7977
    утверждения: t_eq 8052, t_has 8079, t_out_has 8129, t_rc 8143
    заглушки:    13 штук, ищи sb_write_stub

Запуск одной группы: `bash desktop-kit.sh selftest --only theme`

## Все функции

      92   ok
      93   bad
      94   note
      96   blank
      99   dump
      107  hint
      108  head1
      110  log
      115  die
      121  confirm
      157  overview_head
      162  overview_presets
      169  overview_tail
      176  overview_buttons
      202  overview_corners
      219  overview_widget
      245  overview_terminal
      292  tabby_strip_block
      304  help_tabby
      335  tabby_css_block
      368  tabby_hex_to_rgb
      375  tabby_show
      400  cmd_tabby
      519  look_table
      527  look_names
      531  help_look
      556  look_list
      569  look_show
      591  look_apply
      660  cmd_look
      704  profile_keys
      730  profile_files
      739  help_profile
      770  profile_autoname
      774  profile_list_names
      786  profile_save
      854  profile_load
      951  profile_show
      979  profile_drop
      1000 profile_list
      1023 cmd_profile
      1065 icons_bank
      1090 icons_repo_for
      1094 icons_bank_list
      1130 icons_clean
      1155 git_clone_retry
      1227 disk_room_warn
      1258 icons_copy_theme
      1273 icons_get
      1407 theme_gtk4_css
      1421 gtk4_theme_unlink
      1436 gtk4_theme_apply
      1482 presets_table
      1512 preset_args
      1520 presets_names
      1525 presets_list
      1534 preset_expand
      1570 ask_possible
      1582 ask_head
      1591 ask_num
      1628 ask_pick
      1674 ask_str
      1692 ask_yes
      1704 would
      1714 gi_get
      1715 gi_set
      1722 have
      1728 backup_once
      1758 restore_backup
      1833 state_set
      1848 state_get
      1863 remember
      1879 recall
      1897 css_strip
      1919 has_legacy_css
      1931 strip_legacy_css
      1983 icon_base_of
      1995 css_append
      2014 css_has
      2020 untangle_css
      2044 untangle_gtk4
      2048 untangle_gtk3
      2054 restart_gtk_apps
      2069 restart_conky
      2092 need_args
      2101 is_number
      2105 is_decimal
      2109 is_hex_colour
      2113 require_tools
      2129 help_buttons
      2181 diagnose_buttons
      2296 buttons_args
      2312 cmd_buttons
      2615 darken_hex
      2628 install_fluent_glyphs
      2720 help_corners
      2743 help_tune
      2763 tune_recap
      2769 cmd_tune
      2818 tune_corners
      2846 tune_buttons
      2906 tune_widget
      2972 tune_newtab
      3036 tune_terminal
      3065 tune_theme
      3078 tune_font
      3087 help_refresh
      3104 cmd_refresh
      3163 cmd_corners
      3238 help_theme
      3292 theme_repo_for
      3334 help_themes
      3377 themes_bank
      3403 cmd_themes
      3439 themes_list
      3459 themes_install
      3530 themes_check
      3590 list_themes
      3616 theme_exists
      3627 lower
      3629 theme_real_name
      3641 theme_exists_ci
      3660 theme_tokens
      3671 theme_token
      3675 theme_variant_pos
      3703 theme_variant_of
      3725 theme_rebuild
      3759 theme_base_of
      3773 theme_swap_variant
      3785 theme_find_variant
      3858 theme_light_by_sibling
      3877 theme_has_dark_sibling
      3889 theme_list_variants
      3917 theme_switch_variant
      4010 cmd_theme
      4246 install_theme_check_symlink
      4268 theme_build
      4334 theme_copy_dir
      4347 install_theme
      4448 help_icons
      4486 list_user_icon_themes
      4498 list_icon_themes
      4510 cmd_icons
      4637 help_font
      4650 cmd_font
      4720 help_widget
      4757 weather_line_path
      4761 weather_line_install
      4799 widget_modules_table
      4812 widget_add_module
      4869 widget_init
      4952 cmd_widget
      5164 conf_value
      5176 hex_brightness
      5192 help_terminal
      5210 term_profile
      5219 cmd_terminal
      5324 apply_wal_palette
      5355 newtab_tiles_plain
      5377 help_newtab
      5399 overview_newtab
      5421 cmd_newtab
      5517 rebuild_newtab
      5728 tick
      5745 find_wallpaper_dir
      5760 current_wallpaper
      5778 detect_resolution
      5790 help_wallpapers
      5813 week_themes
      5822 wallpaper_urls
      5831 cmd_wallpapers
      6023 install_wallpaper_timer
      6091 prune_wallpapers
      6135 help_wall
      6160 cmd_wall
      6264 help_app
      6317 opacity_to_hex
      6323 opacity_windows_of
      6329 opacity_apply_now
      6346 opacity_install_watch
      6390 opacity_remove_watch
      6397 app_opacity
      6452 cmd_app
      6590 help_serve
      6610 cmd_serve
      6723 cmd_status
      6818 help_revert
      6854 revert_terminal
      6892 revert_panel
      6927 revert_app
      6961 revert_keys
      6997 revert_serve
      7018 revert_gi_keys
      7034 cmd_revert
      7263 help_keys
      7289 keys_list_paths
      7294 keys_show
      7318 keys_add
      7404 keys_remove
      7451 cmd_keys
      7489 help_panel
      7518 panel_json_set
      7535 cmd_panel
      7645 cmd_audit
      7661 help_selftest
      7720 sb_write_stub
      7727 sandbox_new
      7950 sb_set
      7961 sb_get
      7969 sb_dconf
      7977 sandbox_run
      8003 sandbox_verify
      8027 sandbox_run_no
      8035 sandbox_drop
      8052 t_eq
      8066 t_ne
      8079 t_has
      8099 t_hasnt
      8117 t_hasnt_out
      8129 t_out_has
      8143 t_rc
      8157 t_rc_not
      8183 t_file
      8195 t_nofile
      8214 t_group
      8223 t_ok
      8225 t_fail
      8230 t_skip
      8235 t_detail
      8243 cmd_selftest
      8629 selftest_full
      8672 st_core
      8785 st_buttons
      8930 st_corners
      8957 st_theme
      9131 st_icons
      9204 st_font
      9236 st_widget
      9307 st_terminal
      9336 st_newtab
      9386 st_wall
      9420 st_wallpapers
      9462 st_keys
      9506 st_panel
      9552 st_app
      9584 st_serve
      9605 st_revert
      9662 st_themes
      9704 st_look
      9780 st_tabby
      9830 st_profile
      9905 st_refresh
      9953 st_tune
      10034 st_report
      10088 st_overview
      10125 st_presets
      10162 st_help
      10221 usage
      10282 help_settings
      10355 cmd_help
