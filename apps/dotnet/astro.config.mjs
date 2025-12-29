import { defineConfig } from "astro/config";
import tailwind from "@astrojs/tailwind";
import sitemap from "@astrojs/sitemap";
import react from "@astrojs/react";

export default defineConfig({
  site: "https://xprtz.net",
  integrations: [tailwind(), sitemap(), react()],
  vite: {
    server: {
      watch: {
        // Force Vite to watch workspace dependencies
        ignored: ['!**/node_modules/@xprtz/ui/**']
      }
    },
    optimizeDeps: {
      // Prevent pre-bundling of workspace dependencies
      exclude: ['@xprtz/ui']
    }
  }
});

