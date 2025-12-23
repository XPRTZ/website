# Dotnet App (@xprtz/dotnet) - Agent Context

## Overview
Main .NET-focused website for XPRTZ, built with Astro. Consumes content from Strapi CMS via the `@xprtz/cms` library and renders using components from the `@xprtz/ui` library.

## Package Information
- **Name**: `@xprtz/dotnet`
- **Site URL**: https://xprtz.net
- **Type**: `module`
- **Framework**: Astro 5.16+
- **Dev Port**: 3001

## Directory Structure

```
apps/dotnet/
├── src/
│   ├── layouts/         # Layout components
│   │   └── layout.astro
│   ├── pages/           # File-based routing
│   │   ├── index.astro          # Homepage
│   │   ├── [slug].astro         # Dynamic pages
│   │   ├── 404.astro            # Not found page
│   │   ├── artikelen/           # Blog section
│   │   │   ├── [article].astro      # Individual article
│   │   │   └── page/
│   │   │       └── [page].astro     # Paginated article list
│   │   └── expertise/           # Technology expertise radar
│   │       ├── [radarItem].astro    # Individual radar item
│   │       └── page/
│   │           └── [page].astro     # Radar overview page
│   ├── env.d.ts         # Environment type definitions
│   └── assets/          # Static assets (images, etc.)
├── public/              # Public static files
├── .astro/              # Astro generated files
├── astro.config.mjs     # Astro configuration
├── tsconfig.json        # TypeScript configuration
├── tailwind.config.mjs  # Tailwind configuration
├── package.json         # Package configuration
└── AGENTS.md           # This file
```

## Environment Configuration

### Required Environment Variables
- `PUBLIC_SITE="dotnet"` - Site identifier for multi-tenant CMS
- `PUBLIC_STRAPI_URL` - Strapi CMS API base URL
- `PUBLIC_IMAGES_URL` - Image CDN base URL

### Usage
Create a `.env` file in the app root:
```env
PUBLIC_SITE=dotnet
PUBLIC_STRAPI_URL=https://cms.example.com
PUBLIC_IMAGES_URL=https://cdn.example.com
```

## Development Scripts

```bash
npm run develop   # Start dev server on port 3001
npm run start     # Alternative dev server command
npm run build     # Type-check and build for production
npm run preview   # Preview production build
```

## Dependencies

### Core Dependencies
- `astro` - Astro framework
- `@astrojs/tailwind` - Tailwind CSS integration
- `@astrojs/sitemap` - Sitemap generation
- `@astrojs/react` - React integration for interactive components
- `@xprtz/ui` - Shared UI component library (workspace)
- `@xprtz/cms` - CMS types and API utilities (workspace)

### UI Dependencies
- `react` + `react-dom` - React library
- `@headlessui/react` - Accessible UI components
- `@heroicons/react` - Icon library
- `tailwindcss` - CSS framework
- `@tailwindcss/typography` - Typography plugin

### Utilities
- `remove-markdown` - Strip markdown formatting (for excerpts)

## Astro Configuration

File: [astro.config.mjs](astro.config.mjs)

```javascript
export default defineConfig({
  site: "https://xprtz.net",
  integrations: [
    tailwind(),
    sitemap(),
    react()
  ],
});
```

### Key Settings
- **Site URL**: Used for sitemap generation and canonical URLs
- **Integrations**: Tailwind, Sitemap, and React support
- **Output**: Static site generation (SSG)

## Routing Structure

### File-Based Routing

#### Static Routes
- `/` → [pages/index.astro](src/pages/index.astro) - Homepage
- `/404` → [pages/404.astro](src/pages/404.astro) - Not found page

