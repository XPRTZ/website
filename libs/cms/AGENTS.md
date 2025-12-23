# CMS Library (@xprtz/cms) - Agent Context

## Overview
TypeScript type definitions and API wrapper for Strapi CMS integration. This library provides type-safe access to CMS content and defines the data models used throughout the XPRTZ applications.

## Package Information
- **Name**: `@xprtz/cms`
- **Type**: `module`
- **Main entry**: [index.ts](index.ts)
- **Purpose**: Type definitions and API utilities for Strapi CMS

## Directory Structure

```
libs/cms/
├── models/           # TypeScript type definitions
│   ├── *.ts         # Individual model files
├── wrapper/         # API integration utilities
│   └── api.ts       # Strapi API fetch wrapper
├── index.ts         # Main export file
├── env.d.ts         # Environment type definitions
└── package.json     # Package configuration
```

## Core Concepts

### Strapi Integration
This library connects to a Strapi CMS instance and provides:
1. **Type definitions** matching Strapi content types
2. **API wrapper** for fetching data with proper typing
3. **Multi-tenant support** via site filtering
4. **Locale support** for internationalization

### Component Identifiers
All CMS components include a `__component` field for dynamic rendering:

```typescript
export type Hero = {
  __component: "ui.hero";  // Unique identifier
  id: number;
  // ... other fields
};
```

This identifier maps to UI components in `ComponentRenderer.astro`.

## Model Categories

### Core Content Models

#### [page.ts](models/page.ts)
Generic page content with dynamic components:
```typescript
export type Page = {
  title_website: string;    // SEO title
  title_cms: string;        // CMS display title
  description: string;      // Meta description
  site: string;            // Multi-tenant identifier
  locale: string;          // Language/locale
  documentId: string;      // Strapi document ID
  slug: string;            // URL slug
  tagline: string;         // Page tagline
  components: any[];       // Dynamic content blocks
}
```

#### [article.ts](models/article.ts)
Blog post/article content:
```typescript
export type Article = {
  title: string;
  content: string;         // Markdown content
  authors: Author[];
  date: string;           // ISO date string
  slug: string;
  image: Image;
  tags: Tag[];
  site: string;
  locale: string;
  documentId: string;
}
```

#### [homePage.ts](models/homePage.ts)
Homepage-specific content:
```typescript
export type HomePage = {
  site: string;
  components: any[];      // Dynamic homepage components
}
```

### Component Models

#### [hero.ts](models/hero.ts)
Hero section with images and CTAs:
```typescript
export type Hero = {
  __component: "ui.hero";
  id: number;
  title: string;
  description: string;
  CTO: Link;              // Primary call-to-action
  link: Link;             // Secondary link
  images: Image[];        // Gallery images
}
```

#### [mission.ts](models/mission.ts)
Mission statement with statistics:
```typescript
export type Mission = {
  __component: "ui.missie-met-statistieken";
  title: string;
  description: string;
  extraDescription: string;
  statistieken: ListItem[];
}
```

#### [kernwaarden.ts](models/kernwaarden.ts)
Core values/principles:
```typescript
export type Kernwaarden = {
  __component: "ui.kernwaarden";
  id: number;
  title: string;
  values: ListItemWithImage[];
}
```

### Team & People Models

#### [author.ts](models/author.ts)
Author/team member information:
```typescript
export type Author = {
  name: string;
  title: string;
  image: string;          // Avatar URL
  socials: Social[];
}
```

#### [team.ts](models/team.ts)
Team section with members:
```typescript
export type Team = {
  title: string;
  description: string;
  members: Author[];
}
```

#### [directors.ts](models/directors.ts)
Directors/leadership:
```typescript
export type Directors = {
  __component: "ui.directeuren";
  members: Author[];
}
```

### Media Models

#### [image.ts](models/image.ts)
Basic image with alt text:
```typescript
export type Image = {
  url: string;
  alternateText: string;
}
```

#### [imageWithTitle.ts](models/imageWithTitle.ts)
Image with title overlay:
```typescript
export type ImageWithTitle = {
  image: Image;
  title: string;
}
```

#### [imageComponent.ts](models/imageComponent.ts)
Full image component for CMS:
```typescript
export type ImageComponent = {
  __component: "ui.image";
  image: Image;
}
```

### Utility Models

#### [link.ts](models/link.ts)
Link/button component:
```typescript
export type Link = {
  title: string;
  variant: string;        // Button style variant
  page: Page;            // Linked page
}
```

#### [listItem.ts](models/listItem.ts)
List item with title and description:
```typescript
export type ListItem = {
  title: string;
  description: string;
}
```

#### [listItemWithImage.ts](models/listItemWithImage.ts)
List item with image:
```typescript
export type ListItemWithImage = {
  title: string;
  description: string;
  image: Image;
}
```

#### [tag.ts](models/tag.ts)
Content tag/category:
```typescript
export type Tag = {
  name: string;
}
```

