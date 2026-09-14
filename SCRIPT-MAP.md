# Карта desktop-kit.sh

Всего 11799 строк, 489 КБ, примерно 167 тыс. токенов целиком.

**Не читай файл целиком.** Найди место здесь или через `grep -n`, потом
`Read` с `offset`/`limit` на 40–80 строк и `Edit` по найденному фрагменту.

Пересобрать карту после правок: `bash tools/make-map.sh > SCRIPT-MAP.md`

## Рецепты: что где править

| Задача | Куда смотреть |
|---|---|
| Размер, цвет, подсветка кнопок заголовка | `cmd_buttons` — строка 2778, разбор ключей в начале, CSS ниже |
| Значки заголовка: откуда берутся | `install_fluent_glyphs` — строка 3094, адрес в $FLUENT_ICONS |
| Почему значков не видно | `diagnose_buttons` — строка 2647 |
| Скругление окон и меню | `cmd_corners` — строка 3629 |
| Тема окон, схема, переключение светлая/тёмная | `cmd_theme` — строка 4476 |
| Разбор имени темы на варианты | `theme_variant_of` — строка 4169, рядом theme_base_of, theme_swap_variant |
| Поиск парного варианта темы | `theme_find_variant` — строка 4251 |
| Добавить тему в банк | `theme_repo_for` — строка 3758, плюс themes_bank ниже |
| Список и установка тем банка | `cmd_themes` — строка 3869 |
| Проверка темы на совместимость с кнопками | `themes_check` — строка 3996 |
| Тема значков и цвет папок | `cmd_icons` — строка 4976 |
| Шрифты интерфейса | `cmd_font` — строка 5116 |
| Виджет conky: подложка, цвет, плотность | `cmd_widget` — строка 5530 |
| Прозрачность и палитра терминала | `cmd_terminal` — строка 5843 |
| Страница новой вкладки Chrome | `cmd_newtab` — строка 6051, разметка в heredoc ниже по функции |
| Плитки без python3 | `newtab_tiles_plain` — строка 5985 |
| Смена обоев по порядку | `cmd_wall` — строка 7068 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 6726 |
| Чистка банка обоев | `prune_wallpapers` — строка 6999 |
| Горячие клавиши | `cmd_keys` — строка 8500 |
| Панель Dash to Panel | `cmd_panel` — строка 8636 |
| Своя тема для приложения | `cmd_app` — строка 7487 |
| Прозрачность окна приложения | `app_opacity` — строка 7387, рядом opacity_install_watch — сторож |
| Настройки VSCodium, подсветка .txt | `cmd_codium` — строка 826, вставка блока — codium_settings_write |
| Локальная апка по http | `cmd_serve` — строка 7650 |
| Откат: общая логика | `cmd_revert` — строка 8083 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 8067 |
| Что показывает status | `cmd_status` — строка 7763 |
| Полный перечень изменяемого | `help_settings` — строка 11596 |
| Общий текст справки | `usage` — строка 11533 |
| Диспетчер команд (добавить новую) | ищи `случай) cmd_` в самом конце файла: `grep -n 'cmd_status "$@"' desktop-kit.sh` |
| Правила предшественника look.sh | `strip_legacy_css` — строка 2397 |
| Резервные копии и откат файлов | `backup_once` 2194, `restore_backup` 2224 |
| Блоки правил в gtk.css | `css_append` 2461, `css_strip` 2363 |
| Запомнить значение для отката | `remember` 2329 / `recall` 2345 |
| Наши текущие настройки | `state_set` 2299 / `state_get` 2314 |

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
| `buttons` | 2778 | 2595 | 9906 |
| `corners` | 3629 | 3186 | 10051 |
| `theme` | 4476 | 3704 | 10078 |
| `themes` | 3869 | 3800 | 10825 |
| `icons` | 4976 | 4914 | 10252 |
| `font` | 5116 | 5103 | 10325 |
| `widget` | 5530 | 5200 | 10357 |
| `terminal` | 5843 | 5816 | 10437 |
| `newtab` | 6051 | 6007 | 10466 |
| `wallpapers` | 6726 | 6420 | 10550 |
| `wall` | 7068 | 7043 | 10516 |
| `serve` | 7650 | 7630 | 10747 |
| `app` | 7487 | 7172 | 10715 |
| `keys` | 8500 | 8312 | 10613 |
| `panel` | 8636 | 8538 | 10657 |
| `audit` | 8758 | — | — |
| `status` | 7763 | — | — |
| `selftest` | 9364 | 8774 | — |
| `revert` | 8083 | 7858 | 10768 |

## Секции файла


