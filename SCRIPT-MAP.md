# Карта desktop-kit.sh

Всего 11593 строк, 477 КБ, примерно 162 тыс. токенов целиком.

**Не читай файл целиком.** Найди место здесь или через `grep -n`, потом
`Read` с `offset`/`limit` на 40–80 строк и `Edit` по найденному фрагменту.

Пересобрать карту после правок: `bash tools/make-map.sh > SCRIPT-MAP.md`

## Рецепты: что где править

| Задача | Куда смотреть |
|---|---|
| Размер, цвет, подсветка кнопок заголовка | `cmd_buttons` — строка 2762, разбор ключей в начале, CSS ниже |
| Значки заголовка: откуда берутся | `install_fluent_glyphs` — строка 3078, адрес в $FLUENT_ICONS |
| Почему значков не видно | `diagnose_buttons` — строка 2631 |
| Скругление окон и меню | `cmd_corners` — строка 3613 |
| Тема окон, схема, переключение светлая/тёмная | `cmd_theme` — строка 4460 |
| Разбор имени темы на варианты | `theme_variant_of` — строка 4153, рядом theme_base_of, theme_swap_variant |
| Поиск парного варианта темы | `theme_find_variant` — строка 4235 |
| Добавить тему в банк | `theme_repo_for` — строка 3742, плюс themes_bank ниже |
| Список и установка тем банка | `cmd_themes` — строка 3853 |
| Проверка темы на совместимость с кнопками | `themes_check` — строка 3980 |
| Тема значков и цвет папок | `cmd_icons` — строка 4960 |
| Шрифты интерфейса | `cmd_font` — строка 5100 |
| Виджет conky: подложка, цвет, плотность | `cmd_widget` — строка 5402 |
| Прозрачность и палитра терминала | `cmd_terminal` — строка 5669 |
| Страница новой вкладки Chrome | `cmd_newtab` — строка 5871, разметка в heredoc ниже по функции |
| Плитки без python3 | `newtab_tiles_plain` — строка 5805 |
| Смена обоев по порядку | `cmd_wall` — строка 6888 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 6546 |
| Чистка банка обоев | `prune_wallpapers` — строка 6819 |
| Горячие клавиши | `cmd_keys` — строка 8320 |
| Панель Dash to Panel | `cmd_panel` — строка 8456 |
| Своя тема для приложения | `cmd_app` — строка 7307 |
| Прозрачность окна приложения | `app_opacity` — строка 7207, рядом opacity_install_watch — сторож |
| Настройки VSCodium, подсветка .txt | `cmd_codium` — строка 811, вставка блока — codium_settings_write |
| Локальная апка по http | `cmd_serve` — строка 7470 |
| Откат: общая логика | `cmd_revert` — строка 7903 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 7887 |
| Что показывает status | `cmd_status` — строка 7583 |
| Полный перечень изменяемого | `help_settings` — строка 11390 |
| Общий текст справки | `usage` — строка 11328 |
| Диспетчер команд (добавить новую) | ищи `случай) cmd_` в самом конце файла: `grep -n 'cmd_status "$@"' desktop-kit.sh` |
| Правила предшественника look.sh | `strip_legacy_css` — строка 2381 |
| Резервные копии и откат файлов | `backup_once` 2178, `restore_backup` 2208 |
| Блоки правил в gtk.css | `css_append` 2445, `css_strip` 2347 |
| Запомнить значение для отката | `remember` 2313 / `recall` 2329 |
| Наши текущие настройки | `state_set` 2283 / `state_get` 2298 |

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
| `buttons` | 2762 | 2579 | 9726 |
| `corners` | 3613 | 3170 | 9871 |
| `theme` | 4460 | 3688 | 9898 |
| `themes` | 3853 | 3784 | 10636 |
| `icons` | 4960 | 4898 | 10072 |
| `font` | 5100 | 5087 | 10145 |
| `widget` | 5402 | 5170 | 10177 |
| `terminal` | 5669 | 5642 | 10248 |
| `newtab` | 5871 | 5827 | 10277 |
| `wallpapers` | 6546 | 6240 | 10361 |
| `wall` | 6888 | 6863 | 10327 |
| `serve` | 7470 | 7450 | 10558 |
| `app` | 7307 | 6992 | 10526 |
| `keys` | 8320 | 8132 | 10424 |
| `panel` | 8456 | 8358 | 10468 |
| `audit` | 8578 | — | — |
| `status` | 7583 | — | — |
| `selftest` | 9184 | 8594 | — |
| `revert` | 7903 | 7678 | 10579 |

