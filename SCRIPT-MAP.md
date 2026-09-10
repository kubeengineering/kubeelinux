# Карта desktop-kit.sh

Всего 10995 строк, 444 КБ, примерно 151 тыс. токенов целиком.

**Не читай файл целиком.** Найди место здесь или через `grep -n`, потом
`Read` с `offset`/`limit` на 40–80 строк и `Edit` по найденному фрагменту.

Пересобрать карту после правок: `bash tools/make-map.sh > SCRIPT-MAP.md`

## Рецепты: что где править

| Задача | Куда смотреть |
|---|---|
| Размер, цвет, подсветка кнопок заголовка | `cmd_buttons` — строка 2606, разбор ключей в начале, CSS ниже |
| Значки заголовка: откуда берутся | `install_fluent_glyphs` — строка 2922, адрес в $FLUENT_ICONS |
| Почему значков не видно | `diagnose_buttons` — строка 2475 |
| Скругление окон и меню | `cmd_corners` — строка 3457 |
| Тема окон, схема, переключение светлая/тёмная | `cmd_theme` — строка 4304 |
| Разбор имени темы на варианты | `theme_variant_of` — строка 3997, рядом theme_base_of, theme_swap_variant |
| Поиск парного варианта темы | `theme_find_variant` — строка 4079 |
| Добавить тему в банк | `theme_repo_for` — строка 3586, плюс themes_bank ниже |
| Список и установка тем банка | `cmd_themes` — строка 3697 |
| Проверка темы на совместимость с кнопками | `themes_check` — строка 3824 |
| Тема значков и цвет папок | `cmd_icons` — строка 4804 |
| Шрифты интерфейса | `cmd_font` — строка 4944 |
| Виджет conky: подложка, цвет, плотность | `cmd_widget` — строка 5246 |
| Прозрачность и палитра терминала | `cmd_terminal` — строка 5513 |
| Страница новой вкладки Chrome | `cmd_newtab` — строка 5715, разметка в heredoc ниже по функции |
| Плитки без python3 | `newtab_tiles_plain` — строка 5649 |
| Смена обоев по порядку | `cmd_wall` — строка 6454 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 6125 |
| Чистка банка обоев | `prune_wallpapers` — строка 6385 |
| Горячие клавиши | `cmd_keys` — строка 7877 |
| Панель Dash to Panel | `cmd_panel` — строка 7961 |
| Своя тема для приложения | `cmd_app` — строка 6873 |
| Прозрачность окна приложения | `app_opacity` — строка 6773, рядом opacity_install_watch — сторож |
| Настройки VSCodium, подсветка .txt | `cmd_codium` — строка 691, вставка блока — codium_settings_write |
| Локальная апка по http | `cmd_serve` — строка 7036 |
| Откат: общая логика | `cmd_revert` — строка 7460 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 7444 |
| Что показывает status | `cmd_status` — строка 7149 |
| Полный перечень изменяемого | `help_settings` — строка 10792 |
| Общий текст справки | `usage` — строка 10730 |
| Диспетчер команд (добавить новую) | ищи `случай) cmd_` в самом конце файла: `grep -n 'cmd_status "$@"' desktop-kit.sh` |
| Правила предшественника look.sh | `strip_legacy_css` — строка 2225 |
| Резервные копии и откат файлов | `backup_once` 2022, `restore_backup` 2052 |
| Блоки правил в gtk.css | `css_append` 2289, `css_strip` 2191 |
| Запомнить значение для отката | `remember` 2157 / `recall` 2173 |
| Наши текущие настройки | `state_set` 2127 / `state_get` 2142 |

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
| `buttons` | 2606 | 2423 | 9219 |
| `corners` | 3457 | 3014 | 9364 |
| `theme` | 4304 | 3532 | 9391 |
| `themes` | 3697 | 3628 | 10096 |
| `icons` | 4804 | 4742 | 9565 |
| `font` | 4944 | 4931 | 9638 |
| `widget` | 5246 | 5014 | 9670 |
| `terminal` | 5513 | 5486 | 9741 |
| `newtab` | 5715 | 5671 | 9770 |
| `wallpapers` | 6125 | 6084 | 9854 |
| `wall` | 6454 | 6429 | 9820 |
| `serve` | 7036 | 7016 | 10018 |
| `app` | 6873 | 6558 | 9986 |
| `keys` | 7877 | 7689 | 9896 |
| `panel` | 7961 | 7915 | 9940 |
| `audit` | 8071 | — | — |
| `status` | 7149 | — | — |
| `selftest` | 8677 | 8087 | — |
| `revert` | 7460 | 7244 | 10039 |

