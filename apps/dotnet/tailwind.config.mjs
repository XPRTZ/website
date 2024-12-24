/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}",
    "./../../libs/ui/src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: "#f5faf3",
          100: "#e7f4e4",
          200: "#d1e7cb",
          300: "#abd4a1",
          400: "#7fb870",
          500: "#5e9e4e",
          600: "#487e3b",
          700: "#3b6431",
          800: "#32502b",
          900: "#2a4324",
          950: "#132310",
        },
      },
    },
  },
  plugins: [],
};
