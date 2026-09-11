# Карта desktop-kit.sh

Всего 11173 строк, 455 КБ, примерно 155 тыс. токенов целиком.

**Не читай файл целиком.** Найди место здесь или через `grep -n`, потом
`Read` с `offset`/`limit` на 40–80 строк и `Edit` по найденному фрагменту.

Пересобрать карту после правок: `bash tools/make-map.sh > SCRIPT-MAP.md`

## Рецепты: что где править

| Задача | Куда смотреть |
|---|---|
| Размер, цвет, подсветка кнопок заголовка | `cmd_buttons` — строка 2737, разбор ключей в начале, CSS ниже |
| Значки заголовка: откуда берутся | `install_fluent_glyphs` — строка 3053, адрес в $FLUENT_ICONS |
| Почему значков не видно | `diagnose_buttons` — строка 2606 |
| Скругление окон и меню | `cmd_corners` — строка 3588 |
| Тема окон, схема, переключение светлая/тёмная | `cmd_theme` — строка 4435 |
| Разбор имени темы на варианты | `theme_variant_of` — строка 4128, рядом theme_base_of, theme_swap_variant |
| Поиск парного варианта темы | `theme_find_variant` — строка 4210 |
| Добавить тему в банк | `theme_repo_for` — строка 3717, плюс themes_bank ниже |
| Список и установка тем банка | `cmd_themes` — строка 3828 |
| Проверка темы на совместимость с кнопками | `themes_check` — строка 3955 |
| Тема значков и цвет папок | `cmd_icons` — строка 4935 |
| Шрифты интерфейса | `cmd_font` — строка 5075 |
| Виджет conky: подложка, цвет, плотность | `cmd_widget` — строка 5377 |
| Прозрачность и палитра терминала | `cmd_terminal` — строка 5644 |
| Страница новой вкладки Chrome | `cmd_newtab` — строка 5846, разметка в heredoc ниже по функции |
| Плитки без python3 | `newtab_tiles_plain` — строка 5780 |
| Смена обоев по порядку | `cmd_wall` — строка 6585 |
| Докачка обоев и расписание | `cmd_wallpapers` — строка 6256 |
| Чистка банка обоев | `prune_wallpapers` — строка 6516 |
| Горячие клавиши | `cmd_keys` — строка 8008 |
| Панель Dash to Panel | `cmd_panel` — строка 8092 |
| Своя тема для приложения | `cmd_app` — строка 7004 |
| Прозрачность окна приложения | `app_opacity` — строка 6904, рядом opacity_install_watch — сторож |
| Настройки VSCodium, подсветка .txt | `cmd_codium` — строка 786, вставка блока — codium_settings_write |
| Локальная апка по http | `cmd_serve` — строка 7167 |
| Откат: общая логика | `cmd_revert` — строка 7591 |
| Откат конкретных ключей GNOME | `revert_gi_keys` — строка 7575 |
| Что показывает status | `cmd_status` — строка 7280 |
| Полный перечень изменяемого | `help_settings` — строка 10970 |
| Общий текст справки | `usage` — строка 10908 |
| Диспетчер команд (добавить новую) | ищи `случай) cmd_` в самом конце файла: `grep -n 'cmd_status "$@"' desktop-kit.sh` |
| Правила предшественника look.sh | `strip_legacy_css` — строка 2356 |
| Резервные копии и откат файлов | `backup_once` 2153, `restore_backup` 2183 |
| Блоки правил в gtk.css | `css_append` 2420, `css_strip` 2322 |
| Запомнить значение для отката | `remember` 2288 / `recall` 2304 |
| Наши текущие настройки | `state_set` 2258 / `state_get` 2273 |

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
| `buttons` | 2737 | 2554 | 9350 |
| `corners` | 3588 | 3145 | 9495 |
| `theme` | 4435 | 3663 | 9522 |
| `themes` | 3828 | 3759 | 10227 |
| `icons` | 4935 | 4873 | 9696 |
| `font` | 5075 | 5062 | 9769 |
| `widget` | 5377 | 5145 | 9801 |
| `terminal` | 5644 | 5617 | 9872 |
| `newtab` | 5846 | 5802 | 9901 |
| `wallpapers` | 6256 | 6215 | 9985 |
| `wall` | 6585 | 6560 | 9951 |
| `serve` | 7167 | 7147 | 10149 |
| `app` | 7004 | 6689 | 10117 |
| `keys` | 8008 | 7820 | 10027 |
| `panel` | 8092 | 8046 | 10071 |
| `audit` | 8202 | — | — |
| `status` | 7280 | — | — |
| `selftest` | 8808 | 8218 | — |
| `revert` | 7591 | 7375 | 10170 |

