# UI Library (@xprtz/ui) - Agent Context

## Overview
Shared UI component library for XPRTZ websites. Contains reusable Astro and React components that consume data from the CMS library and render content.

## Package Information
- **Name**: `@xprtz/ui`
- **Type**: `module`
- **Main entry**: [index.ts](index.ts)
- **Framework**: Astro 5.16+ with React 18.3+

## Directory Structure

```
libs/ui/
├── src/               # Component source files
│   ├── *.astro       # Astro components (server-side)
│   └── *.tsx         # React components (client-side)
├── index.ts          # Main export file
├── package.json      # Package configuration
└── AGENTS.md         # This file
```

## Component Inventory

### Layout Components
- [BaseHead.astro](src/BaseHead.astro) - HTML head metadata and SEO tags
- [Footer.astro](src/Footer.astro) - Site footer
- [Header.tsx](src/Header.tsx) - Navigation header (React component with state)
- [Container.astro](src/Container.astro) - Content container wrapper
- [Page.astro](src/Page.astro) - Full page component with dynamic content

### Hero & Featured Components
- [Hero.astro](src/Hero.astro) - Homepage hero section with image gallery
- [Mission.astro](src/Mission.astro) - Mission statement with statistics
- [Values.astro](src/Values.astro) - Company values/core principles display
- [Directors.astro](src/Directors.astro) - Directors/leadership display
- [TeamCarousel.astro](src/TeamCarousel.astro) - Team members carousel using Embla

### Content Components
- [Text.astro](src/Text.astro) - Rich text content block
- [Content.astro](src/Content.astro) - Article content with markdown parsing
- [Listing.astro](src/Listing.astro) - List display component
- [SubtitleWithText.astro](src/SubtitleWithText.astro) - Subtitle with description
- [Quote.astro](src/Quote.astro) - Quote/testimonial display

### Image Components
- [HomePageImage.astro](src/HomePageImage.astro) - Homepage image display
- [HomePageImageWithTitle.astro](src/HomePageImageWithTitle.astro) - Image with title overlay
- [PageImage.astro](src/PageImage.astro) - Page-specific image component

### Blog Components
- [Blogs.astro](src/Blogs.astro) - Blog listing container
- [BlogListing.astro](src/BlogListing.astro) - Blog posts grid/list
- [BlogCard.astro](src/BlogCard.astro) - Individual blog post card

### Utility Components
- [LogoCloud.astro](src/LogoCloud.astro) - Client/partner logo display
- [ComponentRenderer.astro](src/ComponentRenderer.astro) - **Dynamic component routing** (maps CMS `__component` to actual components)

## Component Patterns

### Astro Component Structure
All Astro components follow this pattern:

```astro
---
// Frontmatter (TypeScript)
import { type ComponentType } from "@xprtz/cms";
const componentData = Astro.props as ComponentType;

const site = import.meta.env.PUBLIC_IMAGES_URL;
---

<!-- Template (JSX-like) -->
<div class="tailwind-classes">
  {componentData.title}
</div>

<!-- Optional scoped styles -->
<style>
  .custom-styles {
    /* Scoped CSS */
  }
</style>

<!-- Optional client-side scripts -->
<script>
  // TypeScript for client-side behavior
</script>
```

### Props Pattern
Components receive props via `Astro.props` and cast to the appropriate CMS type:

```typescript
import { type Hero } from "@xprtz/cms";
const hero = Astro.props as Hero;
```

### Image Handling
Images use the `PUBLIC_IMAGES_URL` environment variable:

```astro
const site = import.meta.env.PUBLIC_IMAGES_URL;
<img src={`${site}${hero.images[0].url}`} alt={hero.images[0].alternateText} />
```

### Client-Side Interactivity
Use React components with `client:load` directive for client-side hydration:

```astro
<Header Logo={Logo.src} client:load />
```

## ComponentRenderer Pattern

The [ComponentRenderer.astro](src/ComponentRenderer.astro) is crucial for CMS-driven content. It maps Strapi component identifiers to actual Astro components:

```typescript
const componentMap: Record<string, any> = {
  "ui.text": Text,
  "ui.hero": Hero,
  "ui.missie-met-statistieken": Mission,
  "ui.kernwaarden": Values,
  "ui.opsomming": Listing,
  "ui.titel": SubtitleWithText,
  "ui.quote": Quote,
  "ui.image": HomePageImage,
  "ui.image-met-titel": HomePageImageWithTitle,
  "ui.page-image": PageImage,
  "ui.artikelen": Blogs,
  "ui.artikelen-overzicht": BlogListing,
  "ui.klant-logo-s": LogoCloud,
  "ui.team": TeamCarousel,
  "ui.directeuren": Directors,
};
```

### Usage
```astro
<ComponentRenderer components={page.components} />
```

This dynamically renders all components from CMS data based on their `__component` field.

## Styling Approach

### Tailwind CSS
Primary styling method using utility classes:

```astro
<h1 class="text-4xl font-bold tracking-tight text-primary-800 sm:text-6xl">
  {hero.title}
</h1>
```

### Custom Theme Colors
Components use a `primary-*` color palette:
- `primary-100` to `primary-900` - Brand color scale
- `text-primary-800` - Primary text color
- `bg-primary-600` - Primary background color

