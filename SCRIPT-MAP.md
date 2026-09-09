# Карта desktop-kit.sh

Всего 10619 строк, 428 КБ, примерно 146 тыс. токенов целиком.

**Не читай файл целиком.** Найди место здесь или через `grep -n`, потом
`Read` с `offset`/`limit` на 40–80 строк и `Edit` по найденному фрагменту.

Пересобрать карту после правок: `bash tools/make-map.sh > SCRIPT-MAP.md`

## Рецепты: что где править

| Задача | Куда смотреть |
|---|---|
| Размер, цвет, подсветка кнопок заголовка | `cmd_buttons` — строка 2316, разбор ключей в начале, CSS ниже |
| Значки заголовка: откуда берутся | `install_fluent_glyphs` — строка 2632, адрес в $FLUENT_ICONS |
| Почему значков не видно | `diagnose_buttons` — строка 2185 |
| Скругление окон и меню | `cmd_corners` — строка 3167 |
| Тема окон, схема, переключение светлая/тёмная | `cmd_theme` — строка 4014 |
| Разбор имени темы на варианты | `theme_variant_of` — строка 3707, рядом theme_base_of, theme_swap_variant |
| Поиск парного варианта темы | `theme_find_variant` — строка 3789 |
| Добавить тему в банк | `theme_repo_for` — строка 3296, плюс themes_bank ниже |
| Список и установка тем банка | `cmd_themes` — строка 3407 |
| Проверка темы на совместимость с кнопками | `themes_check` — строка 3534 |
| Тема значков и цвет папок | `cmd_icons` — строка 4514 |
| Шрифты интерфейса | `cmd_font` — строка 4654 |
| Виджет conky: подложка, цвет, плотность | `cmd_widget` — строка 4956 |
| Прозрачность и палитра терминала | `cmd_terminal` — строка 5223 |
| Страница новой вкладки Chrome | `cmd_newtab` — строка 5425, разметка в heredoc ниже по функции |
| Плитки без python3 | `newtab_tiles_plain` — строка 5359 |
| Смена обоев по порядку | `cmd_wall` — строка 6164 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 5835 |
| Чистка банка обоев | `prune_wallpapers` — строка 6095 |
| Горячие клавиши | `cmd_keys` — строка 7587 |
| Панель Dash to Panel | `cmd_panel` — строка 7671 |
| Своя тема для приложения | `cmd_app` — строка 6583 |
| Локальная апка по http | `cmd_serve` — строка 6746 |
| Откат: общая логика | `cmd_revert` — строка 7170 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 7154 |
| Что показывает status | `cmd_status` — строка 6859 |
| Полный перечень изменяемого | `help_settings` — строка 10418 |
| Общий текст справки | `usage` — строка 10357 |
| Диспетчер команд (добавить новую) | ищи `случай) cmd_` в самом конце файла: `grep -n 'cmd_status "$@"' desktop-kit.sh` |
| Правила предшественника look.sh | `strip_legacy_css` — строка 1935 |
| Резервные копии и откат файлов | `backup_once` 1732, `restore_backup` 1762 |
| Блоки правил в gtk.css | `css_append` 1999, `css_strip` 1901 |
| Запомнить значение для отката | `remember` 1867 / `recall` 1883 |
| Наши текущие настройки | `state_set` 1837 / `state_get` 1852 |

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
| `buttons` | 2316 | 2133 | 8921 |
| `corners` | 3167 | 2724 | 9066 |
| `theme` | 4014 | 3242 | 9093 |
| `themes` | 3407 | 3338 | 9798 |
| `icons` | 4514 | 4452 | 9267 |
| `font` | 4654 | 4641 | 9340 |
| `widget` | 4956 | 4724 | 9372 |
| `terminal` | 5223 | 5196 | 9443 |
| `newtab` | 5425 | 5381 | 9472 |
| `wallpapers` | 5835 | 5794 | 9556 |
| `wall` | 6164 | 6139 | 9522 |
| `serve` | 6746 | 6726 | 9720 |
| `app` | 6583 | 6268 | 9688 |
| `keys` | 7587 | 7399 | 9598 |
| `panel` | 7671 | 7625 | 9642 |
| `audit` | 7781 | — | — |
| `status` | 6859 | — | — |
| `selftest` | 8379 | 7797 | — |
| `revert` | 7170 | 6954 | 9741 |