#### [social.ts](models/social.ts)
Social media links:
```typescript
export type Social = {
  platform: string;
  url: string;
  icon: string;
}
```

### Special Models

#### [logoCloud.ts](models/logoCloud.ts)
Client/partner logo display:
```typescript
export type LogoCloud = {
  __component: "ui.klant-logo-s";
  title: string;
  logos: Image[];
}
```

#### [globalSettings.ts](models/globalSettings.ts)
Site-wide settings:
```typescript
export type GlobalSettings = {
  site: string;
  siteName: string;
  siteDescription: string;
  logo: Image;
  socialMedia: Social[];
  footerLinks: Link[];
  algemeneVoorwaarden: AlgemeneVoorwaarden;
}
```

#### [algemeneVoorwaarden.ts](models/algemeneVoorwaarden.ts)
Terms and conditions:
```typescript
export type AlgemeneVoorwaarden = {
  content: string;
}
```

### Technology Radar Models

#### [radarItem.ts](models/radarItem.ts)
Technology radar items with adoption stages:
```typescript
export type RadarQuadrant = "Techniques" | "Tools" | "Platforms" | "Languages & Frameworks";
export type RadarRing = "Adopt" | "Trial" | "Assess" | "Hold";

export type RadarItem = {
  slug: string;
  quadrant: RadarQuadrant;
  ring: RadarRing;
  title: string;
  description: string;
  pros: ListItem[];
  cons: ListItem[];
  conclusion: string;
  tags: Tag[];
}

export type RadarItemWithNumber = RadarItem & {
  number: number;
}
```

**Important Notes:**
- `RadarItem` represents the base type from CMS without numbers
- `RadarItemWithNumber` extends `RadarItem` with a `number` property added during rendering
- Numbers are assigned sequentially by the UI layer, not stored in CMS
- Use `RadarItem` when fetching from CMS
- Use `RadarItemWithNumber` when passing items to UI components that need numbering

## API Wrapper

### fetchData Function

Located in [wrapper/api.ts](wrapper/api.ts), this is the primary method for fetching data from Strapi:

```typescript
interface Props {
  endpoint: string;                    // Strapi endpoint (e.g., "articles", "pages")
  query?: Record<string, string>;      // Query parameters
  wrappedByKey?: string;               // Extract data from response key
  wrappedByList?: boolean;             // Extract first element from array
}

export default async function fetchData<T>({
  endpoint,
  query,
  wrappedByKey,
  wrappedByList,
}: Props): Promise<T>
```

### Usage Examples

#### Fetch Articles
```typescript
import { fetchData, type Article } from "@xprtz/cms";

const articles = await fetchData<Array<Article>>({
  endpoint: "articles",
  wrappedByKey: "data",
  query: {
    "sort[0]": "date:desc",
    "filters[site][$eq]": "dotnet",
    "populate[authors][fields]": "*",
    "populate[authors][populate][avatar][fields][0]": "url",
    "populate[image][fields][0]": "url",
    "populate[tags][fields][0]": "name",
    status: "published",
  },
});
```

#### Fetch Single Page
```typescript
const page = await fetchData<Page>({
  endpoint: "pages",
  wrappedByKey: "data",
  wrappedByList: true,
  query: {
    "filters[slug][$eq]": pageSlug,
    "filters[site][$eq]": "dotnet",
    "populate": "deep",
  },
});
```

#### Fetch Homepage
```typescript
const homepage = await fetchData<HomePage>({
  endpoint: "home-page",
  wrappedByKey: "data",
  query: {
    "filters[site][$eq]": "dotnet",
    "populate": "deep",
  },
});
```

## Strapi Query Syntax

### Filtering
```typescript
"filters[field][$eq]": "value"          // Equals
"filters[field][$ne]": "value"          // Not equals
"filters[field][$in]": "value1,value2"  // In array
"filters[site][$eq]": "dotnet"          // Multi-tenant filter
```

### Sorting
```typescript
"sort[0]": "date:desc"                  // Sort by date descending
"sort[0]": "title:asc"                  // Sort by title ascending
```

### Population (Relations)
```typescript
"populate": "deep"                               // Deep populate all relations
"populate[authors][fields]": "*"                 // Populate authors with all fields
"populate[authors][populate][avatar]": "url"     // Nested population
"populate[image][fields][0]": "url"             // Populate specific field
```

### Status
```typescript
status: "published"                              // Only published content
status: "draft"                                  // Only drafts
```

## Export Pattern

All types and utilities are exported from [index.ts](index.ts):

```typescript
import { Page } from "./models/page.js";
import { Article } from "./models/article.js";
import fetchData from "./wrapper/api.js";

export {
  fetchData,
  type Page,
  type Article,
  type Hero,
  // ... all other types
};
```

### Import Usage in Apps
```typescript
import { fetchData, type Page, type Article } from "@xprtz/cms";
```

## Multi-Tenant Support

### Site Identifier
Content is filtered by the `site` field:

