---
title: AutoSteamGifts — Automated Steam Gift Delivery
date: 2026-07-29T20:02:52+03:00
status: completed  # completed | in-progress | archived | planned | paused
author: Rianvy
avatar: /img/avatar.jpg
description: A self-hosted Steam game storefront with automated gift delivery, a public catalog, and a full-featured operations dashboard.
cover: Cover.png
images:
  - Cover.png
tags:
  - Web Development
  - Fullstack
  - Automation
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
**AutoSteamGifts** is a self-hosted platform that automates the entire Steam Gift sales flow: from a Digiseller/Plati payment webhook to selecting a sender account in the correct region, adding the buyer as a friend, purchasing the game, and delivering the gift.
<!--more-->

## 📌 About the project

The goal was to turn a manual Steam Gift fulfillment routine into a controlled and observable workflow. A seller connects a pool of sender accounts, creates products, and configures the shop. The system then processes new payments, moves every order through an explicit state machine, and shows the buyer live delivery progress.

The product combines three connected parts:

- a public storefront with a game catalog and product pages;
- a protected administration panel for shop and operations management;
- a delivery backend with queues, Steam and Digiseller integrations, logs, and notifications.

## ✨ What was implemented

### Automated delivery

- Digiseller/Plati webhook handling with invoice deduplication.
- Buyer profile resolution from a profile link, vanity URL, or SteamID.
- Sender selection by region, status, balance, cooldown, and availability.
- A complete “friend request → acceptance wait → purchase → gift delivery” workflow.
- Exponential-backoff retries and a dedicated manual reconciliation flow for ambiguous payments.
- A public order page with profile confirmation and live delivery progress.

### Public storefront

- A home page with a hero section, discounts, best sellers, new arrivals, and curated collections.
- Search, sorting, and filters for price, region, genres, features, publishers, and developers.
- Rich game pages with artwork, galleries, trailers, descriptions, localization, system requirements, reviews, and related products.
- Automatic Steam Store prices, discounts, artwork, and metadata.
- Curated collections, registration-free favorites, editable legal pages, and Russian/English content support.

### Administration panel

- JWT authentication and a configurable secret path instead of a predictable `/admin` URL.
- A dashboard for orders, conversion, sender health, catalog status, and Digiseller sales.
- Management screens for Steam accounts, products, collections, pages, orders, logs, and settings.
- Detailed order history, step-by-step logs, and guarded manual operator actions.
- A unified Chakra UI design system, responsive navigation, and light/dark themes.

### Reliability and operations

- Independent Steam and Digiseller `mock`/`real` providers for safe testing.
- BullMQ + Redis delivery workers, with an inline mode that runs without Redis.
- AES-256-GCM encryption for sender-account secrets.
- A transactional outbox for Telegram notifications, retries, and duplicate suppression.
- Rate limiting, CORS, Helmet, structured logging, graceful shutdown, and Docker Compose.
- A browser-based installer that validates the environment, writes configuration, runs migrations, and creates the first administrator.

## ⚙️ Architecture

A payment webhook creates an order and schedules a delivery job. The worker selects an eligible sender for the buyer's region and performs the Steam steps through a provider abstraction. Every state transition is persisted, exposed in the admin panel, and can generate a reliably delivered notification.

This separation keeps external services isolated, makes every scenario reproducible in mock mode, and allows SQLite/PostgreSQL or BullMQ/inline to be swapped without changing the core business workflow.

## 🖼️ Project interface

The screenshots were captured on an isolated demo environment containing **38 games, 5 collections, 17 test orders, and 3 mock sender accounts**. All real Steam and Digiseller operations were disabled while the assets were prepared.

Every comparison uses the same application state and viewport. Light and dark variants can be switched directly inside each block, while the key screens also support a draggable comparison slider.

### Public storefront

{{< theme-compare light="work/shop-home-light.png" dark="work/shop-home-dark.png" title="Complete storefront home page" caption="Hero, quick search, discounts, best sellers, genres, new arrivals, curated collections, localization, and footer." mode="slider" >}}

{{< theme-compare light="work/shop-catalog-light.png" dark="work/shop-catalog-dark.png" title="Complete 38-game catalog" caption="Search, sorting, and filters for price, collections, genres, features, region, publisher, and developer." mode="toggle" >}}

{{< theme-compare light="work/shop-product-light.png" dark="work/shop-product-dark.png" title="Game product page" caption="Gallery, Steam metadata, genres, favorites, and checkout using ELDEN RING." mode="toggle" >}}

{{< theme-compare light="work/shop-product-reviews-light.png" dark="work/shop-product-reviews-dark.png" title="Product reviews" caption="A dedicated product-page state with rating and customer feedback." mode="toggle" >}}

{{< theme-compare light="work/shop-collections-light.png" dark="work/shop-collections-dark.png" title="Collections catalog" caption="Promoted collections and themed storefront shelves built from the demo catalog." mode="toggle" >}}

