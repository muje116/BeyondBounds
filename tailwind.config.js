module.exports = {
  content: ['./themes/beyondbounds/**/*.htm','./themes/beyondbounds/**/*.html','./plugins/beyondbounds/**/*.htm'],
  theme: {
    extend: {
      colors: {
        background: '#0e1416',
        surface: '#0e1416',
        'surface-container-low': '#171c1f',
        'surface-container': '#1b2023',
        'surface-container-high': '#252b2d',
        'surface-container-highest': '#303638',
        'on-background': '#dee3e6',
        'on-surface': '#dee3e6',
        'on-surface-variant': '#bcc9ce',
        outline: '#869398',
        'outline-variant': '#3d494d',
        primary: '#4cd6fb',
        'primary-container': '#00b4d8',
        'on-primary-container': '#00414f',
        secondary: '#ffb0cc'
      },
      fontFamily: {
        'headline-xl': ['Epilogue', 'serif'],
        'headline-lg': ['Epilogue', 'serif'],
        'headline-md': ['Epilogue', 'serif'],
        'body-md': ['Manrope', 'sans-serif'],
        'body-lg': ['Manrope', 'sans-serif'],
        'label-bold': ['Manrope', 'sans-serif']
      },
      fontSize: {
        'headline-xl': ['56px', { lineHeight: '1.05', letterSpacing: '-0.02em', fontWeight: '800' }],
        'headline-lg': ['40px', { lineHeight: '1.15', letterSpacing: '-0.01em', fontWeight: '700' }],
        'headline-md': ['28px', { lineHeight: '1.25', fontWeight: '700' }],
        'body-lg': ['20px', { lineHeight: '1.65', fontWeight: '500' }],
        'body-md': ['18px', { lineHeight: '1.6', fontWeight: '500' }],
        'label-bold': ['15px', { lineHeight: '1.2', letterSpacing: '0.05em', fontWeight: '700' }]
      }
    }
  },
  plugins: [require('@tailwindcss/forms'),require('@tailwindcss/typography'),require('@tailwindcss/aspect-ratio')]
};
