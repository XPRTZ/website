/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}",
    "./../../libs/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: "#f0f9ff",
          100: "#dff2ff",
          200: "#b9e6fe",
          300: "#7bd4fe",
          400: "#34befc",
          500: "#0aa7ed",
          600: "#0085cb",
          700: "#00649b",
          800: "#055a87",
          900: "#0a4a70",
          950: "#072f4a",
        },
      },
    },
  },
  plugins: [],
};
