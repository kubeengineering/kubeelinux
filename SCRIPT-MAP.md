# Карта desktop-kit.sh

Всего 11643 строк, 481 КБ, примерно 164 тыс. токенов целиком.

**Не читай файл целиком.** Найди место здесь или через `grep -n`, потом
`Read` с `offset`/`limit` на 40–80 строк и `Edit` по найденному фрагменту.

Пересобрать карту после правок: `bash tools/make-map.sh > SCRIPT-MAP.md`

## Рецепты: что где править

| Задача | Куда смотреть |
|---|---|
| Размер, цвет, подсветка кнопок заголовка | `cmd_buttons` — строка 2763, разбор ключей в начале, CSS ниже |
| Значки заголовка: откуда берутся | `install_fluent_glyphs` — строка 3079, адрес в $FLUENT_ICONS |
| Почему значков не видно | `diagnose_buttons` — строка 2632 |
| Скругление окон и меню | `cmd_corners` — строка 3614 |
| Тема окон, схема, переключение светлая/тёмная | `cmd_theme` — строка 4461 |
| Разбор имени темы на варианты | `theme_variant_of` — строка 4154, рядом theme_base_of, theme_swap_variant |
| Поиск парного варианта темы | `theme_find_variant` — строка 4236 |
| Добавить тему в банк | `theme_repo_for` — строка 3743, плюс themes_bank ниже |
| Список и установка тем банка | `cmd_themes` — строка 3854 |
| Проверка темы на совместимость с кнопками | `themes_check` — строка 3981 |
| Тема значков и цвет папок | `cmd_icons` — строка 4961 |
| Шрифты интерфейса | `cmd_font` — строка 5101 |
| Виджет conky: подложка, цвет, плотность | `cmd_widget` — строка 5417 |
| Прозрачность и палитра терминала | `cmd_terminal` — строка 5703 |
| Страница новой вкладки Chrome | `cmd_newtab` — строка 5911, разметка в heredoc ниже по функции |
| Плитки без python3 | `newtab_tiles_plain` — строка 5845 |
| Смена обоев по порядку | `cmd_wall` — строка 6928 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 6586 |
| Чистка банка обоев | `prune_wallpapers` — строка 6859 |
| Горячие клавиши | `cmd_keys` — строка 8360 |
| Панель Dash to Panel | `cmd_panel` — строка 8496 |
| Своя тема для приложения | `cmd_app` — строка 7347 |
| Прозрачность окна приложения | `app_opacity` — строка 7247, рядом opacity_install_watch — сторож |
| Настройки VSCodium, подсветка .txt | `cmd_codium` — строка 811, вставка блока — codium_settings_write |
| Локальная апка по http | `cmd_serve` — строка 7510 |
| Откат: общая логика | `cmd_revert` — строка 7943 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 7927 |
| Что показывает status | `cmd_status` — строка 7623 |
| Полный перечень изменяемого | `help_settings` — строка 11440 |
| Общий текст справки | `usage` — строка 11377 |
| Диспетчер команд (добавить новую) | ищи `случай) cmd_` в самом конце файла: `grep -n 'cmd_status "$@"' desktop-kit.sh` |
| Правила предшественника look.sh | `strip_legacy_css` — строка 2382 |
| Резервные копии и откат файлов | `backup_once` 2179, `restore_backup` 2209 |
| Блоки правил в gtk.css | `css_append` 2446, `css_strip` 2348 |
| Запомнить значение для отката | `remember` 2314 / `recall` 2330 |
| Наши текущие настройки | `state_set` 2284 / `state_get` 2299 |

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
| `buttons` | 2763 | 2580 | 9766 |
| `corners` | 3614 | 3171 | 9911 |
| `theme` | 4461 | 3689 | 9938 |
| `themes` | 3854 | 3785 | 10685 |
| `icons` | 4961 | 4899 | 10112 |
| `font` | 5101 | 5088 | 10185 |
| `widget` | 5417 | 5185 | 10217 |
| `terminal` | 5703 | 5676 | 10297 |
| `newtab` | 5911 | 5867 | 10326 |
| `wallpapers` | 6586 | 6280 | 10410 |
| `wall` | 6928 | 6903 | 10376 |
| `serve` | 7510 | 7490 | 10607 |
| `app` | 7347 | 7032 | 10575 |
| `keys` | 8360 | 8172 | 10473 |
| `panel` | 8496 | 8398 | 10517 |
| `audit` | 8618 | — | — |
| `status` | 7623 | — | — |
| `selftest` | 9224 | 8634 | — |
| `revert` | 7943 | 7718 | 10628 |

