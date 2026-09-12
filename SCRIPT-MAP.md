# Карта desktop-kit.sh

Всего 11403 строк, 465 КБ, примерно 158 тыс. токенов целиком.

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
| Смена обоев по порядку | `cmd_wall` — строка 6783 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 6441 |
| Чистка банка обоев | `prune_wallpapers` — строка 6714 |
| Горячие клавиши | `cmd_keys` — строка 8206 |
| Панель Dash to Panel | `cmd_panel` — строка 8290 |
| Своя тема для приложения | `cmd_app` — строка 7202 |
| Прозрачность окна приложения | `app_opacity` — строка 7102, рядом opacity_install_watch — сторож |
| Настройки VSCodium, подсветка .txt | `cmd_codium` — строка 811, вставка блока — codium_settings_write |
| Локальная апка по http | `cmd_serve` — строка 7365 |
| Откат: общая логика | `cmd_revert` — строка 7789 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 7773 |
| Что показывает status | `cmd_status` — строка 7478 |
| Полный перечень изменяемого | `help_settings` — строка 11200 |
| Общий текст справки | `usage` — строка 11138 |
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
| `buttons` | 2762 | 2579 | 9548 |
| `corners` | 3613 | 3170 | 9693 |
| `theme` | 4460 | 3688 | 9720 |
| `themes` | 3853 | 3784 | 10446 |
| `icons` | 4960 | 4898 | 9894 |
| `font` | 5100 | 5087 | 9967 |
| `widget` | 5402 | 5170 | 9999 |
| `terminal` | 5669 | 5642 | 10070 |
| `newtab` | 5871 | 5827 | 10099 |
| `wallpapers` | 6441 | 6240 | 10183 |
| `wall` | 6783 | 6758 | 10149 |
| `serve` | 7365 | 7345 | 10368 |
| `app` | 7202 | 6887 | 10336 |
| `keys` | 8206 | 8018 | 10246 |
| `panel` | 8290 | 8244 | 10290 |
| `audit` | 8400 | — | — |
| `status` | 7478 | — | — |
| `selftest` | 9006 | 8416 | — |
| `revert` | 7789 | 7573 | 10389 |

## Секции файла

    3  desktop-kit — единый инструмент настройки десктопа Ubuntu 24.04 / GNOME 46
    5  Одна команда на каждую подсистему, единый откат, единый лог,
    6  самопроверка прямо на рабочей машине.
    15  ЧТО ЗДЕСЬ УЧТЕНО (каждый пункт стоил отдельного круга отладки)
    149  Обзор команды: что сейчас, что можно
    271  tabby — стеклянный терминал
    506  codium — редактор VSCodium
    951  look — готовые образы рабочего стола
    1136  profile — снимок оформления целиком
    1503  Банк тем значков
    1840  Тема для GTK4-приложений
    1923  Пресеты: именованные наборы параметров
    2009  Вопросы пользователю
    2576  buttons — кнопки заголовка окна
    3167  corners — скругление окон
    3190  tune — настройка вопросами
    3685  theme — тема GTK
    3774  themes — банк готовых тем
    4895  icons — тема значков и цвет папок
    5084  font — шрифт интерфейса
    5167  widget — виджет conky
    5639  terminal — GNOME Terminal
    5800  newtab — страница новой вкладки Chrome
    6192  wallpapers / wall — банк обоев и смена
    6293  Список банка: одинаковые обои на всех машинах
    6884  app — тема отдельного приложения
    7342  serve — локальная апка по http
    7475  status — что применено
    7570  revert — откат
    8015  keys — горячие клавиши
    8241  panel — Dash to Panel
    8397  audit — снимок системы
    8413  selftest — проверка на живой машине
    8456  Каркас самопроверки: песочница с подставными внешними программами
    11135  help и диспетчер

## Пути и константы

    38  VERSION="1.8"
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
    каркас:      sandbox_new 8482, sandbox_run 8740
    утверждения: t_eq 8815, t_has 8842, t_out_has 8892, t_rc 8906
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
      6331 walls_export
      6372 walls_sync
      6441 cmd_wallpapers
      6646 install_wallpaper_timer
      6714 prune_wallpapers
      6758 help_wall
      6783 cmd_wall
      6887 help_app
      6945 opacity_to_hex
      6951 opacity_windows_of
      6957 opacity_apply_now
      6974 opacity_install_watch
      7030 opacity_remove_watch
      7042 app_windows
      7102 app_opacity
      7202 cmd_app
      7345 help_serve
      7365 cmd_serve
      7478 cmd_status
      7573 help_revert
      7609 revert_terminal
      7647 revert_panel
      7682 revert_app
      7716 revert_keys
      7752 revert_serve
      7773 revert_gi_keys
      7789 cmd_revert
      8018 help_keys
      8044 keys_list_paths
      8049 keys_show
      8073 keys_add
      8159 keys_remove
      8206 cmd_keys
      8244 help_panel
      8273 panel_json_set
      8290 cmd_panel
      8400 cmd_audit
      8416 help_selftest
      8475 sb_write_stub
      8482 sandbox_new
      8713 sb_set
      8724 sb_get
      8732 sb_dconf
      8740 sandbox_run
      8766 sandbox_verify
      8790 sandbox_run_no
      8798 sandbox_drop
      8815 t_eq
      8829 t_ne
      8842 t_has
      8862 t_hasnt
      8880 t_hasnt_out
      8892 t_out_has
      8906 t_rc
      8920 t_rc_not
      8946 t_file
      8958 t_nofile
      8977 t_group
      8986 t_ok
      8988 t_fail
      8993 t_skip
      8998 t_detail
      9006 cmd_selftest
      9392 selftest_full
      9435 st_core
      9548 st_buttons
      9693 st_corners
      9720 st_theme
      9894 st_icons
      9967 st_font
      9999 st_widget
      10070 st_terminal
      10099 st_newtab
      10149 st_wall
      10183 st_wallpapers
      10246 st_keys
      10290 st_panel
      10336 st_app
      10368 st_serve
      10389 st_revert
      10446 st_themes
      10488 st_look
      10564 st_tabby
      10616 codium_tail_of
      10621 st_codium
      10747 st_profile
      10822 st_refresh
      10870 st_tune
      10951 st_report
      11005 st_overview
      11042 st_presets
      11079 st_help
      11138 usage
      11200 help_settings
      11273 cmd_help
