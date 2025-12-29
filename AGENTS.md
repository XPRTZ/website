# XPRTZ Websites Monorepo - Agent Context

## Project Overview
This is a monorepo for XPRTZ websites built with Astro, consuming content from a Strapi CMS. It uses npm workspaces to manage multiple applications and shared libraries.

## Monorepo Structure

```
/website
├── apps/
│   ├── dotnet/          # Main .NET-focused website (xprtz.net)
│   └── learning/        # Learning platform for polyglot programming
├── libs/
│   ├── ui/              # Shared Astro/React UI components
│   └── cms/             # TypeScript types and API wrapper for Strapi
├── infrastructure/      # Infrastructure configuration
└── package.json         # Root workspace configuration
```

## Workspace Configuration

### npm Workspaces
The monorepo uses npm workspaces defined in the root [package.json](package.json):

```json
"workspaces": [
  "apps/dotnet",
  "apps/learning",
  "libs/ui",
  "libs/cms"
]
```

### Package Naming Convention
- Apps: `@xprtz/dotnet`, `@xprtz/learning`
- Libraries: `@xprtz/ui`, `@xprtz/cms`

### Dependency Pattern
Both apps depend on shared libraries using local file references:
```json
"dependencies": {
  "@xprtz/ui": "file:../../libs/ui",
  "@xprtz/cms": "file:../../libs/cms"
}
```

## Technology Stack

### Core Technologies
- **Astro 5.16+** - Static site generator with islands architecture
- **React 18.3+** - Client-side interactivity
- **TypeScript 5.4+** - Type safety across the monorepo
- **Tailwind CSS 3.4+** - Utility-first CSS framework
- **Strapi CMS** - Headless CMS for content management

### Key Dependencies
- `@astrojs/tailwind` - Tailwind integration
- `@astrojs/react` - React integration for interactive components
- `@astrojs/sitemap` - Sitemap generation
- `@headlessui/react` - Unstyled, accessible UI components
- `@heroicons/react` - Icon library
- `embla-carousel` - Carousel/slider library
- `marked` - Markdown parser

## File Naming Conventions

### General Rules
- **Astro components**: `PascalCase.astro` (e.g., `Hero.astro`, `Footer.astro`)
- **React components**: `PascalCase.tsx` (e.g., `Header.tsx`)
- **TypeScript files**: `camelCase.ts` (e.g., `api.ts`, `page.ts`)
- **Configuration files**: Standard names (`package.json`, `astro.config.mjs`, `tsconfig.json`)

### Specific Conventions
- CMS models: `camelCase.ts` in `libs/cms/models/`
- Page components: File-based routing in `apps/*/src/pages/`
- Layout files: `camelCase.astro` in `apps/*/src/layouts/`
- Dynamic routes: `[param].astro` or `[...slug].astro`

## Multi-Tenant Architecture

The system supports multiple sites using the `PUBLIC_SITE` environment variable:

### Site Identifiers
- `"dotnet"` - Main .NET-focused website (xprtz.net)
- `"learning"` - Learning platform for polyglot programming

### Content Filtering
All CMS queries filter content by site:
```typescript
query: {
  "filters[site][$eq]": import.meta.env.PUBLIC_SITE,
  status: "published"
}
```

## Environment Variables

### Required Variables
- `PUBLIC_SITE` - Site identifier ("dotnet" or "learning")
- `PUBLIC_STRAPI_URL` - Strapi CMS API base URL
- `PUBLIC_IMAGES_URL` - Image CDN base URL

### Usage Pattern
```typescript
const site = import.meta.env.PUBLIC_SITE || "no-site-found";
const imagesUrl = import.meta.env.PUBLIC_IMAGES_URL;
```

## Development Scripts

### Root Level Commands
```bash
npm run develop:dotnet      # Start dotnet app dev server (port 3001)
npm run develop:learning    # Start learning app dev server
npm run build               # Build all workspaces
npm run build:dotnet        # Build dotnet app only
npm run build:learning      # Build learning app only
npm run build:ui            # Type-check UI library
npm run format              # Format and lint all files
```

### Individual Workspace Commands
```bash
cd apps/dotnet
npm run develop             # Start dev server
npm run build               # Type-check and build
npm run preview             # Preview production build
```

## TypeScript Configuration

### Root tsconfig.json
Provides shared TypeScript configuration for all workspaces with strict mode enabled.

### Import Path Conventions
- Use `.js` extensions in imports (TypeScript ESM requirement)
- Type-only imports: `import { type Hero } from "@xprtz/cms"`
- Component imports: `import { ComponentRenderer } from "@xprtz/ui"`

## Coding Standards

### Code Style
- Prettier for formatting (config in [.prettierrc.json](.prettierrc.json))
- ESLint for linting (config in [eslint.config.mjs](eslint.config.mjs))
- TypeScript strict mode enabled

### Import Organization
1. External dependencies
2. Workspace packages (`@xprtz/*`)
3. Relative imports

### Naming Conventions
- **Functions**: `camelCase` (e.g., `fetchData`, `formatDate`)
- **Types**: `PascalCase` (e.g., `Hero`, `Article`, `Page`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `CAROUSEL_CONFIG`)
- **CSS classes**: Tailwind utilities + custom kebab-case

## Git Workflow

### Recent Activity
- Current branch: `main`
- Recent commits focus on Astro upgrades and feature additions
- Deleted `pnpm-lock.yaml` (using npm instead of pnpm)

## Astro-Specific Configuration

### Hot Module Replacement (HMR) for Workspace Dependencies
The Astro dev server may not properly hot-reload CSS changes from workspace dependencies (`@xprtz/ui`, `@xprtz/cms`). This has been resolved by configuring Vite in each app's `astro.config.mjs`:

```js
export default defineConfig({
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
})
```

This configuration ensures that changes to UI library files trigger proper hot reloads without requiring dev server restarts.

## Important Notes

### When Adding New Features
1. UI components go in `libs/ui/src/`
2. CMS models go in `libs/cms/models/`
3. Export new components/types from respective `index.ts` files
4. Register new UI components in `ComponentRenderer.astro` if they're CMS-driven
5. Follow existing patterns for file naming and code structure

### When Adding New Content Types
1. Create type definition in `libs/cms/models/`
2. Export from `libs/cms/index.ts`
3. Create corresponding Astro component in `libs/ui/src/`
4. Export from `libs/ui/index.ts`
5. Add to `ComponentRenderer.astro` mapping if applicable
6. Ensure Strapi CMS has matching content type

### Development Workflow
1. Start with understanding the CMS model structure
2. Create or update TypeScript types in `libs/cms`
3. Create or update UI components in `libs/ui`
4. Use components in apps via `ComponentRenderer` or direct imports
5. Test with both dotnet and learning sites to ensure multi-tenant compatibility
