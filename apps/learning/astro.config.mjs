import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import mdx from '@astrojs/mdx';

export default defineConfig({
  integrations: [tailwind(), mdx({
    components: {
      'Collapsible': './src/components/Collapsible.astro'
    }})],
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
