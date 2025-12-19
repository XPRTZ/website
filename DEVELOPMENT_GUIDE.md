# XPRTZ Websites Development Guide

## Quick Reference

This guide provides a quick overview of the codebase structure and common development tasks. For detailed information, see the AGENTS.md files in each directory.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                     Strapi CMS                          │
│              (Multi-tenant content)                     │
└─────────────────────────────────────────────────────────┘
                           │
                           │ API calls (fetchData)
                           ▼
┌─────────────────────────────────────────────────────────┐
│               @xprtz/cms (libs/cms)                     │
│         - TypeScript types for CMS content              │
│         - API wrapper (fetchData function)              │
│         - Multi-tenant & locale support                 │
└─────────────────────────────────────────────────────────┘
                           │
                           │ Import types
                           ▼
┌─────────────────────────────────────────────────────────┐
│                @xprtz/ui (libs/ui)                      │
│         - Reusable Astro/React components               │
│         - ComponentRenderer (dynamic rendering)         │
│         - Tailwind-styled components                    │
└─────────────────────────────────────────────────────────┘
                           │
                           │ Import components
                           ▼
        ┌──────────────────┴──────────────────┐
        ▼                                      ▼
┌──────────────────┐                  ┌──────────────────┐
│  @xprtz/dotnet   │                  │ @xprtz/learning  │
│  (apps/dotnet)   │                  │ (apps/learning)  │
│                  │                  │                  │
│  - xprtz.net     │                  │  - Learning app  │
│  - Pages & Blog  │                  │  - Tutorials     │
└──────────────────┘                  └──────────────────┘
```

## Key Concepts

### 1. Multi-Tenant System
Both apps share CMS and UI libraries but filter content by `PUBLIC_SITE`:
- `dotnet` app uses `PUBLIC_SITE="dotnet"`
- `learning` app uses `PUBLIC_SITE="learning"`

### 2. Component-Driven Architecture
CMS content includes a `__component` field that maps to UI components via `ComponentRenderer`:
```
CMS: { __component: "ui.hero", ... } → UI: Hero.astro
```

### 3. Static Site Generation
All pages are generated at build time using `getStaticPaths()` from CMS data.

## Common Development Tasks

### Task 1: Add a New UI Component

**Example: Adding a "Testimonial" component**

1. **Create CMS Type** (`libs/cms/models/testimonial.ts`)
   ```typescript
   import { Image } from "./image.js";

   export type Testimonial = {
     __component: "ui.testimonial";
     id: number;
     quote: string;
     author: string;
     title: string;
     avatar: Image;
   }
   ```

2. **Export from CMS** (`libs/cms/index.ts`)
   ```typescript
   import { Testimonial } from "./models/testimonial.js";
   export { type Testimonial };
   ```

3. **Create Astro Component** (`libs/ui/src/Testimonial.astro`)
   ```astro
   ---
   import { type Testimonial } from "@xprtz/cms";
   const testimonial = Astro.props as Testimonial;
   const site = import.meta.env.PUBLIC_IMAGES_URL;
   ---
   <div class="bg-white rounded-lg shadow-lg p-6">
     <blockquote class="text-lg italic text-gray-700">
       "{testimonial.quote}"
     </blockquote>
     <div class="mt-4 flex items-center">
       <img
         src={`${site}${testimonial.avatar.url}`}
         alt={testimonial.avatar.alternateText}
         class="w-12 h-12 rounded-full"
       />
       <div class="ml-3">
         <p class="font-semibold">{testimonial.author}</p>
         <p class="text-sm text-gray-600">{testimonial.title}</p>
       </div>
     </div>
   </div>
   ```

4. **Export from UI** (`libs/ui/index.ts`)
   ```typescript
   import Testimonial from "./src/Testimonial.astro";
   export { Testimonial };
   ```

5. **Register in ComponentRenderer** (`libs/ui/src/ComponentRenderer.astro`)
   ```typescript
   import Testimonial from "./Testimonial.astro";

   const componentMap: Record<string, any> = {
     // ... existing mappings
     "ui.testimonial": Testimonial,
   };
   ```

6. **Create in Strapi CMS**
   - Create component with identifier: `ui.testimonial`
   - Add fields: quote (text), author (text), title (text), avatar (media)
   - Add to page components zone

### Task 2: Add a New Page to Dotnet App

**Example: Adding a "Services" page**

1. **Create Page in Strapi**
   - Content Type: Page
   - Set slug: `services`
   - Set site: `dotnet`
   - Add components as needed

2. **Page is Automatically Generated**
   - The dynamic route `apps/dotnet/src/pages/[slug].astro` will generate it
   - Access at: `/services`

3. **Or Create Static Page** (`apps/dotnet/src/pages/services.astro`)
   ```astro
   ---
   import Layout from '../layouts/layout.astro';
   import { fetchData, type Page } from '@xprtz/cms';
   import { ComponentRenderer } from '@xprtz/ui';

   const site = import.meta.env.PUBLIC_SITE || "dotnet";

   const pages = await fetchData<Array<Page>>({
     endpoint: "pages",
     wrappedByKey: "data",
     wrappedByList: true,
     query: {
       "filters[slug][$eq]": "services",
       "filters[site][$eq]": site,
       "populate": "deep",
     },
   });

   const page = pages[0];
   ---

   <Layout title={page.title_website} description={page.description}>
     <ComponentRenderer components={page.components} />
   </Layout>
   ```

### Task 3: Update Existing Component

**Example: Adding a subtitle field to Hero**

1. **Update CMS Type** (`libs/cms/models/hero.ts`)
   ```typescript
   export type Hero = {
     __component: "ui.hero";
     id: number;
     title: string;
     subtitle: string;  // NEW FIELD
     description: string;
     CTO: Link;
     link: Link;
     images: Image[];
   }
   ```

2. **Update Component** (`libs/ui/src/Hero.astro`)
   ```astro
   <h1 class="text-4xl font-bold">{hero.title}</h1>
   <p class="text-xl text-gray-600">{hero.subtitle}</p>  // NEW
   <p class="text-lg text-gray-600">{hero.description}</p>
   ```

3. **Update Strapi**
   - Add `subtitle` field to Hero component in Strapi
   - Update existing content

### Task 4: Create a Custom Page Layout

**Example: Adding a two-column layout page**

1. **Create CMS Type** (`libs/cms/models/twoColumnPage.ts`)
   ```typescript
   export type TwoColumnPage = {
     __component: "ui.two-column-page";
     id: number;
     leftColumn: any[];   // Array of components
     rightColumn: any[];  // Array of components
   }
   ```

2. **Create Component** (`libs/ui/src/TwoColumnPage.astro`)
   ```astro
   ---
   import { type TwoColumnPage } from "@xprtz/cms";
   import ComponentRenderer from "./ComponentRenderer.astro";

   const data = Astro.props as TwoColumnPage;
   ---
   <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
     <div class="left-column">
       <ComponentRenderer components={data.leftColumn} />
     </div>
     <div class="right-column">
       <ComponentRenderer components={data.rightColumn} />
     </div>
   </div>
   ```

3. **Export and Register** (follow steps 2, 4, 5 from Task 1)

### Task 5: Fetch and Display Related Content

**Example: Showing related articles on article pages**

1. **Update Article Page** (`apps/dotnet/src/pages/artikelen/[article].astro`)
   ```astro
   ---
   const article: Article = Astro.props;

   // Fetch related articles by tags
   const relatedArticles = await fetchData<Array<Article>>({
     endpoint: "articles",
     wrappedByKey: "data",
     query: {
       "filters[site][$eq]": "dotnet",
       "filters[tags][name][$in]": article.tags.map(t => t.name).join(","),
       "filters[slug][$ne]": article.slug,  // Exclude current article
       "pagination[limit]": "3",
       status: "published",
     },
   });
   ---

   <Layout title={article.title}>
     <ContentAstro article={article} />

     <section class="mt-12">
       <h2>Related Articles</h2>
       <BlogListing articles={relatedArticles} />
     </section>
   </Layout>
   ```

## File Location Reference

| What | Where | Example |
|------|-------|---------|
| CMS Type Definition | `libs/cms/models/` | `libs/cms/models/hero.ts` |
| UI Component | `libs/ui/src/` | `libs/ui/src/Hero.astro` |
| App Page | `apps/dotnet/src/pages/` | `apps/dotnet/src/pages/index.astro` |
| App Layout | `apps/dotnet/src/layouts/` | `apps/dotnet/src/layouts/layout.astro` |
| Static Assets | `apps/dotnet/src/assets/` | `apps/dotnet/src/assets/logo.svg` |
| Public Files | `apps/dotnet/public/` | `apps/dotnet/public/favicon.ico` |

## Naming Conventions Quick Reference

| Type | Convention | Example |
|------|------------|---------|
| Astro Component | PascalCase.astro | `Hero.astro` |
| React Component | PascalCase.tsx | `Header.tsx` |
| TypeScript Type | PascalCase | `Hero`, `Article` |
| TypeScript File | camelCase.ts | `hero.ts`, `api.ts` |
| Function | camelCase | `fetchData`, `formatDate` |
| Constant | UPPER_SNAKE_CASE | `CAROUSEL_CONFIG` |
| CSS Class | kebab-case | `team-member`, `blog-card` |
| Component ID | ui.kebab-case | `ui.hero`, `ui.testimonial` |

## Environment Variables

### Development (.env files)

**apps/dotnet/.env**
```env
PUBLIC_SITE=dotnet
PUBLIC_STRAPI_URL=https://your-strapi-url.com
PUBLIC_IMAGES_URL=https://your-cdn-url.com
```

**apps/learning/.env**
```env
PUBLIC_SITE=learning
PUBLIC_STRAPI_URL=https://your-strapi-url.com
PUBLIC_IMAGES_URL=https://your-cdn-url.com
```

## Development Workflow

### Starting Development
```bash
# From root
npm run develop:dotnet    # Start dotnet app (http://localhost:3001)
npm run develop:learning  # Start learning app