#### Dynamic Routes
- `/{slug}` → [pages/[slug].astro](src/pages/[slug].astro) - Generic pages
- `/artikelen/{article}` → [pages/artikelen/[article].astro](src/pages/artikelen/[article].astro) - Individual articles
- `/artikelen/page/{page}` → [pages/artikelen/page/[page].astro](src/pages/artikelen/page/[page].astro) - Paginated article list
- `/expertise/{radarItem}` → [pages/expertise/[radarItem].astro](src/pages/expertise/[radarItem].astro) - Individual radar items
- `/expertise/page/{page}` → [pages/expertise/page/[page].astro](src/pages/expertise/page/[page].astro) - Radar overview page

### Static Path Generation

All dynamic routes use `getStaticPaths()` to generate paths at build time:

```typescript
export async function getStaticPaths() {
  const site = import.meta.env.PUBLIC_SITE || "dotnet";

  const pageData = await fetchData<Array<Page>>({
    endpoint: "pages",
    wrappedByKey: "data",
    query: {
      "filters[site][$eq]": site,
      status: "published",
      "populate": "deep",
    },
  });

  return pageData.map((data) => ({
    params: { slug: data.slug },
    props: data,
  }));
}
```

## Layout Pattern

File: [src/layouts/layout.astro](src/layouts/layout.astro)

```astro
---
import { BaseHead, Footer, Header } from '@xprtz/ui';
import Logo from '../assets/logo.svg';

interface Props {
  title: string;
  description: string;
}

const { title, description } = Astro.props;
---
<html lang="nl">
  <head>
    <BaseHead title={title} description={description} />
  </head>
  <body>
    <Header Logo={Logo.src} client:load />
    <main class="isolate">
      <slot />
    </main>
    <Footer />
  </body>
</html>
```

### Layout Usage
```astro
<Layout title={page.title_website} description={page.description}>
  <!-- Page content -->
</Layout>
```

## Page Patterns

### Homepage Pattern

File: [src/pages/index.astro](src/pages/index.astro)

```astro
---
import Layout from '../layouts/layout.astro';
import { fetchData, type HomePage } from '@xprtz/cms';
import { ComponentRenderer } from '@xprtz/ui';

const site = import.meta.env.PUBLIC_SITE || "dotnet";

const homepages = await fetchData<Array<HomePage>>({
  endpoint: "home-page",
  wrappedByKey: "data",
  query: {
    "filters[site][$eq]": site,
    "populate": "deep",
  },
});

const homepage = homepages[0];
---

<Layout title="XPRTZ .NET" description="...">
  <ComponentRenderer components={homepage.components} />
</Layout>
```

### Dynamic Page Pattern

File: [src/pages/[slug].astro](src/pages/[slug].astro)

```astro
---
export async function getStaticPaths() {
  const pageData = await fetchData<Array<Page>>({
    endpoint: "pages",
    wrappedByKey: "data",
    query: {
      "filters[site][$eq]": "dotnet",
      status: "published",
      "populate": "deep",
    },
  });

  return pageData.map((data) => ({
    params: { slug: data.slug },
    props: data,
  }));
}

const page: Page = Astro.props;
---

<Layout title={page.title_website} description={page.description}>
  <Page page={page} />
</Layout>
```

### Article Pattern

File: [src/pages/artikelen/[article].astro](src/pages/artikelen/[article].astro)

```astro
---
import { ContentAstro } from '@xprtz/ui';

export async function getStaticPaths() {
  const articles = await fetchData<Array<Article>>({
    endpoint: "articles",
    wrappedByKey: "data",
    query: {
      "filters[site][$eq]": "dotnet",
      "sort[0]": "date:desc",
      "populate[authors][fields]": "*",
      "populate[image][fields][0]": "url",
      "populate[tags][fields][0]": "name",
      status: "published",
    },
  });

  return articles.map((article) => ({
    params: { article: article.slug },
    props: article,
  }));
}

const article: Article = Astro.props;
---

<Layout title={article.title} description={article.description}>
  <ContentAstro article={article} />
</Layout>
```

### Radar Item Pattern

