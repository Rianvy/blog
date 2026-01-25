---
title: CodeSqueeze — Online Code Minifier
date: 2026-01-19T08:05:59+03:00
author: Rianvy
avatar: /img/avatar.jpg
description: A modern online HTML, CSS, and JavaScript minifier with offline support, detailed statistics, and a thoughtfully designed interface.
cover: Cover.png
images:
  - Cover.png
tags:
  - Web Development
  - UI/UX
  - Frontend
  - JavaScript
  - Optimization
  - Web Tools
  - Figma
filters:
  - Web-Development
tools:
  - Figma
  - HTML
  - CSS
  - Tailwind CSS
  - JavaScript
github: "https://github.com/Rianvy/CodeSqueeze"
demo: "https://codesqueeze.0x69.ru"
---
**CodeSqueeze** is a modern web tool for minifying HTML, CSS, and JavaScript, focused on speed, privacy, and a comfortable in-browser workflow.
<!--more-->

## 📌 About the project

**CodeSqueeze** is a standalone product developed from the initial idea to the final implementation.
The interface, UX logic, and visual system were designed in **Figma**, after which the tool was fully implemented on the frontend with no backend involved.

The main goal of the project was to create a **fast and intuitive tool** that doesn’t distract the user and provides clear, transparent feedback when working with code.

---

## ✨ What was done

### Interface & UX

* Designed the complete user flow in **Figma**: from screen structure to an interactive prototype
* Implemented a dark theme with an accent brand color
* Responsive, mobile-first interface
* Added subtle visual accents and micro-animations to improve perception

### Functionality

* Dual-pane editor for source and processed code
* HTML, CSS, and JavaScript minification with result control
* Reverse formatting (Beautify) for improved readability
* Detailed statistics: size before and after, compression percentage, processing time
* Operation history with state persistence in the browser
* Keyboard shortcuts to speed up workflow
* Notification system for clear user feedback

### Technical approach

* Pure **Vanilla JavaScript** without frameworks
* Modular code structure for easier maintenance and scalability
* **Tailwind CSS** for building the design system
* Fully client-side data processing — code is never sent to a server
* Offline support after the first load

### Additional sections

* Features — overview of capabilities
* Stats — extended statistics
* Documentation — usage guide
* Privacy & Terms — legal pages

---

## 🖼️ Project interface

### Main page

![Main page](work/main.png "Main CodeSqueeze interface")

### Features

![Features](work/features.png "Service feature overview")

### Statistics

![Statistics](work/stats.png "Detailed minification statistics")

### Documentation

![Documentation](work/docs.png "Documentation")

### Privacy & Terms

![Privacy Policy](work/privacy.png "Privacy Policy")

![Terms of Service](work/terms.png "Terms of Service")

---

## 📱 Mobile version

{{< mobile-screens images="main,features,stats,docs,privacy,terms" >}}

---

## 🎨 Design system

{{< color_palette
name1="Brand / Primary" code1="#00ff88"
name2="Brand Dark" code2="#009952"
name3="Background Dark" code3="#0a0a0a"
name4="Surface Dark" code4="#141414"
name5="Text / Accent" code5="#e6fff5"

>}}

* **Typography:** Inter for the interface, JetBrains Mono for working with code
* **Visual techniques:** soft shadows, glow accents, progress indicators, subtle animations

---

## 🌐 Summary

* A full-featured product implemented without a backend
* Well-thought-out UI/UX with a focus on usability and speed
* Secure code processing directly in the browser
* Flexible architecture ready for future growth