# Technology Radar Setup Guide

This guide explains how to set up the Technology Radar feature in your Strapi CMS.

## Overview

The Technology Radar is now set up to work similarly to the articles (artikelen) feature:
- Main listing page with pagination at: `/technology-radar/page/1`
- Individual item pages at: `/technology-radar/{item-slug}`
- Integration with the existing "Technology Radar" page (slug: `technology-radar`)

## Files Created

### CMS Model
- **[libs/cms/models/radarItem.ts](../../libs/cms/models/radarItem.ts)** - TypeScript type definition
- **Updated [libs/cms/index.ts](../../libs/cms/index.ts)** - Exports RadarItem, RadarQuadrant, and RadarRing types

### UI Components
- **[libs/ui/src/RadarItems.astro](../../libs/ui/src/RadarItems.astro)** - Listing component with pagination
- **Updated [libs/ui/index.ts](../../libs/ui/index.ts)** - Exports RadarItems component

### App Pages
- **[src/pages/technology-radar/[radarItem].astro](src/pages/technology-radar/[radarItem].astro)** - Individual radar item pages
- **[src/pages/technology-radar/page/[page].astro](src/pages/technology-radar/page/[page].astro)** - Paginated listing
- **Updated [src/pages/[slug].astro](src/pages/[slug].astro)** - Added rewrite rule to redirect `/technology-radar` to `/technology-radar/page/1`

## Strapi CMS Configuration

### 1. Create Collection Type: "Radar Items"

In Strapi Admin Panel:
1. Go to **Content-Type Builder**
2. Click **Create new collection type**
3. Name: `radar-item` (singular), `radar-items` (plural)

### 2. Add Fields

Add the following fields to the `radar-items` collection:

#### Basic Fields
- **slug** (Text - Short text)
  - Type: Text
  - Required: Yes
  - Unique: Yes

- **title** (Text - Short text)
  - Type: Text
  - Required: Yes

- **description** (Text - Long text)
  - Type: Text
  - Required: Yes

- **conclusion** (Text - Long text)
  - Type: Text
  - Required: No

#### Enumeration Fields
- **quadrant** (Enumeration)
  - Type: Enumeration
  - Values:
    - `Techniques`
    - `Tools`
    - `Platforms`
    - `Languages & Frameworks`
  - Required: Yes

- **ring** (Enumeration)
  - Type: Enumeration
  - Values:
    - `Adopt`
    - `Trial`
    - `Assess`
    - `Hold`
  - Required: Yes

#### Component Fields (Repeatable)
- **pros** (Component - Repeatable)
  - Component: `shared.list-item` (reuse existing ListItem component)
  - Required: No

- **cons** (Component - Repeatable)
  - Component: `shared.list-item` (reuse existing ListItem component)
  - Required: No

#### Relation Fields
- **tags** (Relation - Many to Many)
  - Relation type: Relation with tags
  - Many to Many relationship
  - Required: No

#### System Fields
- **status** (Enumeration)
  - Type: Enumeration
  - Values:
    - `published`
    - `draft`
  - Default value: `draft`

### 3. Configure API Access

1. Go to **Settings → Roles → Public**
2. Enable **find** and **findOne** permissions for `radar-items`
3. Save

### 4. Verify Existing Page

Make sure the page with slug `technology-radar` exists:
1. Go to **Content Manager → Pages**
2. Find or create page with:
   - **Slug**: `technology-radar`
   - **Title (Website)**: Technology Radar (or your preferred title)
   - **Title (CMS)**: Technology Radar
   - **Description**: Your radar description
   - **Tagline**: e.g., "XPRTZ"
   - **Site**: `dotnet`
   - **Status**: `published`

## Creating Content

### Example Radar Item

Here's an example of a complete radar item entry:

**Title**: Minimal APIs in .NET
**Slug**: minimal-apis-dotnet
**Quadrant**: Tools
**Ring**: Adopt
**Description**: Minimal APIs provide a simplified approach to building HTTP APIs with ASP.NET Core. They reduce the ceremony and boilerplate traditionally associated with creating APIs.
**Status**: published

**Pros**:
1. **Less Boilerplate** - Significantly reduces the amount of code needed to create endpoints
2. **Performance** - Lightweight and fast, with minimal overhead
3. **Easy to Learn** - Great for developers new to ASP.NET Core

**Cons**:
1. **Limited Conventions** - Less structure than controllers, can lead to inconsistent APIs
2. **Complex Routing** - More difficult to manage in large applications
3. **Testing** - Slightly more challenging to test compared to controller-based APIs

**Conclusion**: Minimal APIs are excellent for microservices and small to medium-sized APIs. For larger applications with complex requirements, traditional controllers may still be preferable.

**Tags**: ASP.NET Core, APIs, .NET 6

## URL Structure

Once content is created, the following URLs will be available:

- **Main listing**: `/technology-radar` (automatically redirects to `/technology-radar/page/1`)
- **Main listing (page 1)**: `/technology-radar/page/1`
- **Main listing (page 2)**: `/technology-radar/page/2`
- **Individual item**: `/technology-radar/minimal-apis-dotnet`

Note: The `/technology-radar` URL is configured in [src/pages/[slug].astro](src/pages/[slug].astro) to rewrite to the paginated listing at `/technology-radar/page/1`, similar to how `/artikelen` redirects to `/artikelen/page/1`.

## Features

### Listing Page Features
- Displays radar item title, description, quadrant, ring, and tags
- Color-coded ring badges:
  - **Adopt**: Green
  - **Trial**: Blue
  - **Assess**: Yellow
  - **Hold**: Red
- Pagination (10 items per page)
- Links to individual item pages

### Individual Item Page Features
- Full title and description
- Quadrant and ring display
- **Pros section** with green checkmark icons
- **Cons section** with red X icons
- **Conclusion section**
- Tags display
- Back link to listing

## API Queries Used

### For Listing Page
```javascript
endpoint: "radar-items"
query: {
  "populate[tags][fields][0]": "title",
  status: "published",
}
```

### For Individual Item Page
```javascript
endpoint: "radar-items"
query: {
  "populate[pros]": "*",
  "populate[cons]": "*",
  "populate[tags][fields][0]": "title",
  status: "published",
}
```

## Testing

1. Create at least one radar item in Strapi
2. Set **status** to `published`
3. Build the app: `npm run build`
4. Preview: `npm run preview`
5. Navigate to `/technology-radar/page/1`

## Troubleshooting

### No items showing
- Verify items are published (status: "published")
- Verify API permissions are enabled in Strapi

### Build fails
- Ensure Strapi CMS is running and accessible
- Check environment variables are set correctly
- Verify the page with slug "technology-radar" exists

### Styling issues
- Check that Tailwind CSS is configured properly
- Verify ring colors are defined in the component

## Next Steps

Consider adding these features:
1. Filter by quadrant or ring
2. Search functionality
3. Visual radar chart representation
4. Related items based on tags
5. Export to PDF functionality