## Секции файла

    3  desktop-kit — единый инструмент настройки десктопа Ubuntu 24.04 / GNOME 46
    5  Одна команда на каждую подсистему, единый откат, единый лог,
    6  самопроверка прямо на рабочей машине.
    15  ЧТО ЗДЕСЬ УЧТЕНО (каждый пункт стоил отдельного круга отладки)
    148  Обзор команды: что сейчас, что можно
    270  tabby — стеклянный терминал
    505  codium — редактор VSCodium
    795  look — готовые образы рабочего стола
    980  profile — снимок оформления целиком
    1347  Банк тем значков
    1684  Тема для GTK4-приложений
    1767  Пресеты: именованные наборы параметров
    1853  Вопросы пользователю
    2420  buttons — кнопки заголовка окна
    3011  corners — скругление окон
    3034  tune — настройка вопросами
    3529  theme — тема GTK
    3618  themes — банк готовых тем
    4739  icons — тема значков и цвет папок
    4928  font — шрифт интерфейса
    5011  widget — виджет conky
    5483  terminal — GNOME Terminal
    5644  newtab — страница новой вкладки Chrome
    6036  wallpapers / wall — банк обоев и смена
    6555  app — тема отдельного приложения
    7013  serve — локальная апка по http
    7146  status — что применено
    7241  revert — откат
    7686  keys — горячие клавиши
    7912  panel — Dash to Panel
    8068  audit — снимок системы
    8084  selftest — проверка на живой машине
    8127  Каркас самопроверки: песочница с подставными внешними программами
    10727  help и диспетчер

## Пути и константы

    38  VERSION="1.4"
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
    993  PROFILE_DIR="$STATE_DIR/profiles"
    1849  PRESET_ARGS=""

## Где генерируется CSS

    2719  css_append buttons "$CSS3" "$(cat <<EOF
    2735  css_append buttons "$CSS4" "$(cat <<EOF
    2757  css_append buttons "$CSS3" "$(cat <<EOF
    2825  css_append buttons "$CSS4" "$(cat <<EOF
    3490  css_append corners "$CSS3" "$(cat <<EOF
    3508  css_append corners "$CSS4" "$(cat <<EOF

