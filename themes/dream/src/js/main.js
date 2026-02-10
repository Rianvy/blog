document.addEventListener('alpine:init', () => {
  Alpine.store('darkMode', {
    init() {
      const isDark = window.localStorage.getItem('hugo-theme-dream-is-dark')

      if (isDark) {
        this.on = isDark
      } else {
        this.mql.addEventListener('change', (event) => {
          this.on = event.matches ? 'y' : 'n'
          this.setThemeForComments()
        })
        this.on = 'auto'
      }

      window.addEventListener('message', (event) => {
        if (event.origin === 'https://giscus.app') {
          this.setThemeForComments()
        }
      })
    },

    mql: window.matchMedia('(prefers-color-scheme: dark)'),
    on: 'n',

    isDark() {
      return this.on === 'auto' ? this.mql.matches : this.on === 'y'
    },
    class() {
      if (this.on === 'auto') {
        return this.mql.matches ? 'dark' : 'light'
      } else {
        return this.on === 'y' ? 'dark' : 'light'
      }
    },
    theme() {
      if (this.on === 'auto') {
        return this.mql.matches ? window.darkTheme : window.lightTheme
      } else {
        return this.on === 'y' ? window.darkTheme : window.lightTheme
      }
    },

    iconMap: {
      n: 'sunny',
      y: 'moon',
      auto: 'desktop',
    },
    icon() {
      return this.iconMap[this.on]
    },

    toggle(status) {
      this.on = status

      if (status === 'auto') {
        window.localStorage.removeItem('hugo-theme-dream-is-dark')
      } else {
        window.localStorage.setItem('hugo-theme-dream-is-dark', status)
      }

      this.setThemeForComments()
    },

    setThemeForComments() {
      const frame = document.querySelector('iframe.gsc-frame')
      if (!frame) return

      const theme = this.isDark()
        ? (window.giscusDarkTheme || 'dark')
        : (window.giscusLightTheme || 'light')

      frame.contentWindow.postMessage(
        { giscus: { setConfig: { theme: theme } } },
        'https://giscus.app'
      )
    },
  })
})