## Секции файла


## Пути и константы

    38  VERSION="1.11"
    42  VERSION_DATE="12.09.2026"
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
    535  CODIUM_SETTINGS="$HOME/.config/VSCodium/User/settings.json"
    536  CODIUM_MARK_BEGIN="// dk:codium-begin"
    537  CODIUM_MARK_END="// dk:codium-end"
    1149  PROFILE_DIR="$STATE_DIR/profiles"

## Где генерируется CSS

    2875  css_append buttons "$CSS3" "$(cat <<EOF
    2891  css_append buttons "$CSS4" "$(cat <<EOF
    2913  css_append buttons "$CSS3" "$(cat <<EOF
    2981  css_append buttons "$CSS4" "$(cat <<EOF
    3646  css_append corners "$CSS3" "$(cat <<EOF
    3664  css_append corners "$CSS4" "$(cat <<EOF

Селекторы, которые чаще всего правятся:
    2877  headerbar button.titlebutton,
    2879  button.titlebutton {
    2884  headerbar button.titlebutton image,
    2886  button.titlebutton image {
    2893  windowcontrols > button,
    2899  windowcontrols > button > image {
    2916  headerbar button.titlebutton,
    2918  button.titlebutton {
    2926  headerbar button.titlebutton image,
    2928  button.titlebutton image {
    2937  headerbar button.titlebutton:hover,
    2939  button.titlebutton:hover {
    2945  headerbar button.titlebutton:hover image,
    2946  button.titlebutton:hover image {

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
    каркас:      sandbox_new 8660, sandbox_run 8918
    утверждения: t_eq 8993, t_has 9020, t_out_has 9070, t_rc 9084
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
      539  help_codium
      575  codium_part_txt
      606  codium_part_alt
      620  codium_block
      654  codium_parts_current
      674  codium_parts_merge
      689  codium_strip_block
      703  codium_settings_write
      766  codium_desktop
      784  codium_show
      811  cmd_codium
      969  look_table
      977  look_names
      981  help_look
      1006 look_list
      1019 look_show
      1041 look_apply
      1110 cmd_look
      1154 profile_keys
      1180 profile_files
      1189 help_profile
      1220 profile_autoname
      1224 profile_list_names
      1236 profile_save
      1304 profile_load
      1401 profile_show
      1429 profile_drop
      1450 profile_list
      1473 cmd_profile
      1515 icons_bank
      1540 icons_repo_for
      1544 icons_bank_list
      1580 icons_clean
      1605 git_clone_retry
      1677 disk_room_warn
      1708 icons_copy_theme
      1723 icons_get
      1857 theme_gtk4_css
      1871 gtk4_theme_unlink
      1886 gtk4_theme_apply
      1932 presets_table
      1962 preset_args
      1970 presets_names
      1975 presets_list
      1984 preset_expand
      2020 ask_possible
      2032 ask_head
      2041 ask_num
      2078 ask_pick
      2124 ask_str
      2142 ask_yes
      2154 would
      2164 gi_get
      2165 gi_set
      2172 have
      2178 backup_once
      2208 restore_backup
      2283 state_set
      2298 state_get
      2313 remember
      2329 recall
      2347 css_strip
      2369 has_legacy_css
      2381 strip_legacy_css
      2433 icon_base_of
      2445 css_append
      2464 css_has
      2470 untangle_css
      2494 untangle_gtk4
      2498 untangle_gtk3
      2504 restart_gtk_apps
      2519 restart_conky
      2542 need_args
      2551 is_number
      2555 is_decimal
      2559 is_hex_colour
      2563 require_tools
      2579 help_buttons
      2631 diagnose_buttons
      2746 buttons_args
      2762 cmd_buttons
      3065 darken_hex
      3078 install_fluent_glyphs
      3170 help_corners
      3193 help_tune
      3213 tune_recap
      3219 cmd_tune
      3268 tune_corners
      3296 tune_buttons
      3356 tune_widget
      3422 tune_newtab
      3486 tune_terminal
      3515 tune_theme
      3528 tune_font
      3537 help_refresh
      3554 cmd_refresh
      3613 cmd_corners
      3688 help_theme
      3742 theme_repo_for
      3784 help_themes
      3827 themes_bank
      3853 cmd_themes
      3889 themes_list
      3909 themes_install
      3980 themes_check
      4040 list_themes
      4066 theme_exists
      4077 lower
      4079 theme_real_name
      4091 theme_exists_ci
      4110 theme_tokens
      4121 theme_token
      4125 theme_variant_pos
      4153 theme_variant_of
      4175 theme_rebuild
      4209 theme_base_of
      4223 theme_swap_variant
      4235 theme_find_variant
      4308 theme_light_by_sibling
      4327 theme_has_dark_sibling
      4339 theme_list_variants
      4367 theme_switch_variant
      4460 cmd_theme
      4696 install_theme_check_symlink
      4718 theme_build
      4784 theme_copy_dir
      4797 install_theme
      4898 help_icons
      4936 list_user_icon_themes
      4948 list_icon_themes
      4960 cmd_icons
      5087 help_font
      5100 cmd_font
      5170 help_widget
      5207 weather_line_path
      5211 weather_line_install
      5249 widget_modules_table
      5262 widget_add_module
      5319 widget_init
      5402 cmd_widget
      5614 conf_value
      5626 hex_brightness
      5642 help_terminal
      5660 term_profile
      5669 cmd_terminal
      5774 apply_wal_palette
      5805 newtab_tiles_plain
      5827 help_newtab
      5849 overview_newtab
      5871 cmd_newtab
      5967 rebuild_newtab
      6178 tick
      6195 find_wallpaper_dir
      6210 current_wallpaper
      6228 detect_resolution
      6240 help_wallpapers
      6274 week_themes
      6283 wallpaper_urls
      6320 wall_url_of
      6335 walls_manifest_dest
      6372 walls_publish
      6414 walls_export
      6477 walls_sync
      6546 cmd_wallpapers
      6751 install_wallpaper_timer
      6819 prune_wallpapers
      6863 help_wall
      6888 cmd_wall
      6992 help_app
      7050 opacity_to_hex
      7056 opacity_windows_of
      7062 opacity_apply_now
      7079 opacity_install_watch
      7135 opacity_remove_watch
      7147 app_windows
      7207 app_opacity
      7307 cmd_app
      7450 help_serve
      7470 cmd_serve
      7583 cmd_status
      7678 help_revert
      7714 revert_terminal
      7752 revert_panel
      7796 revert_app
      7830 revert_keys
      7866 revert_serve
      7887 revert_gi_keys
      7903 cmd_revert
      8132 help_keys
      8158 keys_list_paths
      8163 keys_show
      8187 keys_add
      8273 keys_remove
      8320 cmd_keys
      8358 help_panel
      8402 panel_float_style
      8423 panel_json_set
      8456 cmd_panel
      8578 cmd_audit
      8594 help_selftest
      8653 sb_write_stub
      8660 sandbox_new
      8891 sb_set
      8902 sb_get
      8910 sb_dconf
      8918 sandbox_run
      8944 sandbox_verify
      8968 sandbox_run_no
      8976 sandbox_drop
      8993 t_eq
      9007 t_ne
      9020 t_has
      9040 t_hasnt
      9058 t_hasnt_out
      9070 t_out_has
      9084 t_rc
      9098 t_rc_not
      9124 t_file
      9136 t_nofile
      9155 t_group
      9164 t_ok
      9166 t_fail
      9171 t_skip
      9176 t_detail
      9184 cmd_selftest
      9570 selftest_full
      9613 st_core
      9726 st_buttons
      9871 st_corners
      9898 st_theme
      10072 st_icons
      10145 st_font
      10177 st_widget
      10248 st_terminal
      10277 st_newtab
      10327 st_wall
      10361 st_wallpapers
      10424 st_keys
      10468 st_panel
      10526 st_app
      10558 st_serve
      10579 st_revert
      10636 st_themes
      10678 st_look
      10754 st_tabby
      10806 codium_tail_of
      10811 st_codium
      10937 st_profile
      11012 st_refresh
      11060 st_tune
      11141 st_report
      11195 st_overview
      11232 st_presets
      11269 st_help
      11328 usage
      11390 help_settings
      11463 cmd_help
