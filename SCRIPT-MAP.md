# Карта desktop-kit.sh

Всего 11208 строк, 456 КБ, примерно 155 тыс. токенов целиком.

**Не читай файл целиком.** Найди место здесь или через `grep -n`, потом
`Read` с `offset`/`limit` на 40–80 строк и `Edit` по найденному фрагменту.

Пересобрать карту после правок: `bash tools/make-map.sh > SCRIPT-MAP.md`

## Рецепты: что где править

| Задача | Куда смотреть |
|---|---|
| Размер, цвет, подсветка кнопок заголовка | `cmd_buttons` — строка 2761, разбор ключей в начале, CSS ниже |
| Значки заголовка: откуда берутся | `install_fluent_glyphs` — строка 3077, адрес в $FLUENT_ICONS |
| Почему значков не видно | `diagnose_buttons` — строка 2630 |
| Скругление окон и меню | `cmd_corners` — строка 3612 |
| Тема окон, схема, переключение светлая/тёмная | `cmd_theme` — строка 4459 |
| Разбор имени темы на варианты | `theme_variant_of` — строка 4152, рядом theme_base_of, theme_swap_variant |
| Поиск парного варианта темы | `theme_find_variant` — строка 4234 |
| Добавить тему в банк | `theme_repo_for` — строка 3741, плюс themes_bank ниже |
| Список и установка тем банка | `cmd_themes` — строка 3852 |
| Проверка темы на совместимость с кнопками | `themes_check` — строка 3979 |
| Тема значков и цвет папок | `cmd_icons` — строка 4959 |
| Шрифты интерфейса | `cmd_font` — строка 5099 |
| Виджет conky: подложка, цвет, плотность | `cmd_widget` — строка 5401 |
| Прозрачность и палитра терминала | `cmd_terminal` — строка 5668 |
| Страница новой вкладки Chrome | `cmd_newtab` — строка 5870, разметка в heredoc ниже по функции |
| Плитки без python3 | `newtab_tiles_plain` — строка 5804 |
| Смена обоев по порядку | `cmd_wall` — строка 6609 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 6280 |
| Чистка банка обоев | `prune_wallpapers` — строка 6540 |
| Горячие клавиши | `cmd_keys` — строка 8032 |
| Панель Dash to Panel | `cmd_panel` — строка 8116 |
| Своя тема для приложения | `cmd_app` — строка 7028 |
| Прозрачность окна приложения | `app_opacity` — строка 6928, рядом opacity_install_watch — сторож |
| Настройки VSCodium, подсветка .txt | `cmd_codium` — строка 810, вставка блока — codium_settings_write |
| Локальная апка по http | `cmd_serve` — строка 7191 |
| Откат: общая логика | `cmd_revert` — строка 7615 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 7599 |
| Что показывает status | `cmd_status` — строка 7304 |
| Полный перечень изменяемого | `help_settings` — строка 11005 |
| Общий текст справки | `usage` — строка 10943 |
| Диспетчер команд (добавить новую) | ищи `случай) cmd_` в самом конце файла: `grep -n 'cmd_status "$@"' desktop-kit.sh` |
| Правила предшественника look.sh | `strip_legacy_css` — строка 2380 |
| Резервные копии и откат файлов | `backup_once` 2177, `restore_backup` 2207 |
| Блоки правил в gtk.css | `css_append` 2444, `css_strip` 2346 |
| Запомнить значение для отката | `remember` 2312 / `recall` 2328 |
| Наши текущие настройки | `state_set` 2282 / `state_get` 2297 |

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
| `buttons` | 2761 | 2578 | 9374 |
| `corners` | 3612 | 3169 | 9519 |
| `theme` | 4459 | 3687 | 9546 |
| `themes` | 3852 | 3783 | 10251 |
| `icons` | 4959 | 4897 | 9720 |
| `font` | 5099 | 5086 | 9793 |
| `widget` | 5401 | 5169 | 9825 |
| `terminal` | 5668 | 5641 | 9896 |
| `newtab` | 5870 | 5826 | 9925 |
| `wallpapers` | 6280 | 6239 | 10009 |
| `wall` | 6609 | 6584 | 9975 |
| `serve` | 7191 | 7171 | 10173 |
| `app` | 7028 | 6713 | 10141 |
| `keys` | 8032 | 7844 | 10051 |
| `panel` | 8116 | 8070 | 10095 |
| `audit` | 8226 | — | — |
| `status` | 7304 | — | — |
| `selftest` | 8832 | 8242 | — |
| `revert` | 7615 | 7399 | 10194 |

