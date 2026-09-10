# Карта desktop-kit.sh

Всего 11041 строк, 448 КБ, примерно 153 тыс. токенов целиком.

**Не читай файл целиком.** Найди место здесь или через `grep -n`, потом
`Read` с `offset`/`limit` на 40–80 строк и `Edit` по найденному фрагменту.

Пересобрать карту после правок: `bash tools/make-map.sh > SCRIPT-MAP.md`

## Рецепты: что где править

| Задача | Куда смотреть |
|---|---|
| Размер, цвет, подсветка кнопок заголовка | `cmd_buttons` — строка 2630, разбор ключей в начале, CSS ниже |
| Значки заголовка: откуда берутся | `install_fluent_glyphs` — строка 2946, адрес в $FLUENT_ICONS |
| Почему значков не видно | `diagnose_buttons` — строка 2499 |
| Скругление окон и меню | `cmd_corners` — строка 3481 |
| Тема окон, схема, переключение светлая/тёмная | `cmd_theme` — строка 4328 |
| Разбор имени темы на варианты | `theme_variant_of` — строка 4021, рядом theme_base_of, theme_swap_variant |
| Поиск парного варианта темы | `theme_find_variant` — строка 4103 |
| Добавить тему в банк | `theme_repo_for` — строка 3610, плюс themes_bank ниже |
| Список и установка тем банка | `cmd_themes` — строка 3721 |
| Проверка темы на совместимость с кнопками | `themes_check` — строка 3848 |
| Тема значков и цвет папок | `cmd_icons` — строка 4828 |
| Шрифты интерфейса | `cmd_font` — строка 4968 |
| Виджет conky: подложка, цвет, плотность | `cmd_widget` — строка 5270 |
| Прозрачность и палитра терминала | `cmd_terminal` — строка 5537 |
| Страница новой вкладки Chrome | `cmd_newtab` — строка 5739, разметка в heredoc ниже по функции |
| Плитки без python3 | `newtab_tiles_plain` — строка 5673 |
| Смена обоев по порядку | `cmd_wall` — строка 6478 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 6149 |
| Чистка банка обоев | `prune_wallpapers` — строка 6409 |
| Горячие клавиши | `cmd_keys` — строка 7901 |
| Панель Dash to Panel | `cmd_panel` — строка 7985 |
| Своя тема для приложения | `cmd_app` — строка 6897 |
| Прозрачность окна приложения | `app_opacity` — строка 6797, рядом opacity_install_watch — сторож |
| Настройки VSCodium, подсветка .txt | `cmd_codium` — строка 714, вставка блока — codium_settings_write |
| Локальная апка по http | `cmd_serve` — строка 7060 |
| Откат: общая логика | `cmd_revert` — строка 7484 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 7468 |
| Что показывает status | `cmd_status` — строка 7173 |
| Полный перечень изменяемого | `help_settings` — строка 10838 |
| Общий текст справки | `usage` — строка 10776 |
| Диспетчер команд (добавить новую) | ищи `случай) cmd_` в самом конце файла: `grep -n 'cmd_status "$@"' desktop-kit.sh` |
| Правила предшественника look.sh | `strip_legacy_css` — строка 2249 |
| Резервные копии и откат файлов | `backup_once` 2046, `restore_backup` 2076 |
| Блоки правил в gtk.css | `css_append` 2313, `css_strip` 2215 |
| Запомнить значение для отката | `remember` 2181 / `recall` 2197 |
| Наши текущие настройки | `state_set` 2151 / `state_get` 2166 |

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
| `buttons` | 2630 | 2447 | 9243 |
| `corners` | 3481 | 3038 | 9388 |
| `theme` | 4328 | 3556 | 9415 |
| `themes` | 3721 | 3652 | 10120 |
| `icons` | 4828 | 4766 | 9589 |
| `font` | 4968 | 4955 | 9662 |
| `widget` | 5270 | 5038 | 9694 |
| `terminal` | 5537 | 5510 | 9765 |
| `newtab` | 5739 | 5695 | 9794 |
| `wallpapers` | 6149 | 6108 | 9878 |
| `wall` | 6478 | 6453 | 9844 |
| `serve` | 7060 | 7040 | 10042 |
| `app` | 6897 | 6582 | 10010 |
| `keys` | 7901 | 7713 | 9920 |
| `panel` | 7985 | 7939 | 9964 |
| `audit` | 8095 | — | — |
| `status` | 7173 | — | — |
| `selftest` | 8701 | 8111 | — |
| `revert` | 7484 | 7268 | 10063 |

