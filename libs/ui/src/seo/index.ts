import type { Article } from "@xprtz/cms";

export interface SEOData {
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
  locale?: string;
  themeColor?: string;
  structuredData?: object;
}

export function generateSEOData(options: {
  title: string;
  description: string;
  image?: string;
  imageAlt?: string;
  type?: "website" | "article";
  siteName?: string;
  locale?: string;
  structuredData?: object;
  additionalKeywords?: string[];
}): SEOData {
  return {
    title: options.title,
    description: options.description,
    image: options.image,
    imageAlt: options.imageAlt || options.title,
    type: options.type || "website",
    siteName: options.siteName || "XPRTZ",
    locale: options.locale || "nl_NL",
    robots: "index, follow",
    // XPRTZ uses GitHub, Instagram, LinkedIn, YouTube (no Twitter)
    themeColor: "#1e40af",
    structuredData: options.structuredData,
    keywords: options.additionalKeywords || [],
  };
}

export function generateArticleSEOData(options: {
  article: Article;
  imagesUrl: string;
  siteName?: string;
  structuredData?: object;
}): SEOData {
  const { article, imagesUrl, siteName = "XPRTZ", structuredData } = options;

  const primaryAuthor = article.authors?.[0];
  const authorName = primaryAuthor
    ? `${primaryAuthor.firstname} ${primaryAuthor.lastname}`
    : undefined;

  // Generate article-specific keywords from tags
  const keywords = article.tags?.map((tag) => tag.title) || [];

  return {
    title: article.title,
    description: article.title, // You might want to add a dedicated SEO description field
    image: article.image ? `${imagesUrl}${article.image.url}` : undefined,
    imageAlt: article.image?.alternateText || article.title,
    type: "article",
    siteName,
    author: authorName,
    publishedTime: article.date,
    modifiedTime: article.date,
    tags: keywords,
    keywords: keywords,
    robots: "index, follow",
    // XPRTZ uses GitHub, Instagram, LinkedIn, YouTube (no Twitter)
    locale: "nl_NL",
    themeColor: "#1e40af",
    structuredData,
  };
}

export function createPageTitle(
  title: string,
  siteName: string = "XPRTZ"
): string {
  return `${title} | ${siteName}`;
}

export function createDescription(
  description: string,
  maxLength: number = 160
): string {
  if (description.length <= maxLength) {
    return description;
  }

  return description.substring(0, maxLength - 3).trim() + "...";
}