## Секции файла

    3  desktop-kit — единый инструмент настройки десктопа Ubuntu 24.04 / GNOME 46
    5  Одна команда на каждую подсистему, единый откат, единый лог,
    6  самопроверка прямо на рабочей машине.
    15  ЧТО ЗДЕСЬ УЧТЕНО (каждый пункт стоил отдельного круга отладки)
    148  Обзор команды: что сейчас, что можно
    270  tabby — стеклянный терминал
    505  codium — редактор VSCodium
    926  look — готовые образы рабочего стола
    1111  profile — снимок оформления целиком
    1478  Банк тем значков
    1815  Тема для GTK4-приложений
    1898  Пресеты: именованные наборы параметров
    1984  Вопросы пользователю
    2551  buttons — кнопки заголовка окна
    3142  corners — скругление окон
    3165  tune — настройка вопросами
    3660  theme — тема GTK
    3749  themes — банк готовых тем
    4870  icons — тема значков и цвет папок
    5059  font — шрифт интерфейса
    5142  widget — виджет conky
    5614  terminal — GNOME Terminal
    5775  newtab — страница новой вкладки Chrome
    6167  wallpapers / wall — банк обоев и смена
    6686  app — тема отдельного приложения
    7144  serve — локальная апка по http
    7277  status — что применено
    7372  revert — откат
    7817  keys — горячие клавиши
    8043  panel — Dash to Panel
    8199  audit — снимок системы
    8215  selftest — проверка на живой машине
    8258  Каркас самопроверки: песочница с подставными внешними программами
    10905  help и диспетчер

## Пути и константы

    38  VERSION="1.6"
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
    534  CODIUM_SETTINGS="$HOME/.config/VSCodium/User/settings.json"
    535  CODIUM_MARK_BEGIN="// dk:codium-begin"
    536  CODIUM_MARK_END="// dk:codium-end"
    1124  PROFILE_DIR="$STATE_DIR/profiles"
    1980  PRESET_ARGS=""

## Где генерируется CSS

    2850  css_append buttons "$CSS3" "$(cat <<EOF
    2866  css_append buttons "$CSS4" "$(cat <<EOF
    2888  css_append buttons "$CSS3" "$(cat <<EOF
    2956  css_append buttons "$CSS4" "$(cat <<EOF
    3621  css_append corners "$CSS3" "$(cat <<EOF
    3639  css_append corners "$CSS4" "$(cat <<EOF