## Секции файла

    3  desktop-kit — единый инструмент настройки десктопа Ubuntu 24.04 / GNOME 46
    5  Одна команда на каждую подсистему, единый откат, единый лог,
    6  самопроверка прямо на рабочей машине.
    15  ЧТО ЗДЕСЬ УЧТЕНО (каждый пункт стоил отдельного круга отладки)
    148  Обзор команды: что сейчас, что можно
    270  tabby — стеклянный терминал
    505  codium — редактор VSCodium
    819  look — готовые образы рабочего стола
    1004  profile — снимок оформления целиком
    1371  Банк тем значков
    1708  Тема для GTK4-приложений
    1791  Пресеты: именованные наборы параметров
    1877  Вопросы пользователю
    2444  buttons — кнопки заголовка окна
    3035  corners — скругление окон
    3058  tune — настройка вопросами
    3553  theme — тема GTK
    3642  themes — банк готовых тем
    4763  icons — тема значков и цвет папок
    4952  font — шрифт интерфейса
    5035  widget — виджет conky
    5507  terminal — GNOME Terminal
    5668  newtab — страница новой вкладки Chrome
    6060  wallpapers / wall — банк обоев и смена
    6579  app — тема отдельного приложения
    7037  serve — локальная апка по http
    7170  status — что применено
    7265  revert — откат
    7710  keys — горячие клавиши
    7936  panel — Dash to Panel
    8092  audit — снимок системы
    8108  selftest — проверка на живой машине
    8151  Каркас самопроверки: песочница с подставными внешними программами
    10773  help и диспетчер

## Пути и константы

    38  VERSION="1.5"
    42  VERSION_DATE="10.09.2026"
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
    529  CODIUM_SETTINGS="$HOME/.config/VSCodium/User/settings.json"
    530  CODIUM_MARK_BEGIN="// dk:codium-begin"
    531  CODIUM_MARK_END="// dk:codium-end"
    1017  PROFILE_DIR="$STATE_DIR/profiles"
    1873  PRESET_ARGS=""

## Где генерируется CSS

    2743  css_append buttons "$CSS3" "$(cat <<EOF
    2759  css_append buttons "$CSS4" "$(cat <<EOF
    2781  css_append buttons "$CSS3" "$(cat <<EOF
    2849  css_append buttons "$CSS4" "$(cat <<EOF
    3514  css_append corners "$CSS3" "$(cat <<EOF
    3532  css_append corners "$CSS4" "$(cat <<EOF