# Or from specific app
cd apps/dotnet
npm run develop
```

### Making Changes

1. **Change in UI component?**
   - Edit file in `libs/ui/src/`
   - Changes are immediately reflected in both apps (no rebuild needed)

2. **Change in CMS type?**
   - Edit file in `libs/cms/models/`
   - Export from `libs/cms/index.ts`
   - Changes are immediately reflected (no rebuild needed)

3. **Change in app page?**
   - Edit file in `apps/dotnet/src/pages/`
   - Dev server will hot-reload

### Building for Production
```bash
# Build everything
npm run build

# Build specific app
npm run build:dotnet
npm run build:learning

# Type-check UI library
npm run build:ui
```

## Debugging Tips

### CMS Data Not Showing
1. Check `PUBLIC_SITE` environment variable
2. Verify Strapi content has correct `site` field
3. Check `status: "published"` in query
4. Use `populate: "deep"` to get all relations
5. Log the fetched data to console

### Component Not Rendering
1. Verify component is exported from `libs/ui/index.ts`
2. Check `__component` value matches `ComponentRenderer` mapping
3. Ensure Strapi component identifier matches exactly
4. Check browser console for errors

### TypeScript Errors
1. Run `npm run build:ui` to check UI types
2. Run `npm run build:dotnet` to check app types
3. Ensure imports use `.js` extensions
4. Verify types are exported from `libs/cms/index.ts`

### Styling Issues
1. Check Tailwind classes are spelled correctly
2. Verify custom classes are defined in component `<style>` blocks
3. Check responsive breakpoints (`sm:`, `lg:`, etc.)
4. Inspect element in browser DevTools

## Best Practices

### Do's ✅
- Always filter CMS queries by `PUBLIC_SITE`
- Use TypeScript types from `@xprtz/cms`
- Import components from `@xprtz/ui`
- Use Tailwind utility classes
- Use `ComponentRenderer` for CMS-driven content
- Include `alternateText` for images
- Handle empty/missing data gracefully
- Test in both dotnet and learning apps

### Don'ts ❌
- Don't hardcode content in components
- Don't skip type safety (use proper types)
- Don't create duplicate components
- Don't use inline styles (prefer Tailwind)
- Don't forget to export from index.ts files
- Don't skip accessibility attributes
- Don't forget to update ComponentRenderer mapping

## Quick Command Reference

```bash
# Development
npm run develop:dotnet           # Start dotnet dev server
npm run develop:learning         # Start learning dev server

# Building
npm run build                    # Build all workspaces
npm run build:dotnet            # Build dotnet app
npm run build:learning          # Build learning app
npm run build:ui                # Type-check UI library

# Code Quality
npm run format                   # Format and lint all files

# Individual app commands
cd apps/dotnet
npm run develop                  # Start dev server
npm run build                    # Build app
npm run preview                  # Preview production build
```

## Getting Help

1. Check the relevant AGENTS.md file:
   - [Root AGENTS.md](AGENTS.md) - Monorepo overview
   - [libs/ui/AGENTS.md](libs/ui/AGENTS.md) - UI components
   - [libs/cms/AGENTS.md](libs/cms/AGENTS.md) - CMS types and API
   - [apps/dotnet/AGENTS.md](apps/dotnet/AGENTS.md) - Dotnet app

2. Look at existing examples:
   - See how other components are structured
   - Check similar page implementations
   - Review ComponentRenderer mappings

3. Check the console and network tab for errors

4. Verify Strapi CMS content and schema

## Next Steps

Now that you understand the codebase structure:
1. Review the AGENTS.md files for detailed information
2. Explore existing components to understand patterns
3. Start with small changes to get familiar
4. When ready, follow the tasks above to add new features

Good luck! 🚀
