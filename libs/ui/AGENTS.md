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

### Technology Radar Components
- [TechnologyRadar.astro](src/TechnologyRadar.astro) - **CMS-driven component** that renders the complete technology radar on any page
- [RadarChart.astro](src/RadarChart.astro) - Technology radar visualization with four quadrants
- [RadarQuadrant.astro](src/RadarQuadrant.astro) - Individual radar quadrant with concentric rings and items
- [RadarQuadrantItemList.astro](src/RadarQuadrantItemList.astro) - List view of items in a selected quadrant

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
  "ui.technology-radar": TechnologyRadar,
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

## Technology Radar Pattern

The Technology Radar components provide an interactive visualization of technology adoption. The radar can be added to any CMS-managed page using the `TechnologyRadar` component.

### TechnologyRadar Component (CMS-Driven)

The main CMS component that can be added to any page to display the technology radar.

**Props:**
- `__component: "ui.technology-radar"` - Component identifier for CMS
- `title: string` - Title displayed above the radar

**Features:**
- Automatically fetches all radar items from CMS
- Renders the complete radar visualization using `RadarChart`
- Includes tag filtering functionality with toggle buttons
- Displays all unique tags from radar items
- Clicking a tag filters radar items to show only those with that tag
- Clicking the same tag again removes the filter
- Smooth opacity transitions for filtered items
- **Hover highlighting**: When hovering over an item in the quadrant list, the corresponding radar item on the chart is highlighted with enhanced visual effects (larger size, color fill, and glow)
- **Tag filtering**: Stores tag information in `data-tags` attributes on radar items for client-side filtering
- Uses `initializeOnReady` utility from radarUtils for consistent initialization across page loads

**Usage in CMS:**
Add the component to any page's components array in Strapi with:
- Component type: `ui.technology-radar`
- Title field: e.g., "Our Technology Radar"

**Direct Usage (if needed):**
```astro
import { TechnologyRadar } from "@xprtz/ui";

<TechnologyRadar title="Our Technology Radar" />
```

**Important Notes:**
- The component handles its own data fetching - no need to pass items
- Tag filtering is client-side and persists until page reload
- Links to radar items point to `/radar-items/{slug}` with a `from` query parameter
- The `from` parameter contains the current page slug for proper back navigation
- This replaces the old hard-coded expertise page approach

**Back Navigation:**
- The component automatically detects the current page URL
- When users click on a radar item, the current page slug is passed as `?from={slug}`
- The radar item page uses this to create a dynamic "Back" link
- If no `from` parameter exists, it defaults to `/expertise` for backwards compatibility

### RadarChart Component

The main radar visualization that combines four quadrants into a complete circle with full responsive design support.

**Props:**
- `items?: RadarItem[]` - Array of radar items from CMS
- `quadrantSize?: number` - Size of each quadrant in pixels (default: 400)
- `parentPageSlug?: string` - Slug of the parent page for back navigation (optional)