## Секции файла


## Пути и константы

    38  VERSION="1.13"
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
    535  CODIUM_SETTINGS="$HOME/.config/VSCodium/User/settings.json"
    536  CODIUM_MARK_BEGIN="// dk:codium-begin"
    537  CODIUM_MARK_END="// dk:codium-end"
    1150  PROFILE_DIR="$STATE_DIR/profiles"

## Где генерируется CSS

    2876  css_append buttons "$CSS3" "$(cat <<EOF
    2892  css_append buttons "$CSS4" "$(cat <<EOF
    2914  css_append buttons "$CSS3" "$(cat <<EOF
    2982  css_append buttons "$CSS4" "$(cat <<EOF
    3647  css_append corners "$CSS3" "$(cat <<EOF
    3665  css_append corners "$CSS4" "$(cat <<EOF

Селекторы, которые чаще всего правятся:
    2878  headerbar button.titlebutton,
    2880  button.titlebutton {
    2885  headerbar button.titlebutton image,
    2887  button.titlebutton image {
    2894  windowcontrols > button,
    2900  windowcontrols > button > image {
    2917  headerbar button.titlebutton,
    2919  button.titlebutton {
    2927  headerbar button.titlebutton image,
    2929  button.titlebutton image {
    2938  headerbar button.titlebutton:hover,
    2940  button.titlebutton:hover {
    2946  headerbar button.titlebutton:hover image,
    2947  button.titlebutton:hover image {

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
    каркас:      sandbox_new 8700, sandbox_run 8958
    утверждения: t_eq 9033, t_has 9060, t_out_has 9110, t_rc 9124
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
      978  look_names
      982  help_look
      1007 look_list
      1020 look_show
      1042 look_apply
      1111 cmd_look
      1155 profile_keys
      1181 profile_files
      1190 help_profile
      1221 profile_autoname
      1225 profile_list_names
      1237 profile_save
      1305 profile_load
      1402 profile_show
      1430 profile_drop
      1451 profile_list
      1474 cmd_profile
      1516 icons_bank
      1541 icons_repo_for
      1545 icons_bank_list
      1581 icons_clean
      1606 git_clone_retry
      1678 disk_room_warn
      1709 icons_copy_theme
      1724 icons_get
      1858 theme_gtk4_css
      1872 gtk4_theme_unlink
      1887 gtk4_theme_apply
      1933 presets_table
      1963 preset_args
      1971 presets_names
      1976 presets_list
      1985 preset_expand
      2021 ask_possible
      2033 ask_head
      2042 ask_num
      2079 ask_pick
      2125 ask_str
      2143 ask_yes
      2155 would
      2165 gi_get
      2166 gi_set
      2173 have
      2179 backup_once
      2209 restore_backup
      2284 state_set
      2299 state_get
      2314 remember
      2330 recall
      2348 css_strip
      2370 has_legacy_css
      2382 strip_legacy_css
      2434 icon_base_of
      2446 css_append
      2465 css_has
      2471 untangle_css
      2495 untangle_gtk4
      2499 untangle_gtk3
      2505 restart_gtk_apps
      2520 restart_conky
      2543 need_args
      2552 is_number
      2556 is_decimal
      2560 is_hex_colour
      2564 require_tools
      2580 help_buttons
      2632 diagnose_buttons
      2747 buttons_args
      2763 cmd_buttons
      3066 darken_hex
      3079 install_fluent_glyphs
      3171 help_corners
      3194 help_tune
      3214 tune_recap
      3220 cmd_tune
      3269 tune_corners
      3297 tune_buttons
      3357 tune_widget
      3423 tune_newtab
      3487 tune_terminal
      3516 tune_theme
      3529 tune_font
      3538 help_refresh
      3555 cmd_refresh
      3614 cmd_corners
      3689 help_theme
      3743 theme_repo_for
      3785 help_themes
      3828 themes_bank
      3854 cmd_themes
      3890 themes_list
      3910 themes_install
      3981 themes_check
      4041 list_themes
      4067 theme_exists
      4078 lower
      4080 theme_real_name
      4092 theme_exists_ci
      4111 theme_tokens
      4122 theme_token
      4126 theme_variant_pos
      4154 theme_variant_of
      4176 theme_rebuild
      4210 theme_base_of
      4224 theme_swap_variant
      4236 theme_find_variant
      4309 theme_light_by_sibling
      4328 theme_has_dark_sibling
      4340 theme_list_variants
      4368 theme_switch_variant
      4461 cmd_theme
      4697 install_theme_check_symlink
      4719 theme_build
      4785 theme_copy_dir
      4798 install_theme
      4899 help_icons
      4937 list_user_icon_themes
      4949 list_icon_themes
      4961 cmd_icons
      5088 help_font
      5101 cmd_font
      5185 help_widget
      5222 weather_line_path
      5226 weather_line_install
      5264 widget_modules_table
      5277 widget_add_module
      5334 widget_init
      5417 cmd_widget
      5643 conf_value
      5660 hex_brightness
      5676 help_terminal
      5694 term_profile
      5703 cmd_terminal
      5814 apply_wal_palette
      5845 newtab_tiles_plain
      5867 help_newtab
      5889 overview_newtab
      5911 cmd_newtab
      6007 rebuild_newtab
      6218 tick
      6235 find_wallpaper_dir
      6250 current_wallpaper
      6268 detect_resolution
      6280 help_wallpapers
      6314 week_themes
      6323 wallpaper_urls
      6360 wall_url_of
      6375 walls_manifest_dest
      6412 walls_publish
      6454 walls_export
      6517 walls_sync
      6586 cmd_wallpapers
      6791 install_wallpaper_timer
      6859 prune_wallpapers
      6903 help_wall
      6928 cmd_wall
      7032 help_app
      7090 opacity_to_hex
      7096 opacity_windows_of
      7102 opacity_apply_now
      7119 opacity_install_watch
      7175 opacity_remove_watch
      7187 app_windows
      7247 app_opacity
      7347 cmd_app
      7490 help_serve
      7510 cmd_serve
      7623 cmd_status
      7718 help_revert
      7754 revert_terminal
      7792 revert_panel
      7836 revert_app
      7870 revert_keys
      7906 revert_serve
      7927 revert_gi_keys
      7943 cmd_revert
      8172 help_keys
      8198 keys_list_paths
      8203 keys_show
      8227 keys_add
      8313 keys_remove
      8360 cmd_keys
      8398 help_panel
      8442 panel_float_style
      8463 panel_json_set
      8496 cmd_panel
      8618 cmd_audit
      8634 help_selftest
      8693 sb_write_stub
      8700 sandbox_new
      8931 sb_set
      8942 sb_get
      8950 sb_dconf
      8958 sandbox_run
      8984 sandbox_verify
      9008 sandbox_run_no
      9016 sandbox_drop
      9033 t_eq
      9047 t_ne
      9060 t_has
      9080 t_hasnt
      9098 t_hasnt_out
      9110 t_out_has
      9124 t_rc
      9138 t_rc_not
      9164 t_file
      9176 t_nofile
      9195 t_group
      9204 t_ok
      9206 t_fail
      9211 t_skip
      9216 t_detail
      9224 cmd_selftest
      9610 selftest_full
      9653 st_core
      9766 st_buttons
      9911 st_corners
      9938 st_theme
      10112 st_icons
      10185 st_font
      10217 st_widget
      10297 st_terminal
      10326 st_newtab
      10376 st_wall
      10410 st_wallpapers
      10473 st_keys
      10517 st_panel
      10575 st_app
      10607 st_serve
      10628 st_revert
      10685 st_themes
      10727 st_look
      10803 st_tabby
      10855 codium_tail_of
      10860 st_codium
      10986 st_profile
      11061 st_refresh
      11109 st_tune
      11190 st_report
      11244 st_overview
      11281 st_presets
      11318 st_help
      11377 usage
      11440 help_settings
      11513 cmd_help