## Секции файла

    3  desktop-kit — единый инструмент настройки десктопа Ubuntu 24.04 / GNOME 46
    5  Одна команда на каждую подсистему, единый откат, единый лог,
    6  самопроверка прямо на рабочей машине.
    15  ЧТО ЗДЕСЬ УЧТЕНО (каждый пункт стоил отдельного круга отладки)
    148  Обзор команды: что сейчас, что можно
    270  tabby — стеклянный терминал
    505  codium — редактор VSCodium
    950  look — готовые образы рабочего стола
    1135  profile — снимок оформления целиком
    1502  Банк тем значков
    1839  Тема для GTK4-приложений
    1922  Пресеты: именованные наборы параметров
    2008  Вопросы пользователю
    2575  buttons — кнопки заголовка окна
    3166  corners — скругление окон
    3189  tune — настройка вопросами
    3684  theme — тема GTK
    3773  themes — банк готовых тем
    4894  icons — тема значков и цвет папок
    5083  font — шрифт интерфейса
    5166  widget — виджет conky
    5638  terminal — GNOME Terminal
    5799  newtab — страница новой вкладки Chrome
    6191  wallpapers / wall — банк обоев и смена
    6710  app — тема отдельного приложения
    7168  serve — локальная апка по http
    7301  status — что применено
    7396  revert — откат
    7841  keys — горячие клавиши
    8067  panel — Dash to Panel
    8223  audit — снимок системы
    8239  selftest — проверка на живой машине
    8282  Каркас самопроверки: песочница с подставными внешними программами
    10940  help и диспетчер

## Пути и константы

    38  VERSION="1.7"
    42  VERSION_DATE="11.09.2026"
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
    534  CODIUM_SETTINGS="$HOME/.config/VSCodium/User/settings.json"
    535  CODIUM_MARK_BEGIN="// dk:codium-begin"
    536  CODIUM_MARK_END="// dk:codium-end"
    1148  PROFILE_DIR="$STATE_DIR/profiles"
    2004  PRESET_ARGS=""

## Где генерируется CSS

    2874  css_append buttons "$CSS3" "$(cat <<EOF
    2890  css_append buttons "$CSS4" "$(cat <<EOF
    2912  css_append buttons "$CSS3" "$(cat <<EOF
    2980  css_append buttons "$CSS4" "$(cat <<EOF
    3645  css_append corners "$CSS3" "$(cat <<EOF
    3663  css_append corners "$CSS4" "$(cat <<EOF