Селекторы, которые чаще всего правятся:
    2745  headerbar button.titlebutton,
    2747  button.titlebutton {
    2752  headerbar button.titlebutton image,
    2754  button.titlebutton image {
    2761  windowcontrols > button,
    2767  windowcontrols > button > image {
    2784  headerbar button.titlebutton,
    2786  button.titlebutton {
    2794  headerbar button.titlebutton image,
    2796  button.titlebutton image {
    2805  headerbar button.titlebutton:hover,
    2807  button.titlebutton:hover {
    2813  headerbar button.titlebutton:hover image,
    2814  button.titlebutton:hover image {

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
    каркас:      sandbox_new 8177, sandbox_run 8435
    утверждения: t_eq 8510, t_has 8537, t_out_has 8587, t_rc 8601
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
      533  help_codium
      559  codium_block
      599  codium_strip_block
      613  codium_settings_write
      675  codium_desktop
      693  codium_show
      714  cmd_codium
      837  look_table
      845  look_names
      849  help_look
      874  look_list
      887  look_show
      909  look_apply
      978  cmd_look
      1022 profile_keys
      1048 profile_files
      1057 help_profile
      1088 profile_autoname
      1092 profile_list_names
      1104 profile_save
      1172 profile_load
      1269 profile_show
      1297 profile_drop
      1318 profile_list
      1341 cmd_profile
      1383 icons_bank
      1408 icons_repo_for
      1412 icons_bank_list
      1448 icons_clean
      1473 git_clone_retry
      1545 disk_room_warn
      1576 icons_copy_theme
      1591 icons_get
      1725 theme_gtk4_css
      1739 gtk4_theme_unlink
      1754 gtk4_theme_apply
      1800 presets_table
      1830 preset_args
      1838 presets_names
      1843 presets_list
      1852 preset_expand
      1888 ask_possible
      1900 ask_head
      1909 ask_num
      1946 ask_pick
      1992 ask_str
      2010 ask_yes
      2022 would
      2032 gi_get
      2033 gi_set
      2040 have
      2046 backup_once
      2076 restore_backup
      2151 state_set
      2166 state_get
      2181 remember
      2197 recall
      2215 css_strip
      2237 has_legacy_css
      2249 strip_legacy_css
      2301 icon_base_of
      2313 css_append
      2332 css_has
      2338 untangle_css
      2362 untangle_gtk4
      2366 untangle_gtk3
      2372 restart_gtk_apps
      2387 restart_conky
      2410 need_args
      2419 is_number
      2423 is_decimal
      2427 is_hex_colour
      2431 require_tools
      2447 help_buttons
      2499 diagnose_buttons
      2614 buttons_args
      2630 cmd_buttons
      2933 darken_hex
      2946 install_fluent_glyphs
      3038 help_corners
      3061 help_tune
      3081 tune_recap
      3087 cmd_tune
      3136 tune_corners
      3164 tune_buttons
      3224 tune_widget
      3290 tune_newtab
      3354 tune_terminal
      3383 tune_theme
      3396 tune_font
      3405 help_refresh
      3422 cmd_refresh
      3481 cmd_corners
      3556 help_theme
      3610 theme_repo_for
      3652 help_themes
      3695 themes_bank
      3721 cmd_themes
      3757 themes_list
      3777 themes_install
      3848 themes_check
      3908 list_themes
      3934 theme_exists
      3945 lower
      3947 theme_real_name
      3959 theme_exists_ci
      3978 theme_tokens
      3989 theme_token
      3993 theme_variant_pos
      4021 theme_variant_of
      4043 theme_rebuild
      4077 theme_base_of
      4091 theme_swap_variant
      4103 theme_find_variant
      4176 theme_light_by_sibling
      4195 theme_has_dark_sibling
      4207 theme_list_variants
      4235 theme_switch_variant
      4328 cmd_theme
      4564 install_theme_check_symlink
      4586 theme_build
      4652 theme_copy_dir
      4665 install_theme
      4766 help_icons
      4804 list_user_icon_themes
      4816 list_icon_themes
      4828 cmd_icons
      4955 help_font
      4968 cmd_font
      5038 help_widget
      5075 weather_line_path
      5079 weather_line_install
      5117 widget_modules_table
      5130 widget_add_module
      5187 widget_init
      5270 cmd_widget
      5482 conf_value
      5494 hex_brightness
      5510 help_terminal
      5528 term_profile
      5537 cmd_terminal
      5642 apply_wal_palette
      5673 newtab_tiles_plain
      5695 help_newtab
      5717 overview_newtab
      5739 cmd_newtab
      5835 rebuild_newtab
      6046 tick
      6063 find_wallpaper_dir
      6078 current_wallpaper
      6096 detect_resolution
      6108 help_wallpapers
      6131 week_themes
      6140 wallpaper_urls
      6149 cmd_wallpapers
      6341 install_wallpaper_timer
      6409 prune_wallpapers
      6453 help_wall
      6478 cmd_wall
      6582 help_app
      6640 opacity_to_hex
      6646 opacity_windows_of
      6652 opacity_apply_now
      6669 opacity_install_watch
      6725 opacity_remove_watch
      6737 app_windows
      6797 app_opacity
      6897 cmd_app
      7040 help_serve
      7060 cmd_serve
      7173 cmd_status
      7268 help_revert
      7304 revert_terminal
      7342 revert_panel
      7377 revert_app
      7411 revert_keys
      7447 revert_serve
      7468 revert_gi_keys
      7484 cmd_revert
      7713 help_keys
      7739 keys_list_paths
      7744 keys_show
      7768 keys_add
      7854 keys_remove
      7901 cmd_keys
      7939 help_panel
      7968 panel_json_set
      7985 cmd_panel
      8095 cmd_audit
      8111 help_selftest
      8170 sb_write_stub
      8177 sandbox_new
      8408 sb_set
      8419 sb_get
      8427 sb_dconf
      8435 sandbox_run
      8461 sandbox_verify
      8485 sandbox_run_no
      8493 sandbox_drop
      8510 t_eq
      8524 t_ne
      8537 t_has
      8557 t_hasnt
      8575 t_hasnt_out
      8587 t_out_has
      8601 t_rc
      8615 t_rc_not
      8641 t_file
      8653 t_nofile
      8672 t_group
      8681 t_ok
      8683 t_fail
      8688 t_skip
      8693 t_detail
      8701 cmd_selftest
      9087 selftest_full
      9130 st_core
      9243 st_buttons
      9388 st_corners
      9415 st_theme
      9589 st_icons
      9662 st_font
      9694 st_widget
      9765 st_terminal
      9794 st_newtab
      9844 st_wall
      9878 st_wallpapers
      9920 st_keys
      9964 st_panel
      10010 st_app
      10042 st_serve
      10063 st_revert
      10120 st_themes
      10162 st_look
      10238 st_tabby
      10290 codium_tail_of
      10295 st_codium
      10385 st_profile
      10460 st_refresh
      10508 st_tune
      10589 st_report
      10643 st_overview
      10680 st_presets
      10717 st_help
      10776 usage
      10838 help_settings
      10911 cmd_help