```typescript
query: {
  "filters[site][$eq]": import.meta.env.PUBLIC_SITE,
}
```

### Supported Sites
- `"dotnet"` - Main .NET website
- `"learning"` - Learning platform

### Usage in Queries
Always include site filter to ensure content isolation:

```typescript
const articles = await fetchData<Array<Article>>({
  endpoint: "articles",
  query: {
    "filters[site][$eq]": "dotnet",  // Required for multi-tenant
    status: "published",
  },
});
```

## Locale Support

Content supports internationalization via the `locale` field:

```typescript
export type Page = {
  locale: string;  // e.g., "en", "nl"
  // ... other fields
}
```

Query by locale:
```typescript
query: {
  "filters[locale][$eq]": "nl",
}
```

## Environment Variables

### Required Variables
- `PUBLIC_STRAPI_URL` - Strapi CMS API base URL

### Usage
The `fetchData` function automatically uses:
```typescript
const url = `${import.meta.env.PUBLIC_STRAPI_URL}/api/${endpoint}`;
```

## Adding New Models

### Step-by-Step Process

1. **Create Model File**
   ```typescript
   // libs/cms/models/newModel.ts
   import { Image } from "./image.js";

   export type NewModel = {
     __component: "ui.new-model";  // If it's a component
     id: number;
     title: string;
     description: string;
     images: Image[];
   }
   ```

2. **Export from index.ts**
   ```typescript
   import { NewModel } from "./models/newModel.js";

   export {
     // ... existing exports
     type NewModel,
   };
   ```

3. **Create Matching Strapi Content Type**
   - Component identifier: `ui.new-model`
   - Fields must match TypeScript definition
   - Include `site` field for multi-tenant support
   - Include `locale` field for i18n support

4. **Use in Application**
   ```typescript
   import { fetchData, type NewModel } from "@xprtz/cms";

   const data = await fetchData<NewModel>({ ... });
   ```

## Model Design Guidelines

### Type Safety
- Use explicit types, avoid `any` except for `components: any[]`
- Import and compose related types
- Use TypeScript's type system features

### Naming Conventions
- **Files**: `camelCase.ts` (e.g., `heroSection.ts`)
- **Types**: `PascalCase` (e.g., `HeroSection`)
- **Fields**: `camelCase` (e.g., `titleWebsite`)

### Component Identifiers
- Format: `"ui.component-name"` (kebab-case)
- Must match Strapi component identifier exactly
- Used by ComponentRenderer for dynamic rendering

### Composition
Prefer composition over duplication:

```typescript
// Good
import { Image } from "./image.js";
import { Link } from "./link.js";

export type Hero = {
  images: Image[];
  link: Link;
}

// Avoid
export type Hero = {
  images: { url: string; alt: string }[];  // Duplicating Image type
}
```

### Required Fields
Most content types should include:
- `site: string` - For multi-tenant filtering
- `locale: string` - For internationalization
- `documentId: string` - Strapi document identifier

Components should include:
- `__component: string` - For dynamic rendering
- `id: number` - Unique identifier

## Common Patterns

### Content with Components
```typescript
export type Page = {
  // ... metadata
  components: any[];  // Dynamic components
}
```

### Relations
```typescript
export type Article = {
  authors: Author[];  // One-to-many
  image: Image;       // One-to-one
}
```

### Optional Fields
Use TypeScript optional properties:
```typescript
export type Author = {
  name: string;
  bio?: string;        // Optional field
  socials?: Social[];  // Optional array
}
```

## Testing

### Type Checking
```bash
npm run build  # Runs tsc
```

### Validation
- Ensure types match Strapi schema exactly
- Test queries with different filters
- Verify multi-tenant filtering works
- Check population depth

## Important Notes

### Do NOT:
- Use `any` for known types
- Skip the `__component` field for components
- Forget multi-tenant `site` field
- Hardcode endpoint URLs
- Create circular dependencies

### DO:
- Match Strapi schema exactly
- Use composition for reusable types
- Include proper JSDoc comments for complex types
- Export all types from index.ts
- Use `.js` extensions in imports (ESM requirement)
- Keep models simple and focused
- Document complex query patterns

## Response Wrapping

### Understanding Strapi Responses

Strapi wraps responses in different ways:

```json
// Collection response
{
  "data": [
    { "id": 1, "attributes": { ... } },
    { "id": 2, "attributes": { ... } }
  ]
}

// Single item response
{
  "data": {
    "id": 1,
    "attributes": { ... }
  }
}
```

### Using wrappedByKey and wrappedByList

```typescript
// Extract from "data" key and get first item
wrappedByKey: "data",
wrappedByList: true

// Just extract from "data" key
wrappedByKey: "data",
wrappedByList: false
```

## Error Handling

The `fetchData` function will throw on HTTP errors. Handle appropriately in applications:

```typescript
try {
  const data = await fetchData<Page>({ ... });
} catch (error) {
  console.error("Failed to fetch data:", error);
  // Handle error
}
```
