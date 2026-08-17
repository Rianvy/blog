---
title: AutoSteamGifts — автоматическая доставка Steam Gift
date: 2026-07-29T20:02:52+03:00
status: completed  # completed | in-progress | archived | planned | paused
author: Rianvy
avatar: /img/avatar.jpg
description: Self-hosted платформа для продажи Steam-игр с автоматической доставкой подарков, публичной витриной и полноценной панелью управления.
cover: Cover.png
images:
  - Cover.png
tags:
  - Веб-разработка
  - Fullstack
  - Автоматизация
  - E-commerce
  - Steam
  - TypeScript
  - React
  - Node.js
  - UI/UX
filters:
  - Web-Development
tools:
  - TypeScript
  - React
  - Vite
  - Chakra UI
  - Node.js
  - Express
  - Prisma
  - SQLite
  - PostgreSQL
  - Redis
  - BullMQ
  - Docker
github: "https://github.com/Rianvy/AutoSteamGifts"
---
**AutoSteamGifts** — self-hosted платформа, которая автоматизирует весь путь продажи Steam Gift: от webhook об оплате на Digiseller/Plati до выбора аккаунта нужного региона, отправки заявки в друзья, покупки игры и доставки подарка покупателю.
<!--more-->

## 📌 О проекте

Задача проекта — превратить ручную выдачу Steam-подарков в управляемый и наблюдаемый процесс. Продавец подключает пул аккаунтов, создаёт товары и настраивает магазин, а система самостоятельно обрабатывает новые оплаты, ведёт заказ по конечному автомату статусов и показывает покупателю актуальный прогресс доставки.

Продукт включает три связанные части:

- публичную витрину с каталогом игр и страницами товаров;
- защищённую админ-панель для управления магазином и операциями;
- backend доставки с очередями, интеграциями Steam и Digiseller, журналированием и уведомлениями.

## ✨ Что было реализовано

### Автоматическая доставка

- Приём и дедупликация webhook от Digiseller/Plati.
- Определение Steam-профиля покупателя по ссылке, vanity URL или SteamID.
- Подбор свободного аккаунта-отправителя по региону, статусу, балансу и cooldown.
- Сценарий «заявка в друзья → ожидание принятия → покупка → отправка подарка».
- Ретраи с экспоненциальной задержкой и отдельный сценарий ручной сверки неоднозначной оплаты.
- Публичная страница заказа с подтверждением профиля и живым прогрессом доставки.

### Публичная витрина

- Главная с hero-блоком, скидками, лидерами продаж, новинками и тематическими подборками.
- Каталог с поиском, сортировками и фильтрами по цене, региону, жанрам, особенностям, издателям и разработчикам.
- Полноценная страница игры: арт, галерея, трейлеры, описание, локализация, системные требования, отзывы и похожие товары.
- Автоматическое получение цен, скидок, обложек и метаданных из Steam Store.
- Коллекции, избранное без регистрации, редактируемые юридические страницы и поддержка русского/английского контента.

### Админ-панель

- JWT-авторизация и отдельный секретный путь вместо предсказуемого `/admin`.
- Дашборд со статистикой заказов, конверсией, состоянием аккаунтов, каталогом и продажами Digiseller.
- Управление Steam-аккаунтами, товарами, коллекциями, страницами, заказами, логами и настройками.
- Детальная история заказа, пошаговые логи и безопасные ручные действия оператора.
- Единая дизайн-система на Chakra UI, адаптивная навигация, светлая и тёмная темы.

### Надёжность и эксплуатация

- Независимые `mock`/`real`-провайдеры Steam и Digiseller для безопасного тестирования.
- BullMQ + Redis для фоновой доставки или inline-режим без Redis.
- Шифрование секретов аккаунтов через AES-256-GCM.
- Transactional outbox для Telegram-уведомлений, повторные попытки и защита от дублей.
- Rate limiting, CORS, Helmet, структурированные логи, graceful shutdown и Docker Compose.
- Веб-установщик, который проверяет окружение, создаёт конфигурацию, применяет миграции и заводит администратора.