Селекторы, которые чаще всего правятся:
    2876  headerbar button.titlebutton,
    2878  button.titlebutton {
    2883  headerbar button.titlebutton image,
    2885  button.titlebutton image {
    2892  windowcontrols > button,
    2898  windowcontrols > button > image {
    2915  headerbar button.titlebutton,
    2917  button.titlebutton {
    2925  headerbar button.titlebutton image,
    2927  button.titlebutton image {
    2936  headerbar button.titlebutton:hover,
    2938  button.titlebutton:hover {
    2944  headerbar button.titlebutton:hover image,
    2945  button.titlebutton:hover image {

## Ключи состояния

Для отката (пишутся один раз, файл before.env):
    remember CODIUM_TXT_HANDLER
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
    state_set CODIUM_PARTS
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

    группы:      core buttons corners theme icons font widget terminal newtab wall wallpapers keys panel app serve revert themes look profile tabby codium refresh tune report presets overview help
    каркас:      sandbox_new 8308, sandbox_run 8566
    утверждения: t_eq 8641, t_has 8668, t_out_has 8718, t_rc 8732
    заглушки:    14 штук, ищи sb_write_stub

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
      538  help_codium
      574  codium_part_txt
      605  codium_part_alt
      619  codium_block
      653  codium_parts_current
      673  codium_parts_merge
      688  codium_strip_block
      702  codium_settings_write
      765  codium_desktop
      783  codium_show
      810  cmd_codium
      968  look_table
      976  look_names
      980  help_look
      1005 look_list
      1018 look_show
      1040 look_apply
      1109 cmd_look
      1153 profile_keys
      1179 profile_files
      1188 help_profile
      1219 profile_autoname
      1223 profile_list_names
      1235 profile_save
      1303 profile_load
      1400 profile_show
      1428 profile_drop
      1449 profile_list
      1472 cmd_profile
      1514 icons_bank
      1539 icons_repo_for
      1543 icons_bank_list
      1579 icons_clean
      1604 git_clone_retry
      1676 disk_room_warn
      1707 icons_copy_theme
      1722 icons_get
      1856 theme_gtk4_css
      1870 gtk4_theme_unlink
      1885 gtk4_theme_apply
      1931 presets_table
      1961 preset_args
      1969 presets_names
      1974 presets_list
      1983 preset_expand
      2019 ask_possible
      2031 ask_head
      2040 ask_num
      2077 ask_pick
      2123 ask_str
      2141 ask_yes
      2153 would
      2163 gi_get
      2164 gi_set
      2171 have
      2177 backup_once
      2207 restore_backup
      2282 state_set
      2297 state_get
      2312 remember
      2328 recall
      2346 css_strip
      2368 has_legacy_css
      2380 strip_legacy_css
      2432 icon_base_of
      2444 css_append
      2463 css_has
      2469 untangle_css
      2493 untangle_gtk4
      2497 untangle_gtk3
      2503 restart_gtk_apps
      2518 restart_conky
      2541 need_args
      2550 is_number
      2554 is_decimal
      2558 is_hex_colour
      2562 require_tools
      2578 help_buttons
      2630 diagnose_buttons
      2745 buttons_args
      2761 cmd_buttons
      3064 darken_hex
      3077 install_fluent_glyphs
      3169 help_corners
      3192 help_tune
      3212 tune_recap
      3218 cmd_tune
      3267 tune_corners
      3295 tune_buttons
      3355 tune_widget
      3421 tune_newtab
      3485 tune_terminal
      3514 tune_theme
      3527 tune_font
      3536 help_refresh
      3553 cmd_refresh
      3612 cmd_corners
      3687 help_theme
      3741 theme_repo_for
      3783 help_themes
      3826 themes_bank
      3852 cmd_themes
      3888 themes_list
      3908 themes_install
      3979 themes_check
      4039 list_themes
      4065 theme_exists
      4076 lower
      4078 theme_real_name
      4090 theme_exists_ci
      4109 theme_tokens
      4120 theme_token
      4124 theme_variant_pos
      4152 theme_variant_of
      4174 theme_rebuild
      4208 theme_base_of
      4222 theme_swap_variant
      4234 theme_find_variant
      4307 theme_light_by_sibling
      4326 theme_has_dark_sibling
      4338 theme_list_variants
      4366 theme_switch_variant
      4459 cmd_theme
      4695 install_theme_check_symlink
      4717 theme_build
      4783 theme_copy_dir
      4796 install_theme
      4897 help_icons
      4935 list_user_icon_themes
      4947 list_icon_themes
      4959 cmd_icons
      5086 help_font
      5099 cmd_font
      5169 help_widget
      5206 weather_line_path
      5210 weather_line_install
      5248 widget_modules_table
      5261 widget_add_module
      5318 widget_init
      5401 cmd_widget
      5613 conf_value
      5625 hex_brightness
      5641 help_terminal
      5659 term_profile
      5668 cmd_terminal
      5773 apply_wal_palette
      5804 newtab_tiles_plain
      5826 help_newtab
      5848 overview_newtab
      5870 cmd_newtab
      5966 rebuild_newtab
      6177 tick
      6194 find_wallpaper_dir
      6209 current_wallpaper
      6227 detect_resolution
      6239 help_wallpapers
      6262 week_themes
      6271 wallpaper_urls
      6280 cmd_wallpapers
      6472 install_wallpaper_timer
      6540 prune_wallpapers
      6584 help_wall
      6609 cmd_wall
      6713 help_app
      6771 opacity_to_hex
      6777 opacity_windows_of
      6783 opacity_apply_now
      6800 opacity_install_watch
      6856 opacity_remove_watch
      6868 app_windows
      6928 app_opacity
      7028 cmd_app
      7171 help_serve
      7191 cmd_serve
      7304 cmd_status
      7399 help_revert
      7435 revert_terminal
      7473 revert_panel
      7508 revert_app
      7542 revert_keys
      7578 revert_serve
      7599 revert_gi_keys
      7615 cmd_revert
      7844 help_keys
      7870 keys_list_paths
      7875 keys_show
      7899 keys_add
      7985 keys_remove
      8032 cmd_keys
      8070 help_panel
      8099 panel_json_set
      8116 cmd_panel
      8226 cmd_audit
      8242 help_selftest
      8301 sb_write_stub
      8308 sandbox_new
      8539 sb_set
      8550 sb_get
      8558 sb_dconf
      8566 sandbox_run
      8592 sandbox_verify
      8616 sandbox_run_no
      8624 sandbox_drop
      8641 t_eq
      8655 t_ne
      8668 t_has
      8688 t_hasnt
      8706 t_hasnt_out
      8718 t_out_has
      8732 t_rc
      8746 t_rc_not
      8772 t_file
      8784 t_nofile
      8803 t_group
      8812 t_ok
      8814 t_fail
      8819 t_skip
      8824 t_detail
      8832 cmd_selftest
      9218 selftest_full
      9261 st_core
      9374 st_buttons
      9519 st_corners
      9546 st_theme
      9720 st_icons
      9793 st_font
      9825 st_widget
      9896 st_terminal
      9925 st_newtab
      9975 st_wall
      10009 st_wallpapers
      10051 st_keys
      10095 st_panel
      10141 st_app
      10173 st_serve
      10194 st_revert
      10251 st_themes
      10293 st_look
      10369 st_tabby
      10421 codium_tail_of
      10426 st_codium
      10552 st_profile
      10627 st_refresh
      10675 st_tune
      10756 st_report
      10810 st_overview
      10847 st_presets
      10884 st_help
      10943 usage
      11005 help_settings
      11078 cmd_help
