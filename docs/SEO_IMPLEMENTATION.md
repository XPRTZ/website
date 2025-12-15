# SEO Implementation Guide

## Overview

This document describes the comprehensive SEO implementation added to the XPRTZ website. The implementation includes enhanced meta tags, structured data, Open Graph support, and social media sharing capabilities.

## 🎯 What Was Implemented

### 1. Enhanced BaseHead Component

**Location**: `libs/ui/src/BaseHead.astro`

**Features Added**:

- ✅ Extended Open Graph tags (site_name, locale, article-specific tags)
- ✅ Enhanced Twitter Card support (site handle, creator, image alt text)
- ✅ JSON-LD structured data support
- ✅ Additional meta tags (keywords, author, robots, theme-color)
- ✅ Article-specific meta tags (publication date, modified date, tags)
- ✅ Improved font preloading with correct MIME types

**Key Properties**:

```typescript
interface Props {
  title: string;
  description: string;
  image?: string;
  imageAlt?: string;
  type?: "website" | "article";
  siteName?: string;
  author?: string;
  publishedTime?: string;
  modifiedTime?: string;
  tags?: string[];
  keywords?: string[];
  robots?: string;
  twitterSite?: string;
  twitterCreator?: string;
  locale?: string;
  themeColor?: string;
  structuredData?: object;
}
```

### 2. Structured Data (JSON-LD)

**Location**: `libs/ui/src/seo/structuredData.ts`

**Available Functions**:

- `generateWebsiteStructuredData()` - For homepage and general pages
- `generateOrganizationStructuredData()` - For company information
- `generateArticleStructuredData()` - For blog posts/articles
- `generatePersonStructuredData()` - For author profiles
- `generateBreadcrumbStructuredData()` - For navigation breadcrumbs

**Example Usage**:

```typescript
const structuredData = generateArticleStructuredData({
  article,
  siteUrl: "https://xprtz.net",
  siteName: "XPRTZ",
  imagesUrl: "https://images.xprtz.net",
});
```

### 3. SEO Helper Functions

**Location**: `libs/ui/src/seo/index.ts`

**Available Functions**:

- `generateSEOData()` - Generate comprehensive SEO data object
- `generateArticleSEOData()` - Generate article-specific SEO data
- `createPageTitle()` - Create consistent page titles
- `createDescription()` - Truncate descriptions to optimal length

### 4. SEO Tools Component

**Location**: `libs/ui/src/SEOTools.astro`

**Features**:

- Pagination support (prev/next links)
- Alternate language versions
- AMP support
- Breadcrumb structured data
- Custom robots directives

### 5. Enhanced Layouts

**Location**: `apps/dotnet/src/layouts/layout.astro`

**Improvements**:

- ✅ Automatic structured data generation
- ✅ Organization information integration
- ✅ Flexible SEO data handling
- ✅ Default Dutch language support

## 📄 Files Modified

### Core SEO Files

- `libs/ui/src/BaseHead.astro` - Enhanced meta tags and structured data
- `libs/ui/src/seo/structuredData.ts` - Structured data generators
- `libs/ui/src/seo/index.ts` - SEO helper functions
- `libs/ui/src/SEOTools.astro` - Additional SEO tools component
- `libs/ui/index.ts` - Export new SEO utilities

### Implementation Files

- `apps/dotnet/src/layouts/layout.astro` - Enhanced layout with SEO support
- `apps/dotnet/src/pages/index.astro` - Homepage with website structured data
- `apps/dotnet/src/pages/artikelen/[article].astro` - Article pages with rich SEO
- `apps/dotnet/src/pages/artikelen/page/[page].astro` - Blog listing with pagination SEO
- `apps/dotnet/public/robots.txt` - Search engine directives

## 🔧 How to Use

### For Homepage/General Pages:

```astro
---
import { generateWebsiteStructuredData } from '@xprtz/ui';

const structuredData = generateWebsiteStructuredData({
  name: 'XPRTZ',
  url: 'https://xprtz.net',
  description: 'Expert consultancy in .NET, Azure, and modern software development'
});
---

<Layout
  title="Page Title"
  description="Page description"
  type="website"
  seoData={{
    structuredData,
    keywords: ['keyword1', 'keyword2']
  }}
>
  <!-- Page content -->
</Layout>
```