## ⚙️ Архитектура

Платёжный webhook создаёт заказ и ставит задачу доставки в очередь. Worker подбирает аккаунт нужного региона и выполняет шаги Steam через абстракцию провайдера. Все переходы статуса сохраняются в БД, отображаются в админке и при необходимости порождают надёжно доставляемое уведомление.

Такое разделение позволило изолировать внешние сервисы, безопасно воспроизводить сценарии в mock-режиме и переключать SQLite/PostgreSQL или BullMQ/inline без изменения бизнес-логики.

## 🖼️ Интерфейс проекта

Скриншоты сделаны на изолированном демонстрационном стенде: **38 игр, 5 подборок, 17 тестовых заказов и 3 mock-аккаунта отправителей**. Реальные операции Steam и Digiseller при подготовке материалов были отключены.

Каждая демонстрация синхронизирована по состоянию и размеру. Светлую и тёмную версии можно переключать прямо внутри блока, а на ключевых экранах — сравнивать ползунком.

### Публичная витрина

{{< theme-compare light="work/shop-home-light.png" dark="work/shop-home-dark.png" title="Главная страница магазина целиком" caption="Hero-блок, быстрый поиск, скидки, лидеры продаж, жанры, новинки, подборки, русская локализация и футер." mode="slider" >}}

{{< theme-compare light="work/shop-catalog-light.png" dark="work/shop-catalog-dark.png" title="Полный каталог из 38 игр" caption="Поиск, сортировка и фильтры по цене, подборкам, жанрам, особенностям, региону, издателю и разработчику." mode="toggle" >}}

{{< theme-compare light="work/shop-product-light.png" dark="work/shop-product-dark.png" title="Карточка игры" caption="Галерея, Steam-метаданные, жанры, избранное и блок покупки на примере ELDEN RING." mode="toggle" >}}

{{< theme-compare light="work/shop-product-reviews-light.png" dark="work/shop-product-reviews-dark.png" title="Отзывы о товаре" caption="Отдельное состояние карточки с рейтингом и отзывами покупателей." mode="toggle" >}}

{{< theme-compare light="work/shop-collections-light.png" dark="work/shop-collections-dark.png" title="Каталог подборок" caption="Промо-подборки и тематические витринные полки, сформированные из тестового каталога." mode="toggle" >}}

{{< theme-compare light="work/shop-collection-detail-light.png" dark="work/shop-collection-detail-dark.png" title="Страница подборки" caption="Обложка-коллаж, описание и полный состав редакционной подборки." mode="toggle" >}}

{{< theme-compare light="work/shop-favorites-light.png" dark="work/shop-favorites-dark.png" title="Избранное без регистрации" caption="Сохранённые товары и подборки остаются доступны покупателю локально." mode="toggle" >}}

{{< theme-compare light="work/buyer-order-light.png" dark="work/buyer-order-dark.png" title="Статус покупки" caption="Публичный экран доставленного подарка с понятным следующим действием для покупателя." mode="toggle" >}}

### Контент и служебные состояния витрины

{{< theme-compare light="work/shop-terms-light.png" dark="work/shop-terms-dark.png" title="Пользовательское соглашение" caption="Редактируемая из админ-панели юридическая страница с навигацией по разделам." mode="toggle" >}}

{{< theme-compare light="work/shop-privacy-light.png" dark="work/shop-privacy-dark.png" title="Политика конфиденциальности" caption="Вторая управляемая контентная страница витрины." mode="toggle" >}}

{{< theme-compare light="work/shop-404-light.png" dark="work/shop-404-dark.png" title="Страница 404" caption="Аккуратное состояние для неизвестного адреса с возвратом в магазин." mode="toggle" >}}

### Админ-панель

{{< theme-compare light="work/admin-login-light.png" dark="work/admin-login-dark.png" title="Вход администратора" caption="Изолированный экран авторизации на настраиваемом секретном пути." mode="toggle" >}}