**Features:**
- Automatically numbers items sequentially (starting at 1)
- Distributes items to appropriate quadrants based on `item.quadrant` field
- Uses predefined colors for each quadrant:
  - **Techniques**: Blue (#3b82f6)
  - **Tools**: Green (#10b981)
  - **Platforms**: Amber (#f59e0b)
  - **Languages & Frameworks**: Red (#ef4444)
- 20px margin between quadrants for visual separation
- Interactive zoom functionality with smooth animations (500ms duration)
- Transform-based container slide (200px left) prevents layout reflow
- List slides in from right after zoom completes
- Synchronized animations create smooth push-effect without jumping

**Responsive Design:**

The RadarChart implements a three-tier responsive strategy:

1. **Desktop/Tablet View (> 1090px width)**
   - Full radar chart with four quadrants displayed
   - Hover effects dim non-hovered quadrants to 50% opacity
   - Click to zoom individual quadrants (1.75x scale)
   - Quadrant slides/transforms to center when zoomed
   - Ring labels (Adopt, Trial, Assess, Hold) transform with zoomed quadrant
   - Item list appears to the right of radar after zoom animation

2. **Medium Screens (870px - 1090px width)**
   - Full radar chart visible
   - When quadrant is clicked and list appears:
     - Radar chart fades out smoothly (300ms opacity transition)
     - After fade-out completes, radar switches from `position: absolute` to `display: none`
     - Item list switches from `position: absolute` to `position: static`
     - Item list takes full width and flows naturally in page layout
   - Smooth fade-out prevents abrupt disappearance
   - No blank space remains after animation completes

3. **Mobile View (< 870px width)**
   - Radar chart hidden (`display: none`)
   - Four colored tiles displayed in 2x2 grid
   - Each tile represents a quadrant with matching colors
   - Hover effects dim non-hovered tiles to 50% opacity
   - Click to zoom tile (2.05x scale from corner origin)
   - Zoomed tile expands to fill entire 2x2 grid area
   - **Z-index layering**: Tiles use z-index to ensure proper stacking during zoom animations
     - Regular tiles: `z-index: 1`
     - Zoomed tile: `z-index: 10` (appears above other tiles)
     - Item list: `z-index: 20` (always on top, including during zoom-out)
     - Z-index is maintained during zoom-out animation, then removed after animation completes
   - When tile is clicked and list appears:
     - Tiles fade out smoothly (300ms opacity transition)
     - After fade-out completes, tiles switch from `position: absolute` to `display: none`
     - Item list switches from `position: absolute` to `position: static`
     - Item list takes full width
   - Smooth animations prevent jarring layout shifts
   - Transform origins set to corners (top-left, top-right, bottom-left, bottom-right)
   - Very small screens (< 360px): Tiles stack in single column

**Animation Configuration:**

The component uses CSS variables to control all animation timings (defined in `.radar-chart-wrapper`):
- `--fade-out-duration: 300ms` - Duration for fading out radar/tiles when list appears
- `--fade-out-delay: 100ms` - Delay before fade-out animation starts
- `--fade-in-duration: 400ms` - Duration for fading in the item list
- `--zoom-duration: 500ms` - Duration for quadrant zoom animations
- `--slide-duration: 400ms` - Duration for container and list slide animations

Benefits:
- CSS transitions read variables for consistent animation duration
- JavaScript reads the same variables to time class additions
- Single source of truth - changing a variable updates both CSS and JavaScript
- All radar components inherit these variables for synchronized animations
- Ensures perfect synchronization between opacity, transforms, and layout changes

**State Management:**

The component uses CSS classes to manage animation states:
- `list-visible` - Triggers opacity fade-out of radar/tiles
- `list-animation-complete` - Applied after fade completes, sets `display: none` and `position: static`
- `zoomed` - Applied to radar chart when any quadrant is zoomed
- `zoomed-in` - Applied to the specific quadrant/tile being zoomed
- `visible` - Applied to item list to trigger slide-in animation
- `hidden` - Applied to item list to hide it with `display: none`

**Initialization:**

The component uses the `initializeOnReady` utility function from `radarUtils.ts` for consistent initialization:
- Handles both Astro page-load events and initial page load
- Ensures initialization runs exactly once per page load
- Shared pattern across all radar components

**Usage:**
```astro
import { RadarChart } from "@xprtz/ui";

<RadarChart items={allRadarItems} quadrantSize={400} />
```

### RadarQuadrant Component

Individual quadrant representing 90° of the radar (one quarter circle).

**Props:**
- `gridPosition: "top-left" | "top-right" | "bottom-left" | "bottom-right"` - Position in the 2x2 grid layout
- `color: string` - Color for the quadrant
- `size?: number` - Size in pixels (default: 400)
- `items?: RadarItemWithNumber[]` - Radar items to display
- `parentPageSlug?: string` - Slug of the parent page for back navigation (optional)

**Features:**
- Four concentric rings representing adoption stages (defined in `radarUtils.ts`):
  - **Adopt** (innermost, 25% radius)
  - **Trial** (50% radius)
  - **Assess** (75% radius)
  - **Hold** (outermost, 100% radius)
- Items displayed as numbered circles (12px radius)
- Deterministic positioning using golden angle distribution
- Interactive items with:
  - SVG tooltips showing "{number}. {title}"
  - Click to navigate to item detail page
  - Hover effects (gray background on hover)
  - Highlight effects when item in list is hovered (colored fill, larger size, glow)
- Origin point positioned at appropriate corner based on grid position
- **Tag data**: Each radar item includes a `data-tags` attribute with JSON-serialized tag titles for filtering

**Item Positioning Algorithm:**
- Items placed within their ring based on `item.ring` value
- Pseudo-random but deterministic distribution using item number as seed
- Golden angle (137.508°) for optimal spread
- Radius variation within ring (30-90% of ring width) to reduce overlap
- Optimized for 20-30 items per quadrant

**Item Links:**
- Items link to `/radar-items/{slug}` for individual radar item pages
- Uses `buildRadarItemLink` utility from `radarUtils.ts` for consistent link generation
- If `parentPageSlug` is provided, adds `?from={parentPageSlug}` query parameter for back navigation
- The radar item page reads this parameter to create a dynamic back link

**Usage:**
```astro
import { RadarQuadrant } from "@xprtz/ui";

<RadarQuadrant
  gridPosition="top-left"
  color="#3b82f6"
  size={400}
  items={itemsWithNumbers}
  parentPageSlug="expertise"
/>
```

### RadarItem Types

The radar system uses two related types:

```typescript
// Base type from CMS (no number property)
type RadarItem = {
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

// Extended type with number property (added by UI layer)
type RadarItemWithNumber = RadarItem & {
  number: number;          // Sequential number (1, 2, 3...)
}
```

**Type Usage Flow:**
1. Fetch `RadarItem[]` from CMS (no numbers)
2. RadarChart component adds numbers, creating `RadarItemWithNumber[]`
3. Pass `RadarItemWithNumber[]` to child components (RadarQuadrant, RadarQuadrantItemList)

### RadarQuadrantItemList Component

List view displaying all items within a selected quadrant, grouped by ring.

**Props:**
- `items: RadarItemWithNumber[]` - Array of radar items for the quadrant
- `quadrantName: string` - Name of the quadrant
- `color: string` - Color for the quadrant header
- `parentPageSlug?: string` - Slug of the parent page for back navigation (optional)

**Features:**
- Groups items by ring (Adopt, Trial, Assess, Hold) using `RINGS` constant from `radarUtils.ts`
- Displays item number, title, and description
- Links to item detail pages with `from` query parameter using `buildRadarItemLink` utility
- Scrollable list with sticky ring headers
- "Back to radar" button to return to main view
- Hidden by default, shown when quadrant is clicked
- Smooth slide-in animation from right
- Appears after quadrant zoom animation completes
- Coordinated slide-out animation when zooming out
- **CSS variable-based animations**: All animation timings use CSS variables inherited from parent wrapper
  - Transform duration: `var(--slide-duration, 400ms)`
  - Fade-out duration: `var(--fade-out-duration, 300ms)` with delay `var(--fade-out-delay, 100ms)`
  - Fade-in duration: `var(--fade-in-duration, 400ms)`
- **Interactive hover**: Hovering over list items highlights the corresponding radar item on the chart with enhanced visual effects

**Animation Behavior:**
- Starts with `position: absolute` overlaying the radar/tiles
- Slides in from right with opacity fade-in (400ms)
- When radar/tiles complete their fade-out (300ms), switches to `position: static`
- Becomes part of normal document flow without causing layout jumps
- Takes full width on smaller screens for optimal readability
- Custom scrollbar styling for better UX in scrollable content

### Shared Utilities (radarUtils.ts)

The radar components share common utilities defined in `radarUtils.ts`:

**Constants:**
```typescript
export const RINGS: readonly { readonly label: RadarRing; readonly radiusPosition: number }[] = [
  { label: "Adopt", radiusPosition: 25 },
  { label: "Trial", radiusPosition: 50 },
  { label: "Assess", radiusPosition: 75 },
  { label: "Hold", radiusPosition: 100 },
] as const;
```
- Single source of truth for ring configuration
- Used by RadarChart, RadarQuadrant, and RadarQuadrantItemList
- Ensures consistent ring ordering and positioning across all components

**Functions:**

`buildRadarItemLink(slug: string, parentPageSlug?: string): string`
- Builds consistent links to radar item pages
- Adds optional `?from={parentPageSlug}` query parameter for back navigation
- Used by RadarQuadrant and RadarQuadrantItemList

`initializeOnReady(callback: () => void): void`
- Handles both Astro page-load events and initial page load
- Ensures callback runs exactly once when page is ready
- Used by RadarChart and TechnologyRadar for consistent initialization

### Integration Example

**Using TechnologyRadar (Recommended for CMS pages):**
```astro
---
import { TechnologyRadar } from "@xprtz/ui";
---

<!-- Add via CMS or use directly -->
<TechnologyRadar title="Our Technology Radar" />
```

**Using RadarChart directly (Advanced usage):**
```astro
---
import { fetchData, type RadarItem } from "@xprtz/cms";
import { RadarChart } from "@xprtz/ui";

const allRadarItems = await fetchData<Array<RadarItem>>({
  endpoint: "radar-items",
  wrappedByKey: "data",
  query: {
    "populate[tags][fields][0]": "title",
    status: "published",
  },
});
---

<RadarChart items={allRadarItems} parentPageSlug="expertise" />
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
- Use shared utilities from radarUtils.ts for radar components
- Use CSS variables for animation timings to maintain consistency
- Use `initializeOnReady` for client-side initialization in Astro components