### Responsive Design
Tailwind breakpoint prefixes:
- `sm:` - Small screens and up
- `md:` - Medium screens and up
- `lg:` - Large screens and up
- `xl:` - Extra large screens and up

### Scoped Styles
Used for complex layouts (e.g., carousels):

```astro
<style>
  .embla {
    position: relative;
    max-width: 100%;
  }
</style>
```

## Dependencies

### Key Dependencies
- `astro` - Astro framework
- `react` + `react-dom` - React library
- `@astrojs/react` - React integration
- `@headlessui/react` - Accessible UI components
- `@heroicons/react` - Icon library
- `embla-carousel` - Carousel library
- `marked` - Markdown to HTML parser
- `@xprtz/cms` - Types imported but NOT listed in package.json (provided by parent workspace)

### Important Notes
- The CMS library is NOT a dependency in package.json
- CMS types are imported directly from the workspace
- Components assume CMS types are available via workspace resolution

## Export Pattern

All components are exported from [index.ts](index.ts):

```typescript
import Hero from "./src/Hero.astro";
import Header from "./src/Header.tsx";
// ... other imports

export {
  Hero,
  Header,
  ComponentRenderer,
  // ... other exports
};
```

### Import Usage in Apps
```typescript
import { Hero, Header, ComponentRenderer } from "@xprtz/ui";
```

## Adding New Components

### Step-by-Step Process

1. **Create CMS Type** (in `@xprtz/cms`)
   ```typescript
   // libs/cms/models/newComponent.ts
   export type NewComponent = {
     __component: "ui.new-component";
     id: number;
     title: string;
     // ... other fields
   };
   ```

2. **Create Astro Component**
   ```astro
   ---
   // libs/ui/src/NewComponent.astro
   import { type NewComponent } from "@xprtz/cms";
   const data = Astro.props as NewComponent;
   ---
   <div class="...">
     <h2>{data.title}</h2>
   </div>
   ```

3. **Export from index.ts**
   ```typescript
   import NewComponent from "./src/NewComponent.astro";
   export { NewComponent };
   ```

4. **Register in ComponentRenderer** (if CMS-driven)
   ```typescript
   const componentMap: Record<string, any> = {
     // ... existing mappings
     "ui.new-component": NewComponent,
   };
   ```

5. **Ensure Strapi has matching content type**
   - Component identifier must match: `ui.new-component`
   - Fields must match TypeScript type definition

## Component Development Guidelines

### TypeScript Type Safety
- Always import and use CMS types
- Use type assertions: `const data = Astro.props as ComponentType`
- Never use `any` unless absolutely necessary

### Astro vs React Components
- **Use Astro** for static/server-side rendering (default)
- **Use React** when you need:
  - State management (`useState`, `useEffect`)
  - Client-side interactivity
  - Event handlers
  - Form interactions

### Image Best Practices
- Always use `alternateText` for accessibility
- Prefix image URLs with `PUBLIC_IMAGES_URL`
- Use responsive image techniques (aspect ratios, object-fit)

### Accessibility
- Use semantic HTML elements
- Include ARIA labels where needed
- Ensure keyboard navigation works
- Test with screen readers

### Performance
- Minimize client-side JavaScript
- Use Astro components by default (zero JS shipped)
- Only hydrate with React when necessary (`client:load`, `client:visible`)
- Optimize images (proper formats, sizes)

## Testing

### Type Checking
```bash
npm run build  # Runs astro check
```

### Manual Testing
- Test in both `dotnet` and `learning` apps
- Verify responsive behavior at all breakpoints
- Check dark/light mode if applicable
- Validate accessibility

## Common Patterns

### Conditional Rendering
```astro
{data.description && (
  <p class="...">{data.description}</p>
)}
```

### Mapping Arrays
```astro
{items.map((item) => (
  <div>{item.title}</div>
))}
```

### Environment Variables
```astro
const site = import.meta.env.PUBLIC_IMAGES_URL;
```

### Link Handling
```astro
<a href={`/${link.page.slug}`} class="...">
  {link.title}
</a>
```

## Carousel Pattern (Embla)

Components like [TeamCarousel.astro](src/TeamCarousel.astro) use Embla Carousel:

```astro
<script>
  import EmblaCarousel from "embla-carousel";

  const initEmblaCarousel = (rootElement: HTMLElement) => {
    const emblaNode = rootElement.querySelector(".embla__viewport") as HTMLElement;
    const embla = EmblaCarousel(emblaNode, {
      loop: true,
      align: "start"
    });
  };

  document.addEventListener("astro:page-load", () => {
    document.querySelectorAll(".embla").forEach(initEmblaCarousel);
  });
</script>
```

## Important Notes

### Do NOT:
- Add components that don't have matching CMS types
- Use inline styles (prefer Tailwind)
- Create dependencies on specific apps
- Hardcode environment-specific values
- Skip type definitions

### DO:
- Follow existing naming conventions
- Maintain type safety
- Use Tailwind utility classes
- Keep components reusable and generic
- Document complex component logic
- Test in multiple contexts
- Ensure accessibility
- Export all new components from index.ts