{{< theme-compare light="work/admin-dashboard-light.png" dark="work/admin-dashboard-dark.png" title="Операционный дашборд" caption="Заказы, конверсия, продажи, требующие внимания статусы, пул аккаунтов и состояние каталога." mode="slider" >}}

{{< theme-compare light="work/admin-orders-light.png" dark="work/admin-orders-dark.png" title="Список заказов" caption="Поиск, фильтры по всем статусам и 17 заказов с разнообразными тестовыми сценариями." mode="toggle" >}}

{{< theme-compare light="work/admin-order-detail-light.png" dark="work/admin-order-detail-dark.png" title="Детальная карточка заказа" caption="Оплата, покупатель, назначенный отправитель, хронология доставки, пошаговый лог и безопасные действия оператора." mode="toggle" >}}

{{< theme-compare light="work/admin-accounts-light.png" dark="work/admin-accounts-dark.png" title="Пул Steam-аккаунтов" caption="Регионы, балансы, лимиты, cooldown, статистика отправок и диагностика mock-аккаунтов." mode="toggle" >}}

{{< theme-compare light="work/admin-account-form-light.png" dark="work/admin-account-form-dark.png" title="Добавление аккаунта" caption="Учётные данные, Steam Guard, прокси и отдельное подтверждение реальных покупок." mode="toggle" >}}

{{< theme-compare light="work/admin-products-light.png" dark="work/admin-products-dark.png" title="Управление каталогом" caption="Товары, регионы, цены, синхронизация со Steam и статус размещения в Digiseller." mode="toggle" >}}

{{< theme-compare light="work/admin-product-form-light.png" dark="work/admin-product-form-dark.png" title="Полный редактор товара" caption="Steam-ссылка, регионы, размещение, галерея, описания на двух языках и автоматически загруженные метаданные." mode="toggle" >}}

{{< theme-compare light="work/admin-products-bulk-light.png" dark="work/admin-products-bulk-dark.png" title="Массовое создание товаров" caption="Импорт списка игр по ссылке или AppID с ценой и последующей синхронизацией." mode="toggle" >}}

{{< theme-compare light="work/admin-collections-light.png" dark="work/admin-collections-dark.png" title="Управление подборками" caption="Порядок, видимость и промо-статус витринных коллекций." mode="toggle" >}}

{{< theme-compare light="work/admin-collection-form-light.png" dark="work/admin-collection-form-dark.png" title="Редактор подборки" caption="Название, описание, промо-настройки и ручная сортировка игр внутри коллекции." mode="toggle" >}}

{{< theme-compare light="work/admin-pages-light.png" dark="work/admin-pages-dark.png" title="Редактор страниц" caption="Управление юридическими текстами и служебным контентом без изменения кода." mode="toggle" >}}

{{< theme-compare light="work/admin-settings-light.png" dark="work/admin-settings-dark.png" title="Настройки платформы" caption="Брендинг, доставка, интеграции, уведомления, безопасность и режимы внешних провайдеров." mode="toggle" >}}

{{< theme-compare light="work/installer-status-light.png" dark="work/installer-status-dark.png" title="Защищённое состояние инсталлятора" caption="После завершения установки повторный запуск блокируется из соображений безопасности." mode="toggle" >}}

## 🔧 Технологии

- **Frontend:** React 18, TypeScript, Vite, Chakra UI v3, React Markdown, HLS.js.
- **Backend:** Node.js, TypeScript, Express, Prisma.
- **Данные и очереди:** SQLite/PostgreSQL, Redis, BullMQ.
- **Интеграции:** Steam, Digiseller/Plati, Telegram.
- **Инфраструктура:** Docker, Docker Compose, Nginx.

## 🌐 Результат

Получилась единая система для запуска собственного магазина Steam Gift: покупатель получает удобную витрину и прозрачный статус заказа, а продавец — автоматизированную доставку, контроль пула аккаунтов, операционные инструменты и полную наблюдаемость каждого заказа.