File: [src/pages/expertise/[radarItem].astro](src/pages/expertise/[radarItem].astro)

```astro
---
import { fetchData, type RadarItem } from '@xprtz/cms';

export async function getStaticPaths() {
  const radarItems = await fetchData<Array<RadarItem>>({
    endpoint: "radar-items",
    wrappedByKey: "data",
    query: {
      "populate[pros]": "*",
      "populate[cons]": "*",
      "populate[tags][fields][0]": "title",
      status: "published",
    },
  });

  return radarItems.map((item) => ({
    params: { radarItem: item.slug },
    props: item,
  }));
}

const radarItem: RadarItem = Astro.props;
---

<Layout title={radarItem.title} description={radarItem.description}>
  <!-- Radar item content -->
</Layout>
```

### Radar Overview Pattern

File: [src/pages/expertise/page/[page].astro](src/pages/expertise/page/[page].astro)

```astro
---
import { fetchData, type RadarItem, type Page as PageType } from '@xprtz/cms';
import { RadarChart } from '@xprtz/ui';

export const getStaticPaths = async () => {
  return [{ params: { page: "1" } }];
};

const radarItems = await fetchData<Array<RadarItem>>({
  endpoint: "radar-items",
  wrappedByKey: "data",
  query: {
    "populate[tags][fields][0]": "title",
    status: "published",
  },
});
---

<Layout title="Expertise" description="...">
  <RadarChart items={radarItems} />
</Layout>
```

### Pagination Pattern

File: [src/pages/artikelen/page/[page].astro](src/pages/artikelen/page/[page].astro)

```astro
---
export async function getStaticPaths({ paginate }) {
  const articles = await fetchData<Array<Article>>({
    endpoint: "articles",
    wrappedByKey: "data",
    query: {
      "filters[site][$eq]": "dotnet",
      "sort[0]": "date:desc",
      status: "published",
    },
  });

  return paginate(articles, { pageSize: 10 });
}

const { page } = Astro.props;
---

<Layout title="Artikelen" description="...">
  <BlogListing articles={page.data} />
  <!-- Pagination controls -->
</Layout>
```

## Content Fetching Patterns

### Fetch Homepage
```typescript
const homepages = await fetchData<Array<HomePage>>({
  endpoint: "home-page",
  wrappedByKey: "data",
  query: {
    "filters[site][$eq]": "dotnet",
    "populate": "deep",
  },
});
```

### Fetch Pages
```typescript
const pages = await fetchData<Array<Page>>({
  endpoint: "pages",
  wrappedByKey: "data",
  query: {
    "filters[site][$eq]": "dotnet",
    "filters[slug][$eq]": slug,
    status: "published",
    "populate": "deep",
  },
});
```

### Fetch Articles
```typescript
const articles = await fetchData<Array<Article>>({
  endpoint: "articles",
  wrappedByKey: "data",
  query: {
    "filters[site][$eq]": "dotnet",
    "sort[0]": "date:desc",
    "populate[authors][fields]": "*",
    "populate[authors][populate][avatar][fields][0]": "url",
    "populate[image][fields][0]": "url",
    "populate[tags][fields][0]": "name",
    status: "published",
  },
});
```

### Fetch Radar Items
```typescript
const radarItems = await fetchData<Array<RadarItem>>({
  endpoint: "radar-items",
  wrappedByKey: "data",
  query: {
    "populate[pros]": "*",
    "populate[cons]": "*",
    "populate[tags][fields][0]": "title",
    status: "published",
  },
});
```

### Fetch Global Settings
```typescript
const settings = await fetchData<GlobalSettings>({
  endpoint: "global-settings",
  wrappedByKey: "data",
  wrappedByList: true,
  query: {
    "filters[site][$eq]": "dotnet",
    "populate": "deep",
  },
});
```

## Styling

### Tailwind Configuration
File: `tailwind.config.mjs`