Селекторы, которые чаще всего правятся:
    2721  headerbar button.titlebutton,
    2723  button.titlebutton {
    2728  headerbar button.titlebutton image,
    2730  button.titlebutton image {
    2737  windowcontrols > button,
    2743  windowcontrols > button > image {
    2760  headerbar button.titlebutton,
    2762  button.titlebutton {
    2770  headerbar button.titlebutton image,
    2772  button.titlebutton image {
    2781  headerbar button.titlebutton:hover,
    2783  button.titlebutton:hover {
    2789  headerbar button.titlebutton:hover image,
    2790  button.titlebutton:hover image {

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
    каркас:      sandbox_new 8153, sandbox_run 8411
    утверждения: t_eq 8486, t_has 8513, t_out_has 8563, t_rc 8577
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
      557  codium_block
      584  codium_strip_block
      598  codium_settings_write
      652  codium_desktop
      670  codium_show
      691  cmd_codium
      813  look_table
      821  look_names
      825  help_look
      850  look_list
      863  look_show
      885  look_apply
      954  cmd_look
      998  profile_keys
      1024 profile_files
      1033 help_profile
      1064 profile_autoname
      1068 profile_list_names
      1080 profile_save
      1148 profile_load
      1245 profile_show
      1273 profile_drop
      1294 profile_list
      1317 cmd_profile
      1359 icons_bank
      1384 icons_repo_for
      1388 icons_bank_list
      1424 icons_clean
      1449 git_clone_retry
      1521 disk_room_warn
      1552 icons_copy_theme
      1567 icons_get
      1701 theme_gtk4_css
      1715 gtk4_theme_unlink
      1730 gtk4_theme_apply
      1776 presets_table
      1806 preset_args
      1814 presets_names
      1819 presets_list
      1828 preset_expand
      1864 ask_possible
      1876 ask_head
      1885 ask_num
      1922 ask_pick
      1968 ask_str
      1986 ask_yes
      1998 would
      2008 gi_get
      2009 gi_set
      2016 have
      2022 backup_once
      2052 restore_backup
      2127 state_set
      2142 state_get
      2157 remember
      2173 recall
      2191 css_strip
      2213 has_legacy_css
      2225 strip_legacy_css
      2277 icon_base_of
      2289 css_append
      2308 css_has
      2314 untangle_css
      2338 untangle_gtk4
      2342 untangle_gtk3
      2348 restart_gtk_apps
      2363 restart_conky
      2386 need_args
      2395 is_number
      2399 is_decimal
      2403 is_hex_colour
      2407 require_tools
      2423 help_buttons
      2475 diagnose_buttons
      2590 buttons_args
      2606 cmd_buttons
      2909 darken_hex
      2922 install_fluent_glyphs
      3014 help_corners
      3037 help_tune
      3057 tune_recap
      3063 cmd_tune
      3112 tune_corners
      3140 tune_buttons
      3200 tune_widget
      3266 tune_newtab
      3330 tune_terminal
      3359 tune_theme
      3372 tune_font
      3381 help_refresh
      3398 cmd_refresh
      3457 cmd_corners
      3532 help_theme
      3586 theme_repo_for
      3628 help_themes
      3671 themes_bank
      3697 cmd_themes
      3733 themes_list
      3753 themes_install
      3824 themes_check
      3884 list_themes
      3910 theme_exists
      3921 lower
      3923 theme_real_name
      3935 theme_exists_ci
      3954 theme_tokens
      3965 theme_token
      3969 theme_variant_pos
      3997 theme_variant_of
      4019 theme_rebuild
      4053 theme_base_of
      4067 theme_swap_variant
      4079 theme_find_variant
      4152 theme_light_by_sibling
      4171 theme_has_dark_sibling
      4183 theme_list_variants
      4211 theme_switch_variant
      4304 cmd_theme
      4540 install_theme_check_symlink
      4562 theme_build
      4628 theme_copy_dir
      4641 install_theme
      4742 help_icons
      4780 list_user_icon_themes
      4792 list_icon_themes
      4804 cmd_icons
      4931 help_font
      4944 cmd_font
      5014 help_widget
      5051 weather_line_path
      5055 weather_line_install
      5093 widget_modules_table
      5106 widget_add_module
      5163 widget_init
      5246 cmd_widget
      5458 conf_value
      5470 hex_brightness
      5486 help_terminal
      5504 term_profile
      5513 cmd_terminal
      5618 apply_wal_palette
      5649 newtab_tiles_plain
      5671 help_newtab
      5693 overview_newtab
      5715 cmd_newtab
      5811 rebuild_newtab
      6022 tick
      6039 find_wallpaper_dir
      6054 current_wallpaper
      6072 detect_resolution
      6084 help_wallpapers
      6107 week_themes
      6116 wallpaper_urls
      6125 cmd_wallpapers
      6317 install_wallpaper_timer
      6385 prune_wallpapers
      6429 help_wall
      6454 cmd_wall
      6558 help_app
      6616 opacity_to_hex
      6622 opacity_windows_of
      6628 opacity_apply_now
      6645 opacity_install_watch
      6701 opacity_remove_watch
      6713 app_windows
      6773 app_opacity
      6873 cmd_app
      7016 help_serve
      7036 cmd_serve
      7149 cmd_status
      7244 help_revert
      7280 revert_terminal
      7318 revert_panel
      7353 revert_app
      7387 revert_keys
      7423 revert_serve
      7444 revert_gi_keys
      7460 cmd_revert
      7689 help_keys
      7715 keys_list_paths
      7720 keys_show
      7744 keys_add
      7830 keys_remove
      7877 cmd_keys
      7915 help_panel
      7944 panel_json_set
      7961 cmd_panel
      8071 cmd_audit
      8087 help_selftest
      8146 sb_write_stub
      8153 sandbox_new
      8384 sb_set
      8395 sb_get
      8403 sb_dconf
      8411 sandbox_run
      8437 sandbox_verify
      8461 sandbox_run_no
      8469 sandbox_drop
      8486 t_eq
      8500 t_ne
      8513 t_has
      8533 t_hasnt
      8551 t_hasnt_out
      8563 t_out_has
      8577 t_rc
      8591 t_rc_not
      8617 t_file
      8629 t_nofile
      8648 t_group
      8657 t_ok
      8659 t_fail
      8664 t_skip
      8669 t_detail
      8677 cmd_selftest
      9063 selftest_full
      9106 st_core
      9219 st_buttons
      9364 st_corners
      9391 st_theme
      9565 st_icons
      9638 st_font
      9670 st_widget
      9741 st_terminal
      9770 st_newtab
      9820 st_wall
      9854 st_wallpapers
      9896 st_keys
      9940 st_panel
      9986 st_app
      10018 st_serve
      10039 st_revert
      10096 st_themes
      10138 st_look
      10214 st_tabby
      10266 codium_tail_of
      10271 st_codium
      10339 st_profile
      10414 st_refresh
      10462 st_tune
      10543 st_report
      10597 st_overview
      10634 st_presets
      10671 st_help
      10730 usage
      10792 help_settings
      10865 cmd_help