## Пути и константы

    38  VERSION="1.16"
    42  VERSION_DATE="14.09.2026"
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
    88  REPO_RAW="https://raw.githubusercontent.com/kubeengineering/kubeelinux/main"
    89  WALLHAVEN="https://wallhaven.cc/api/v1/search"
    93  DRY_RUN=0
    94  ASSUME_YES=0
    95  QUIET=0
    287  TABBY_CONF="$HOME/.config/tabby/config.yaml"
    288  TABBY_MARK_BEGIN="/* dk:tabby-begin */"
    289  TABBY_MARK_END="/* dk:tabby-end */"
    550  CODIUM_SETTINGS="$HOME/.config/VSCodium/User/settings.json"
    551  CODIUM_MARK_BEGIN="// dk:codium-begin"
    552  CODIUM_MARK_END="// dk:codium-end"
    1165  PROFILE_DIR="$STATE_DIR/profiles"

## Где генерируется CSS

    2891  css_append buttons "$CSS3" "$(cat <<EOF
    2907  css_append buttons "$CSS4" "$(cat <<EOF
    2929  css_append buttons "$CSS3" "$(cat <<EOF
    2997  css_append buttons "$CSS4" "$(cat <<EOF
    3662  css_append corners "$CSS3" "$(cat <<EOF
    3680  css_append corners "$CSS4" "$(cat <<EOF