### For Article Pages:

```astro
---
import { generateArticleSEOData, generateArticleStructuredData } from '@xprtz/ui';

const structuredData = generateArticleStructuredData({
  article,
  siteUrl: 'https://xprtz.net',
  siteName: 'XPRTZ',
  imagesUrl: 'https://images.xprtz.net'
});

const seoData = generateArticleSEOData({
  article,
  imagesUrl: 'https://images.xprtz.net',
  structuredData
});
---

<Layout
  title={article.title}
  description={article.title}
  type="article"
  author="Author Name"
  publishedTime={article.date}
  tags={article.tags.map(tag => tag.title)}
  seoData={seoData}
>
  <!-- Article content -->
</Layout>
```

### For Pages with Special SEO Needs:

```astro
---
import { SEOTools } from '@xprtz/ui';
---

<Layout title="Page Title" description="Page description">
  <SEOTools
    prevPage="/previous-page"
    nextPage="/next-page"
    breadcrumbs={[
      { name: 'Home', url: 'https://xprtz.net' },
      { name: 'Current Page', url: 'https://xprtz.net/current' }
    ]}
  />

  <!-- Page content -->
</Layout>
```

## 🚀 Benefits

### Search Engine Optimization

- **Rich Snippets**: Structured data enables rich search results
- **Better Indexing**: Proper meta tags help search engines understand content
- **Social Media**: Open Graph tags improve social media sharing
- **Performance**: Optimized font preloading and efficient meta tag delivery

### Social Media Sharing

- **Twitter Cards**: Properly formatted Twitter sharing
- **Facebook/LinkedIn**: Enhanced Open Graph support
- **Image Optimization**: Proper image alt text and sizing
- **Rich Previews**: Structured data for rich link previews

### Technical SEO

- **Canonical URLs**: Prevent duplicate content issues
- **Pagination**: Proper rel="prev/next" for paginated content
- **Breadcrumbs**: Structured data for navigation
- **Robots.txt**: Proper search engine directives
- **Sitemap**: Automatic sitemap generation (already configured)

## 📊 Testing Your SEO

### Tools to Test Implementation:

1. **Google Rich Results Test**: https://search.google.com/test/rich-results
2. **Facebook Sharing Debugger**: https://developers.facebook.com/tools/debug/
3. **Twitter Card Validator**: https://cards-dev.twitter.com/validator
4. **OpenGraph.xyz**: https://www.opengraph.xyz/ (as requested)

### What to Test:

- Article pages for rich snippets
- Homepage for organization markup
- Social media sharing previews
- Mobile-friendly test
- Page speed insights

## 🔍 Next Steps

### Potential Improvements:

1. **FAQ Schema**: Add FAQ structured data to relevant pages
2. **Review Schema**: If you have testimonials or reviews
3. **Local Business**: If XPRTZ has physical locations
4. **Video Schema**: For any video content
5. **Course Schema**: For learning content (if applicable)

### Monitoring:

1. Set up Google Search Console
2. Monitor Core Web Vitals
3. Track rich snippet performance
4. Monitor social media sharing metrics

## 🎨 Customization

### Default Values:

```typescript
// These can be customized in the layout or per page
const defaults = {
  siteName: "XPRTZ",
  locale: "nl_NL",
  themeColor: "#1e40af",
  robots: "index, follow",
};

// Social media platforms (included in structured data)
const socialMediaPlatforms = [
  "https://www.linkedin.com/company/xprtz",
  "https://github.com/xprtz",
  "https://instagram.com/workwithxprtz",
  "https://www.youtube.com/channel/UCFUV8Q5RgFMwN-XM_vkwT3g",
];
```

### Environment Variables:

Make sure these are set in your environment:

- `PUBLIC_SITE` - Your site identifier
- `PUBLIC_IMAGES_URL` - URL for images
- `PUBLIC_STRAPI_URL` - CMS URL

This implementation provides a solid foundation for SEO while maintaining flexibility for future enhancements.
