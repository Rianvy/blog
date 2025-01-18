"use strict";

document.addEventListener('alpine:init', function () {
  // Первый скрипт: управление темной темой
  Alpine.store('darkMode', {
    init: function init() {
      var _this = this;
      var isDark = window.localStorage.getItem('hugo-theme-dream-is-dark');
      if (isDark) {
        this.on = isDark;
      } else {
        this.mql.addEventListener('change', function (event) {
          _this.on = event.matches ? 'y' : 'n';
        });
        this.on = 'auto';
      }
      setTimeout(function () {
        _this.setThemeForUtterances();
      }, 6000);
    },
    mql: window.matchMedia('(prefers-color-scheme: dark)'),
    on: 'n',
    isDark: function isDark() {
      return this.on === 'auto' ? this.mql.matches : this.on === 'y';
    },
    "class": function _class() {
      if (this.on === 'auto') {
        return this.mql.matches ? 'dark' : 'light';
      } else {
        return this.on === 'y' ? 'dark' : 'light';
      }
    },
    theme: function theme() {
      if (this.on === 'auto') {
        return this.mql.matches ? window.darkTheme : window.lightTheme;
      } else {
        return this.on === 'y' ? window.darkTheme : window.lightTheme;
      }
    },
    iconMap: {
      n: 'sunny',
      y: 'moon',
      auto: 'desktop'
    },
    icon: function icon() {
      return this.iconMap[this.on];
    },
    toggle: function toggle(status) {
      this.on = status;
      if (status === 'auto') {
        window.localStorage.removeItem('hugo-theme-dream-is-dark');
      } else {
        window.localStorage.setItem('hugo-theme-dream-is-dark', status);
      }
      this.setThemeForUtterances();
    },
    setThemeForUtterances: function setThemeForUtterances() {
      var utterances = document.querySelector('iframe.utterances-frame');
      if (utterances) {
        utterances.contentWindow.postMessage({
          type: 'set-theme',
          theme: this.isDark() ? 'github-dark' : 'github-light'
        }, 'https://utteranc.es');
      }
    }
  });

  // Второй скрипт: универсальный компонент для загрузки виджетов
  Alpine.data('commentsWidget', () => ({
    init() {
      this.loadWidget();
      this.$watch('$store.darkMode.isDark()', () => {
        this.loadWidget();
      });
    },
    loadWidget() {
      // Очищаем предыдущий виджет
      this.$el.innerHTML = '';

      // Извлекаем данные из атрибутов
      const type = this.$el.getAttribute('data-widget-type'); // Тип виджета: telegram или commentsApp
      const discussion = this.$el.getAttribute('data-discussion'); // ID обсуждения
      const limit = this.$el.getAttribute('data-limit') || '10'; // Лимит комментариев
      const isDark = this.$store.darkMode.isDark() ? '1' : '0'; // Тема

      // Создаем новый скрипт
      const script = document.createElement('script');
      script.async = true;

      // Устанавливаем атрибуты в зависимости от типа виджета
      if (type === 'telegram') {
        script.src = 'https://telegram.org/js/telegram-widget.js?22';
        const dataAttributes = {
          'data-telegram-discussion': discussion,
          'data-comments-limit': limit,
          'data-colorful': '1',
          'data-color': '1eb854',
          'data-dark': isDark
        };
        Object.entries(dataAttributes).forEach(([key, value]) => {
          script.setAttribute(key, value);
        });
      } else if (type === 'commentsApp') {
        script.src = 'https://comments.app/js/widget.js?3';
        const dataAttributes = {
          'data-comments-app-website': discussion,
          'data-limit': limit,
          'data-colorful': '1',
          'data-color': '1eb854',
          'data-dark': isDark
        };
        Object.entries(dataAttributes).forEach(([key, value]) => {
          script.setAttribute(key, value);
        });
      }

      // Добавляем скрипт в контейнер
      this.$el.appendChild(script);
    }
  }));
});