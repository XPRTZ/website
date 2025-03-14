import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import mdx from '@astrojs/mdx';

export default defineConfig({
  experimental: {
    svg: true
  },
  integrations: [tailwind(), mdx({
    components: {
      'Collapsible': './src/components/Collapsible.astro'
    }})],
});