The app uses Tailwind CSS with:
- Typography plugin for rich text content
- Custom color palette (primary-* colors)
- Responsive breakpoints
- Custom component classes

### Theme Colors
The design uses a `primary-*` color scale:
- Text: `text-primary-800`, `text-primary-900`
- Backgrounds: `bg-primary-600`, `bg-primary-100`
- Borders: `border-primary-500`

### Component Classes
Tailwind utilities are preferred over custom CSS.

## SEO & Meta Tags

### BaseHead Component
All pages use the [BaseHead](../../libs/ui/src/BaseHead.astro) component from `@xprtz/ui`:

```astro
<BaseHead
  title={page.title_website}
  description={page.description}
/>
```

### Sitemap
Generated automatically via `@astrojs/sitemap` using the site URL from `astro.config.mjs`.

## Static Assets

### Images
- Logo: Stored in `src/assets/`
- CMS Images: Fetched from `PUBLIC_IMAGES_URL`
- Pattern: `${import.meta.env.PUBLIC_IMAGES_URL}${image.url}`

### Public Files
Static files in `public/` are served at the root:
- Favicons
- robots.txt
- Other static resources

## Build Process

### Type Checking
```bash
npm run build  # Runs astro check && astro build
```

### Output
- Static HTML files
- Optimized assets
- Generated sitemap
- Client-side JavaScript bundles (minimal due to Astro islands)

## Common Patterns

### Import Pattern
```astro
---
import Layout from '../layouts/layout.astro';
import { fetchData, type Page, type Article } from '@xprtz/cms';
import { ComponentRenderer, BlogListing } from '@xprtz/ui';
---
```

### Error Handling
```astro
---
const pages = await fetchData<Array<Page>>({ ... });
if (!pages || pages.length === 0) {
  return Astro.redirect('/404');
}
---
```

### Environment Access
```astro
---
const site = import.meta.env.PUBLIC_SITE || "dotnet";
const imagesUrl = import.meta.env.PUBLIC_IMAGES_URL;
---
```

## Adding New Pages

### Static Page
1. Create `src/pages/new-page.astro`
2. Import layout and components
3. Fetch data if needed
4. Render content

### Dynamic Page
1. Create `src/pages/[param].astro`
2. Implement `getStaticPaths()`
3. Fetch data from CMS
4. Map to routes
5. Use props in component

## Development Guidelines

### Do NOT:
- Hardcode content (use CMS)
- Skip multi-tenant filtering (`filters[site][$eq]`)
- Use inline styles (prefer Tailwind)
- Create components here (use `@xprtz/ui`)
- Bypass the layout system

### DO:
- Always filter by `PUBLIC_SITE`
- Use `getStaticPaths()` for dynamic routes
- Import components from `@xprtz/ui`
- Use types from `@xprtz/cms`
- Follow the layout pattern
- Use `ComponentRenderer` for CMS-driven pages
- Include proper meta tags
- Handle 404 cases

## Testing

### Local Development
```bash
npm run develop  # Start dev server
# Visit http://localhost:3001
```

### Preview Production Build
```bash
npm run build
npm run preview
```

### Checklist
- [ ] All dynamic routes generate correctly
- [ ] Images load from CDN
- [ ] Multi-tenant filtering works
- [ ] SEO meta tags present
- [ ] Responsive on all breakpoints
- [ ] Accessibility validated
- [ ] Sitemap generated
- [ ] 404 page works

## Deployment

The app outputs static HTML that can be deployed to any static hosting:
- Vercel
- Netlify
- AWS S3 + CloudFront
- Azure Static Web Apps
- GitHub Pages

Ensure environment variables are set in the deployment environment.

## Important Notes

This app is part of a multi-tenant system. Always ensure:
1. `PUBLIC_SITE="dotnet"` is set
2. All CMS queries filter by site
3. Content is isolated from the `learning` app
4. Shared components work across both apps
