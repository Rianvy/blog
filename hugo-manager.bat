@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:menu
cls
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              🚀 HUGO BLOG MANAGER v2.2                       ║
echo ╠══════════════════════════════════════════════════════════════╣
echo ║                                                              ║
echo ║  [1] 🖥️  Запустить сервер                                   ║
echo ║  [2] 🏗️  Собрать сайт                                       ║
echo ║                                                              ║
echo ║  ─────────────── ПОСТЫ ──────────────────                    ║
echo ║  [3] 📝 Новый пост (RU)                                      ║
echo ║  [4] 📝 Новый пост (EN)                                      ║
echo ║  [5] 📝 Новый пост (RU + EN)                                 ║
echo ║                                                              ║
echo ║  ─────────────── ПОРТФОЛИО ──────────────                    ║
echo ║  [6] 🎨 Новый проект (RU)                                    ║
echo ║  [7] 🎨 Новый проект (EN)                                    ║
echo ║  [8] 🎨 Новый проект (RU + EN)                               ║
echo ║                                                              ║
echo ║  ─────────────── УТИЛИТЫ ─────────────────                   ║
echo ║  [9] 📋 Список постов                                        ║
echo ║  [10] 📋 Список портфолио                                    ║
echo ║  [11] 🧹 Очистить кэш                                        ║
echo ║  [12] 📊 Статистика                                          ║
echo ║                                                              ║
echo ║  [0] ❌ Выход                                                ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

set /p choice="[0-12]: "

if "%choice%"=="1" goto start_server
if "%choice%"=="2" goto build_site
if "%choice%"=="3" goto create_post_ru
if "%choice%"=="4" goto create_post_en
if "%choice%"=="5" goto create_post_both
if "%choice%"=="6" goto create_portfolio_ru
if "%choice%"=="7" goto create_portfolio_en
if "%choice%"=="8" goto create_portfolio_both
if "%choice%"=="9" goto list_posts
if "%choice%"=="10" goto list_portfolio
if "%choice%"=="11" goto clean_cache
if "%choice%"=="12" goto show_stats
if "%choice%"=="0" exit /b 0

goto menu

:start_server
hugo server -D --navigateToChanged
pause
goto menu

:build_site
hugo --minify
pause
goto menu

:: ============================================
:: ПОСТЫ
:: ============================================
:create_post_ru
cls
echo.
echo 📝 Новый пост (RU)
echo ────────────────────────────
set /p "slug=Slug: "
if "%slug%"=="" goto menu

hugo new --contentDir content/russian posts/%slug%/index.md --kind posts
echo.
echo ✅ content/russian/posts/%slug%/
pause
goto menu

:create_post_en
cls
echo.
echo 📝 New post (EN)
echo ────────────────────────────
set /p "slug=Slug: "
if "%slug%"=="" goto menu

hugo new --contentDir content/english posts/%slug%/index.md --kind posts
echo.
echo ✅ content/english/posts/%slug%/
pause
goto menu

:create_post_both
cls
echo.
echo 📝 Новый пост (RU + EN)
echo ────────────────────────────
set /p "slug=Slug: "
if "%slug%"=="" goto menu

:: RU
hugo new content/russian/posts/%slug%/index.md --kind posts

:: EN
hugo new content/english/posts/%slug%/index.md --kind posts

echo.
echo ✅ RU: content/russian/posts/%slug%/
echo ✅ EN: content/english/posts/%slug%/
pause
goto menu

:: ============================================
:: ПОРТФОЛИО
:: ============================================
:create_portfolio_ru
cls
echo.
echo 🎨 Новый проект (RU)
echo ────────────────────────────
set /p "slug=Slug: "
if "%slug%"=="" goto menu

hugo new --contentDir content/russian portfolio/%slug%/index.md --kind portfolio
echo.
echo ✅ content/russian/portfolio/%slug%/
pause
goto menu

:create_portfolio_en
cls
echo.
echo 🎨 New project (EN)
echo ────────────────────────────
set /p "slug=Slug: "
if "%slug%"=="" goto menu

hugo new --contentDir content/english portfolio/%slug%/index.md --kind portfolio
echo.
echo ✅ content/english/portfolio/%slug%/
pause
goto menu

:create_portfolio_both
cls
echo.
echo 🎨 Новый проект (RU + EN)
echo ────────────────────────────
set /p "slug=Slug: "
if "%slug%"=="" goto menu

:: RU
hugo new content/russian/portfolio/%slug%/index.md --kind portfolio

:: EN
hugo new content/english/portfolio/%slug%/index.md --kind portfolio

echo.
echo ✅ RU: content/russian/portfolio/%slug%/
echo ✅ EN: content/english/portfolio/%slug%/
pause
goto menu

:: ============================================
:: УТИЛИТЫ
:: ============================================
:list_posts
cls
echo.
echo 📋 Посты
echo ════════════════════════════
echo 🇷🇺 RU:
for /d %%D in ("content\russian\posts\*") do echo   %%~nxD
echo.
echo 🇬🇧 EN:
for /d %%D in ("content\english\posts\*") do echo   %%~nxD
pause
goto menu

:list_portfolio
cls
echo.
echo 📋 Портфолио
echo ════════════════════════════
echo 🇷🇺 RU:
for /d %%D in ("content\russian\portfolio\*") do echo   %%~nxD
echo.
echo 🇬🇧 EN:
for /d %%D in ("content\english\portfolio\*") do echo   %%~nxD
pause
goto menu

:clean_cache
hugo --gc
rmdir /s /q "public" 2>nul
rmdir /s /q "resources" 2>nul
rmdir /s /q "content\posts" 2>nul
rmdir /s /q "content\portfolio" 2>nul
del ".hugo_build.lock" 2>nul
echo ✅ Очищено!
pause
goto menu

:show_stats
cls
set /a ru_posts=0 & set /a en_posts=0 & set /a ru_port=0 & set /a en_port=0
for /d %%D in ("content\russian\posts\*") do set /a ru_posts+=1
for /d %%D in ("content\english\posts\*") do set /a en_posts+=1
for /d %%D in ("content\russian\portfolio\*") do set /a ru_port+=1
for /d %%D in ("content\english\portfolio\*") do set /a en_port+=1
echo.
echo 📊 Статистика
echo ════════════════════════════
echo 📝 Посты:     RU=%ru_posts%  EN=%en_posts%
echo 🎨 Портфолио: RU=%ru_port%  EN=%en_port%
set /a total=%ru_posts%+%en_posts%+%ru_port%+%en_port%
echo ────────────────────────────
echo 📦 Всего: %total%
pause
goto menu