## Секции файла

    3  desktop-kit — единый инструмент настройки десктопа Ubuntu 24.04 / GNOME 46
    5  Одна команда на каждую подсистему, единый откат, единый лог,
    6  самопроверка прямо на рабочей машине.
    15  ЧТО ЗДЕСЬ УЧТЕНО (каждый пункт стоил отдельного круга отладки)
    148  Обзор команды: что сейчас, что можно
    270  tabby — стеклянный терминал
    505  look — готовые образы рабочего стола
    690  profile — снимок оформления целиком
    1057  Банк тем значков
    1394  Тема для GTK4-приложений
    1477  Пресеты: именованные наборы параметров
    1563  Вопросы пользователю
    2130  buttons — кнопки заголовка окна
    2721  corners — скругление окон
    2744  tune — настройка вопросами
    3239  theme — тема GTK
    3328  themes — банк готовых тем
    4449  icons — тема значков и цвет папок
    4638  font — шрифт интерфейса
    4721  widget — виджет conky
    5193  terminal — GNOME Terminal
    5354  newtab — страница новой вкладки Chrome
    5746  wallpapers / wall — банк обоев и смена
    6265  app — тема отдельного приложения
    6723  serve — локальная апка по http
    6856  status — что применено
    6951  revert — откат
    7396  keys — горячие клавиши
    7622  panel — Dash to Panel
    7778  audit — снимок системы
    7794  selftest — проверка на живой машине
    7837  Каркас самопроверки: песочница с подставными внешними программами
    10354  help и диспетчер

## Пути и константы

    38  VERSION="1.3"
    42  VERSION_DATE="09.09.2026"
    43  SELF=$(readlink -f "$0")
    64  STATE_DIR="$HOME/.local/state/desktop-kit"
    65  BACKUP_DIR="$STATE_DIR/backups"
    66  LOG_FILE="$STATE_DIR/desktop-kit.log"
    67  BEFORE="$STATE_DIR/before.env"
    71  CONKY_DIR="$HOME/.config/conky"
    72  CONKY_CONF="$CONKY_DIR/main.conf"
    73  CONKY_LUA="$CONKY_DIR/desktop-kit-bg.lua"
    74  NEWTAB_DIR="$HOME/.local/share/newtab"
    75  NEWTAB_LINKS="$NEWTAB_DIR/links.txt"
    76  BIN_DIR="$HOME/bin"
    80  APP_MARK="# создано desktop-kit"
    83  SYS_THEMES="${DK_SYS_THEMES:-/usr/share/themes}"
    84  SYS_ICONS="${DK_SYS_ICONS:-/usr/share/icons}"
    85  SYS_APPS="${DK_SYS_APPS:-/usr/share/applications}"
    87  FLUENT_ICONS="https://raw.githubusercontent.com/vinceliuice/Fluent-icon-theme/master/src/symbolic/actions"
    88  WALLHAVEN="https://wallhaven.cc/api/v1/search"
    92  DRY_RUN=0
    93  ASSUME_YES=0
    94  QUIET=0
    286  TABBY_CONF="$HOME/.config/tabby/config.yaml"
    287  TABBY_MARK_BEGIN="/* dk:tabby-begin */"
    288  TABBY_MARK_END="/* dk:tabby-end */"
    703  PROFILE_DIR="$STATE_DIR/profiles"
    1559  PRESET_ARGS=""
    1560  PRESET_USED=""
    1571  ASK_ANSWER=""
    1835  KIT_STATE="$STATE_DIR/state.env"

