const plugin = require("tailwindcss/plugin");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
    "./app/components/**/*.{erb,haml,html,slim,rb}",
    "./config/initializers/simple_form.rb",
  ],
  darkMode: "class",
  theme: {
    extend: {
      fontFamily: {
        sans: ["Poppins"],
      },
      colors: {
        background: "var(--color-background)",
        text: "var(--color-text)",
        surface: "var(--color-surface)",
        primary: "var(--color-primary)",
        light: "var(--color-light)",
      },
      borderColor: {
        DEFAULT: "var(--color-border)",
      },
      container: {
        center: true,
        screens: {
          DEFAULT: "1200px",
        },
        padding: {
          DEFAULT: "1.5em",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
    plugin(function ({ addBase }) {
      addBase({
        html: { fontSize: "13.5px" },
      });
    }),
  ],
};