{{< theme-compare light="work/shop-collection-detail-light.png" dark="work/shop-collection-detail-dark.png" title="Collection page" caption="Generated cover collage, description, and the complete editor-curated selection." mode="toggle" >}}

{{< theme-compare light="work/shop-favorites-light.png" dark="work/shop-favorites-dark.png" title="Registration-free favorites" caption="Saved products and collections remain locally available to the buyer." mode="toggle" >}}

{{< theme-compare light="work/buyer-order-light.png" dark="work/buyer-order-dark.png" title="Purchase status" caption="Public delivered-gift screen with a clear next action for the buyer." mode="toggle" >}}

### Storefront content and system states

{{< theme-compare light="work/shop-terms-light.png" dark="work/shop-terms-dark.png" title="Terms of service" caption="An admin-managed legal page with section navigation." mode="toggle" >}}

{{< theme-compare light="work/shop-privacy-light.png" dark="work/shop-privacy-dark.png" title="Privacy policy" caption="A second managed content page shown directly in the storefront." mode="toggle" >}}

{{< theme-compare light="work/shop-404-light.png" dark="work/shop-404-dark.png" title="404 page" caption="A clean unknown-route state with a clear path back to the store." mode="toggle" >}}

### Administration panel

{{< theme-compare light="work/admin-login-light.png" dark="work/admin-login-dark.png" title="Administrator sign-in" caption="An isolated authentication screen served from a configurable secret path." mode="toggle" >}}

{{< theme-compare light="work/admin-dashboard-light.png" dark="work/admin-dashboard-dark.png" title="Operations dashboard" caption="Orders, conversion, sales, attention states, sender pool, and catalog health in one view." mode="slider" >}}

{{< theme-compare light="work/admin-orders-light.png" dark="work/admin-orders-dark.png" title="Order list" caption="Search, every delivery status, and 17 orders covering a wide range of demo scenarios." mode="toggle" >}}

{{< theme-compare light="work/admin-order-detail-light.png" dark="work/admin-order-detail-dark.png" title="Detailed order view" caption="Payment, buyer, assigned sender, delivery timeline, step-by-step log, and guarded operator actions." mode="toggle" >}}

{{< theme-compare light="work/admin-accounts-light.png" dark="work/admin-accounts-dark.png" title="Steam sender pool" caption="Regions, balances, limits, cooldowns, delivery counts, and mock-account diagnostics." mode="toggle" >}}

{{< theme-compare light="work/admin-account-form-light.png" dark="work/admin-account-form-dark.png" title="Add sender account" caption="Credentials, Steam Guard, proxy, and explicit real-purchase permission." mode="toggle" >}}

{{< theme-compare light="work/admin-products-light.png" dark="work/admin-products-dark.png" title="Catalog management" caption="Products, regions, prices, Steam synchronization, and Digiseller placement status." mode="toggle" >}}

{{< theme-compare light="work/admin-product-form-light.png" dark="work/admin-product-form-dark.png" title="Complete product editor" caption="Steam link, regions, placement, gallery, bilingual descriptions, and automatically fetched metadata." mode="toggle" >}}

{{< theme-compare light="work/admin-products-bulk-light.png" dark="work/admin-products-bulk-dark.png" title="Bulk product creation" caption="Import a game list by URL or AppID, optionally with price and follow-up synchronization." mode="toggle" >}}

{{< theme-compare light="work/admin-collections-light.png" dark="work/admin-collections-dark.png" title="Collection management" caption="Ordering, visibility, and promotional state for curated storefront collections." mode="toggle" >}}

{{< theme-compare light="work/admin-collection-form-light.png" dark="work/admin-collection-form-dark.png" title="Collection editor" caption="Title, description, promotion controls, and manual game ordering." mode="toggle" >}}

{{< theme-compare light="work/admin-pages-light.png" dark="work/admin-pages-dark.png" title="Page editor" caption="Manage legal copy and supporting content without touching application code." mode="toggle" >}}

{{< theme-compare light="work/admin-settings-light.png" dark="work/admin-settings-dark.png" title="Platform settings" caption="Branding, delivery, integrations, notifications, security, and external-provider modes." mode="toggle" >}}

{{< theme-compare light="work/installer-status-light.png" dark="work/installer-status-dark.png" title="Protected installer state" caption="Once setup is complete, the installer blocks repeat execution for safety." mode="toggle" >}}

## 🔧 Technology stack

- **Frontend:** React 18, TypeScript, Vite, Chakra UI v3, React Markdown, HLS.js.
- **Backend:** Node.js, TypeScript, Express, Prisma.
- **Data and queues:** SQLite/PostgreSQL, Redis, BullMQ.
- **Integrations:** Steam, Digiseller/Plati, Telegram.
- **Infrastructure:** Docker, Docker Compose, Nginx.

## 🌐 Outcome

The result is a single system for running a Steam Gift shop: buyers get a polished storefront and a transparent order status, while sellers get automated delivery, sender-pool control, operational tools, and complete visibility into every order.