## Где генерируется CSS

    2429  css_append buttons "$CSS3" "$(cat <<EOF
    2445  css_append buttons "$CSS4" "$(cat <<EOF
    2467  css_append buttons "$CSS3" "$(cat <<EOF
    2535  css_append buttons "$CSS4" "$(cat <<EOF
    3200  css_append corners "$CSS3" "$(cat <<EOF
    3218  css_append corners "$CSS4" "$(cat <<EOF

Селекторы, которые чаще всего правятся:
    2431  headerbar button.titlebutton,
    2433  button.titlebutton {
    2438  headerbar button.titlebutton image,
    2440  button.titlebutton image {
    2447  windowcontrols > button,
    2453  windowcontrols > button > image {
    2470  headerbar button.titlebutton,
    2472  button.titlebutton {
    2480  headerbar button.titlebutton image,
    2482  button.titlebutton image {
    2491  headerbar button.titlebutton:hover,
    2493  button.titlebutton:hover {
    2499  headerbar button.titlebutton:hover image,
    2500  button.titlebutton:hover image {

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
    каркас:      sandbox_new 7863, sandbox_run 8113
    утверждения: t_eq 8188, t_has 8215, t_out_has 8265, t_rc 8279
    заглушки:    13 штук, ищи sb_write_stub

Запуск одной группы: `bash desktop-kit.sh selftest --only theme`

## Все функции

      96   ok
      97   bad
      98   note
      100  blank
      103  dump
      111  hint
      112  head1
      114  log
      119  die
      125  confirm
      161  overview_head
      166  overview_presets
      173  overview_tail
      180  overview_buttons
      206  overview_corners
      223  overview_widget
      249  overview_terminal
      296  tabby_strip_block
      308  help_tabby
      339  tabby_css_block
      372  tabby_hex_to_rgb
      379  tabby_show
      404  cmd_tabby
      523  look_table
      531  look_names
      535  help_look
      560  look_list
      573  look_show
      595  look_apply
      664  cmd_look
      708  profile_keys
      734  profile_files
      743  help_profile
      774  profile_autoname
      778  profile_list_names
      790  profile_save
      858  profile_load
      955  profile_show
      983  profile_drop
      1004 profile_list
      1027 cmd_profile
      1069 icons_bank
      1094 icons_repo_for
      1098 icons_bank_list
      1134 icons_clean
      1159 git_clone_retry
      1231 disk_room_warn
      1262 icons_copy_theme
      1277 icons_get
      1411 theme_gtk4_css
      1425 gtk4_theme_unlink
      1440 gtk4_theme_apply
      1486 presets_table
      1516 preset_args
      1524 presets_names
      1529 presets_list
      1538 preset_expand
      1574 ask_possible
      1586 ask_head
      1595 ask_num
      1632 ask_pick
      1678 ask_str
      1696 ask_yes
      1708 would
      1718 gi_get
      1719 gi_set
      1726 have
      1732 backup_once
      1762 restore_backup
      1837 state_set
      1852 state_get
      1867 remember
      1883 recall
      1901 css_strip
      1923 has_legacy_css
      1935 strip_legacy_css
      1987 icon_base_of
      1999 css_append
      2018 css_has
      2024 untangle_css
      2048 untangle_gtk4
      2052 untangle_gtk3
      2058 restart_gtk_apps
      2073 restart_conky
      2096 need_args
      2105 is_number
      2109 is_decimal
      2113 is_hex_colour
      2117 require_tools
      2133 help_buttons
      2185 diagnose_buttons
      2300 buttons_args
      2316 cmd_buttons
      2619 darken_hex
      2632 install_fluent_glyphs
      2724 help_corners
      2747 help_tune
      2767 tune_recap
      2773 cmd_tune
      2822 tune_corners
      2850 tune_buttons
      2910 tune_widget
      2976 tune_newtab
      3040 tune_terminal
      3069 tune_theme
      3082 tune_font
      3091 help_refresh
      3108 cmd_refresh
      3167 cmd_corners
      3242 help_theme
      3296 theme_repo_for
      3338 help_themes
      3381 themes_bank
      3407 cmd_themes
      3443 themes_list
      3463 themes_install
      3534 themes_check
      3594 list_themes
      3620 theme_exists
      3631 lower
      3633 theme_real_name
      3645 theme_exists_ci
      3664 theme_tokens
      3675 theme_token
      3679 theme_variant_pos
      3707 theme_variant_of
      3729 theme_rebuild
      3763 theme_base_of
      3777 theme_swap_variant
      3789 theme_find_variant
      3862 theme_light_by_sibling
      3881 theme_has_dark_sibling
      3893 theme_list_variants
      3921 theme_switch_variant
      4014 cmd_theme
      4250 install_theme_check_symlink
      4272 theme_build
      4338 theme_copy_dir
      4351 install_theme
      4452 help_icons
      4490 list_user_icon_themes
      4502 list_icon_themes
      4514 cmd_icons
      4641 help_font
      4654 cmd_font
      4724 help_widget
      4761 weather_line_path
      4765 weather_line_install
      4803 widget_modules_table
      4816 widget_add_module
      4873 widget_init
      4956 cmd_widget
      5168 conf_value
      5180 hex_brightness
      5196 help_terminal
      5214 term_profile
      5223 cmd_terminal
      5328 apply_wal_palette
      5359 newtab_tiles_plain
      5381 help_newtab
      5403 overview_newtab
      5425 cmd_newtab
      5521 rebuild_newtab
      5732 tick
      5749 find_wallpaper_dir
      5764 current_wallpaper
      5782 detect_resolution
      5794 help_wallpapers
      5817 week_themes
      5826 wallpaper_urls
      5835 cmd_wallpapers
      6027 install_wallpaper_timer
      6095 prune_wallpapers
      6139 help_wall
      6164 cmd_wall
      6268 help_app
      6326 opacity_to_hex
      6332 opacity_windows_of
      6338 opacity_apply_now
      6355 opacity_install_watch
      6411 opacity_remove_watch
      6423 app_windows
      6483 app_opacity
      6583 cmd_app
      6726 help_serve
      6746 cmd_serve
      6859 cmd_status
      6954 help_revert
      6990 revert_terminal
      7028 revert_panel
      7063 revert_app
      7097 revert_keys
      7133 revert_serve
      7154 revert_gi_keys
      7170 cmd_revert
      7399 help_keys
      7425 keys_list_paths
      7430 keys_show
      7454 keys_add
      7540 keys_remove
      7587 cmd_keys
      7625 help_panel
      7654 panel_json_set
      7671 cmd_panel
      7781 cmd_audit
      7797 help_selftest
      7856 sb_write_stub
      7863 sandbox_new
      8086 sb_set
      8097 sb_get
      8105 sb_dconf
      8113 sandbox_run
      8139 sandbox_verify
      8163 sandbox_run_no
      8171 sandbox_drop
      8188 t_eq
      8202 t_ne
      8215 t_has
      8235 t_hasnt
      8253 t_hasnt_out
      8265 t_out_has
      8279 t_rc
      8293 t_rc_not
      8319 t_file
      8331 t_nofile
      8350 t_group
      8359 t_ok
      8361 t_fail
      8366 t_skip
      8371 t_detail
      8379 cmd_selftest
      8765 selftest_full
      8808 st_core
      8921 st_buttons
      9066 st_corners
      9093 st_theme
      9267 st_icons
      9340 st_font
      9372 st_widget
      9443 st_terminal
      9472 st_newtab
      9522 st_wall
      9556 st_wallpapers
      9598 st_keys
      9642 st_panel
      9688 st_app
      9720 st_serve
      9741 st_revert
      9798 st_themes
      9840 st_look
      9916 st_tabby
      9966 st_profile
      10041 st_refresh
      10089 st_tune
      10170 st_report
      10224 st_overview
      10261 st_presets
      10298 st_help
      10357 usage
      10418 help_settings
      10491 cmd_help