Селекторы, которые чаще всего правятся:
    2893  headerbar button.titlebutton,
    2895  button.titlebutton {
    2900  headerbar button.titlebutton image,
    2902  button.titlebutton image {
    2909  windowcontrols > button,
    2915  windowcontrols > button > image {
    2932  headerbar button.titlebutton,
    2934  button.titlebutton {
    2942  headerbar button.titlebutton image,
    2944  button.titlebutton image {
    2953  headerbar button.titlebutton:hover,
    2955  button.titlebutton:hover {
    2961  headerbar button.titlebutton:hover image,
    2962  button.titlebutton:hover image {

## Ключи состояния

Для отката (пишутся один раз, файл before.env):
    remember CODIUM_TXT_HANDLER
    remember COLOR_SCHEME
    remember DTP_ANCHORS
    remember DTP_CUSTOM
    remember DTP_LENGTHS
    remember DTP_OPACITY
    remember DTP_RADIUS
    remember DTP_SIDEMARGIN
    remember DTP_SIZES
    remember DTP_TBMARGIN
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
    каркас:      sandbox_new 8840, sandbox_run 9098
    утверждения: t_eq 9173, t_has 9200, t_out_has 9250, t_rc 9264
    заглушки:    14 штук, ищи sb_write_stub

Запуск одной группы: `bash desktop-kit.sh selftest --only theme`

## Все функции

      97   ok
      98   bad
      99   note
      101  blank
      104  dump
      112  hint
      113  head1
      115  log
      120  die
      126  confirm
      162  overview_head
      167  overview_presets
      174  overview_tail
      181  overview_buttons
      207  overview_corners
      224  overview_widget
      250  overview_terminal
      297  tabby_strip_block
      309  help_tabby
      340  tabby_css_block
      373  tabby_hex_to_rgb
      380  tabby_show
      405  cmd_tabby
      554  help_codium
      590  codium_part_txt
      621  codium_part_alt
      635  codium_block
      669  codium_parts_current
      689  codium_parts_merge
      704  codium_strip_block
      718  codium_settings_write
      781  codium_desktop
      799  codium_show
      826  cmd_codium
      984  look_table
      993  look_names
      997  help_look
      1022 look_list
      1035 look_show
      1057 look_apply
      1126 cmd_look
      1170 profile_keys
      1196 profile_files
      1205 help_profile
      1236 profile_autoname
      1240 profile_list_names
      1252 profile_save
      1320 profile_load
      1417 profile_show
      1445 profile_drop
      1466 profile_list
      1489 cmd_profile
      1531 icons_bank
      1556 icons_repo_for
      1560 icons_bank_list
      1596 icons_clean
      1621 git_clone_retry
      1693 disk_room_warn
      1724 icons_copy_theme
      1739 icons_get
      1873 theme_gtk4_css
      1887 gtk4_theme_unlink
      1902 gtk4_theme_apply
      1948 presets_table
      1978 preset_args
      1986 presets_names
      1991 presets_list
      2000 preset_expand
      2036 ask_possible
      2048 ask_head
      2057 ask_num
      2094 ask_pick
      2140 ask_str
      2158 ask_yes
      2170 would
      2180 gi_get
      2181 gi_set
      2188 have
      2194 backup_once
      2224 restore_backup
      2299 state_set
      2314 state_get
      2329 remember
      2345 recall
      2363 css_strip
      2385 has_legacy_css
      2397 strip_legacy_css
      2449 icon_base_of
      2461 css_append
      2480 css_has
      2486 untangle_css
      2510 untangle_gtk4
      2514 untangle_gtk3
      2520 restart_gtk_apps
      2535 restart_conky
      2558 need_args
      2567 is_number
      2571 is_decimal
      2575 is_hex_colour
      2579 require_tools
      2595 help_buttons
      2647 diagnose_buttons
      2762 buttons_args
      2778 cmd_buttons
      3081 darken_hex
      3094 install_fluent_glyphs
      3186 help_corners
      3209 help_tune
      3229 tune_recap
      3235 cmd_tune
      3284 tune_corners
      3312 tune_buttons
      3372 tune_widget
      3438 tune_newtab
      3502 tune_terminal
      3531 tune_theme
      3544 tune_font
      3553 help_refresh
      3570 cmd_refresh
      3629 cmd_corners
      3704 help_theme
      3758 theme_repo_for
      3800 help_themes
      3843 themes_bank
      3869 cmd_themes
      3905 themes_list
      3925 themes_install
      3996 themes_check
      4056 list_themes
      4082 theme_exists
      4093 lower
      4095 theme_real_name
      4107 theme_exists_ci
      4126 theme_tokens
      4137 theme_token
      4141 theme_variant_pos
      4169 theme_variant_of
      4191 theme_rebuild
      4225 theme_base_of
      4239 theme_swap_variant
      4251 theme_find_variant
      4324 theme_light_by_sibling
      4343 theme_has_dark_sibling
      4355 theme_list_variants
      4383 theme_switch_variant
      4476 cmd_theme
      4712 install_theme_check_symlink
      4734 theme_build
      4800 theme_copy_dir
      4813 install_theme
      4914 help_icons
      4952 list_user_icon_themes
      4964 list_icon_themes
      4976 cmd_icons
      5103 help_font
      5116 cmd_font
      5200 help_widget
      5240 weather_line_path
      5244 weather_line_install
      5332 widget_modules_table
      5345 widget_add_module
      5402 widget_init
      5530 cmd_widget
      5783 conf_value
      5800 hex_brightness
      5816 help_terminal
      5834 term_profile
      5843 cmd_terminal
      5954 apply_wal_palette
      5985 newtab_tiles_plain
      6007 help_newtab
      6029 overview_newtab
      6051 cmd_newtab
      6147 rebuild_newtab
      6358 tick
      6375 find_wallpaper_dir
      6390 current_wallpaper
      6408 detect_resolution
      6420 help_wallpapers
      6454 week_themes
      6463 wallpaper_urls
      6500 wall_url_of
      6515 walls_manifest_dest
      6552 walls_publish
      6594 walls_export
      6657 walls_sync
      6726 cmd_wallpapers
      6931 install_wallpaper_timer
      6999 prune_wallpapers
      7043 help_wall
      7068 cmd_wall
      7172 help_app
      7230 opacity_to_hex
      7236 opacity_windows_of
      7242 opacity_apply_now
      7259 opacity_install_watch
      7315 opacity_remove_watch
      7327 app_windows
      7387 app_opacity
      7487 cmd_app
      7630 help_serve
      7650 cmd_serve
      7763 cmd_status
      7858 help_revert
      7894 revert_terminal
      7932 revert_panel
      7976 revert_app
      8010 revert_keys
      8046 revert_serve
      8067 revert_gi_keys
      8083 cmd_revert
      8312 help_keys
      8338 keys_list_paths
      8343 keys_show
      8367 keys_add
      8453 keys_remove
      8500 cmd_keys
      8538 help_panel
      8582 panel_float_style
      8603 panel_json_set
      8636 cmd_panel
      8758 cmd_audit
      8774 help_selftest
      8833 sb_write_stub
      8840 sandbox_new
      9071 sb_set
      9082 sb_get
      9090 sb_dconf
      9098 sandbox_run
      9124 sandbox_verify
      9148 sandbox_run_no
      9156 sandbox_drop
      9173 t_eq
      9187 t_ne
      9200 t_has
      9220 t_hasnt
      9238 t_hasnt_out
      9250 t_out_has
      9264 t_rc
      9278 t_rc_not
      9304 t_file
      9316 t_nofile
      9335 t_group
      9344 t_ok
      9346 t_fail
      9351 t_skip
      9356 t_detail
      9364 cmd_selftest
      9750 selftest_full
      9793 st_core
      9906 st_buttons
      10051 st_corners
      10078 st_theme
      10252 st_icons
      10325 st_font
      10357 st_widget
      10437 st_terminal
      10466 st_newtab
      10516 st_wall
      10550 st_wallpapers
      10613 st_keys
      10657 st_panel
      10715 st_app
      10747 st_serve
      10768 st_revert
      10825 st_themes
      10867 st_look
      10943 st_tabby
      11011 codium_tail_of
      11016 st_codium
      11142 st_profile
      11217 st_refresh
      11265 st_tune
      11346 st_report
      11400 st_overview
      11437 st_presets
      11474 st_help
      11533 usage
      11596 help_settings
      11669 cmd_help