Селекторы, которые чаще всего правятся:
    2852  headerbar button.titlebutton,
    2854  button.titlebutton {
    2859  headerbar button.titlebutton image,
    2861  button.titlebutton image {
    2868  windowcontrols > button,
    2874  windowcontrols > button > image {
    2891  headerbar button.titlebutton,
    2893  button.titlebutton {
    2901  headerbar button.titlebutton image,
    2903  button.titlebutton image {
    2912  headerbar button.titlebutton:hover,
    2914  button.titlebutton:hover {
    2920  headerbar button.titlebutton:hover image,
    2921  button.titlebutton:hover image {

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
    каркас:      sandbox_new 8284, sandbox_run 8542
    утверждения: t_eq 8617, t_has 8644, t_out_has 8694, t_rc 8708
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
      649  codium_parts_merge
      664  codium_strip_block
      678  codium_settings_write
      741  codium_desktop
      759  codium_show
      786  cmd_codium
      944  look_table
      952  look_names
      956  help_look
      981  look_list
      994  look_show
      1016 look_apply
      1085 cmd_look
      1129 profile_keys
      1155 profile_files
      1164 help_profile
      1195 profile_autoname
      1199 profile_list_names
      1211 profile_save
      1279 profile_load
      1376 profile_show
      1404 profile_drop
      1425 profile_list
      1448 cmd_profile
      1490 icons_bank
      1515 icons_repo_for
      1519 icons_bank_list
      1555 icons_clean
      1580 git_clone_retry
      1652 disk_room_warn
      1683 icons_copy_theme
      1698 icons_get
      1832 theme_gtk4_css
      1846 gtk4_theme_unlink
      1861 gtk4_theme_apply
      1907 presets_table
      1937 preset_args
      1945 presets_names
      1950 presets_list
      1959 preset_expand
      1995 ask_possible
      2007 ask_head
      2016 ask_num
      2053 ask_pick
      2099 ask_str
      2117 ask_yes
      2129 would
      2139 gi_get
      2140 gi_set
      2147 have
      2153 backup_once
      2183 restore_backup
      2258 state_set
      2273 state_get
      2288 remember
      2304 recall
      2322 css_strip
      2344 has_legacy_css
      2356 strip_legacy_css
      2408 icon_base_of
      2420 css_append
      2439 css_has
      2445 untangle_css
      2469 untangle_gtk4
      2473 untangle_gtk3
      2479 restart_gtk_apps
      2494 restart_conky
      2517 need_args
      2526 is_number
      2530 is_decimal
      2534 is_hex_colour
      2538 require_tools
      2554 help_buttons
      2606 diagnose_buttons
      2721 buttons_args
      2737 cmd_buttons
      3040 darken_hex
      3053 install_fluent_glyphs
      3145 help_corners
      3168 help_tune
      3188 tune_recap
      3194 cmd_tune
      3243 tune_corners
      3271 tune_buttons
      3331 tune_widget
      3397 tune_newtab
      3461 tune_terminal
      3490 tune_theme
      3503 tune_font
      3512 help_refresh
      3529 cmd_refresh
      3588 cmd_corners
      3663 help_theme
      3717 theme_repo_for
      3759 help_themes
      3802 themes_bank
      3828 cmd_themes
      3864 themes_list
      3884 themes_install
      3955 themes_check
      4015 list_themes
      4041 theme_exists
      4052 lower
      4054 theme_real_name
      4066 theme_exists_ci
      4085 theme_tokens
      4096 theme_token
      4100 theme_variant_pos
      4128 theme_variant_of
      4150 theme_rebuild
      4184 theme_base_of
      4198 theme_swap_variant
      4210 theme_find_variant
      4283 theme_light_by_sibling
      4302 theme_has_dark_sibling
      4314 theme_list_variants
      4342 theme_switch_variant
      4435 cmd_theme
      4671 install_theme_check_symlink
      4693 theme_build
      4759 theme_copy_dir
      4772 install_theme
      4873 help_icons
      4911 list_user_icon_themes
      4923 list_icon_themes
      4935 cmd_icons
      5062 help_font
      5075 cmd_font
      5145 help_widget
      5182 weather_line_path
      5186 weather_line_install
      5224 widget_modules_table
      5237 widget_add_module
      5294 widget_init
      5377 cmd_widget
      5589 conf_value
      5601 hex_brightness
      5617 help_terminal
      5635 term_profile
      5644 cmd_terminal
      5749 apply_wal_palette
      5780 newtab_tiles_plain
      5802 help_newtab
      5824 overview_newtab
      5846 cmd_newtab
      5942 rebuild_newtab
      6153 tick
      6170 find_wallpaper_dir
      6185 current_wallpaper
      6203 detect_resolution
      6215 help_wallpapers
      6238 week_themes
      6247 wallpaper_urls
      6256 cmd_wallpapers
      6448 install_wallpaper_timer
      6516 prune_wallpapers
      6560 help_wall
      6585 cmd_wall
      6689 help_app
      6747 opacity_to_hex
      6753 opacity_windows_of
      6759 opacity_apply_now
      6776 opacity_install_watch
      6832 opacity_remove_watch
      6844 app_windows
      6904 app_opacity
      7004 cmd_app
      7147 help_serve
      7167 cmd_serve
      7280 cmd_status
      7375 help_revert
      7411 revert_terminal
      7449 revert_panel
      7484 revert_app
      7518 revert_keys
      7554 revert_serve
      7575 revert_gi_keys
      7591 cmd_revert
      7820 help_keys
      7846 keys_list_paths
      7851 keys_show
      7875 keys_add
      7961 keys_remove
      8008 cmd_keys
      8046 help_panel
      8075 panel_json_set
      8092 cmd_panel
      8202 cmd_audit
      8218 help_selftest
      8277 sb_write_stub
      8284 sandbox_new
      8515 sb_set
      8526 sb_get
      8534 sb_dconf
      8542 sandbox_run
      8568 sandbox_verify
      8592 sandbox_run_no
      8600 sandbox_drop
      8617 t_eq
      8631 t_ne
      8644 t_has
      8664 t_hasnt
      8682 t_hasnt_out
      8694 t_out_has
      8708 t_rc
      8722 t_rc_not
      8748 t_file
      8760 t_nofile
      8779 t_group
      8788 t_ok
      8790 t_fail
      8795 t_skip
      8800 t_detail
      8808 cmd_selftest
      9194 selftest_full
      9237 st_core
      9350 st_buttons
      9495 st_corners
      9522 st_theme
      9696 st_icons
      9769 st_font
      9801 st_widget
      9872 st_terminal
      9901 st_newtab
      9951 st_wall
      9985 st_wallpapers
      10027 st_keys
      10071 st_panel
      10117 st_app
      10149 st_serve
      10170 st_revert
      10227 st_themes
      10269 st_look
      10345 st_tabby
      10397 codium_tail_of
      10402 st_codium
      10517 st_profile
      10592 st_refresh
      10640 st_tune
      10721 st_report
      10775 st_overview
      10812 st_presets
      10849 st_help
      10908 usage
      10970 help_settings
      11043 cmd_help
