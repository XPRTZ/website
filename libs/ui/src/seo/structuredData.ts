import type { Article, Author } from "@xprtz/cms";

interface OrganizationData {
  name: string;
  url: string;
  logo?: string;
  description?: string;
  sameAs?: string[];
  foundingDate?: string;
  address?: {
    streetAddress?: string;
    addressLocality?: string;
    addressRegion?: string;
    postalCode?: string;
    addressCountry?: string;
  };
  contactPoint?: {
    telephone?: string;
    email?: string;
  };
}

interface PersonData {
  name: string;
  jobTitle?: string;
  image?: string;
  sameAs?: string[];
}

export function generateWebsiteStructuredData(options: {
  name: string;
  url: string;
  description: string;
  logo?: string;
  sameAs?: string[];
}) {
  return {
    "@context": "https://schema.org",
    "@type": "WebSite",
    name: options.name,
    url: options.url,
    description: options.description,
    ...(options.logo && { logo: options.logo }),
    ...(options.sameAs && { sameAs: options.sameAs }),
    potentialAction: {
      "@type": "SearchAction",
      target: {
        "@type": "EntryPoint",
        urlTemplate: `${options.url}/search?q={search_term_string}`,
      },
      "query-input": "required name=search_term_string",
    },
  };
}

export function generateOrganizationStructuredData(options: OrganizationData) {
  return {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: options.name,
    url: options.url,
    ...(options.logo && {
      logo: {
        "@type": "ImageObject",
        url: options.logo,
      },
    }),
    ...(options.description && { description: options.description }),
    ...(options.sameAs && { sameAs: options.sameAs }),
    ...(options.foundingDate && { foundingDate: options.foundingDate }),
    ...(options.address && {
      address: {
        "@type": "PostalAddress",
        ...options.address,
      },
    }),
    ...(options.contactPoint && {
      contactPoint: {
        "@type": "ContactPoint",
        ...options.contactPoint,
      },
    }),
  };
}

export function generateArticleStructuredData(options: {
  article: Article;
  siteUrl: string;
  siteName: string;
  imagesUrl: string;
}) {
  const { article, siteUrl, siteName, imagesUrl } = options;

  const authors =
    article.authors?.map((author: Author) => ({
      "@type": "Person",
      name: `${author.firstname} ${author.lastname}`,
      ...(author.jobTitle && { jobTitle: author.jobTitle }),
      ...(author.avatar && {
        image: {
          "@type": "ImageObject",
          url: `${imagesUrl}${author.avatar.url}`,
        },
      }),
      url: `${siteUrl}/team/${author.firstname.toLowerCase()}-${author.lastname.toLowerCase()}`,
      ...(author.gitHub && {
        sameAs: [`https://github.com/${author.gitHub}`],
      }),
    })) || [];

  return {
    "@context": "https://schema.org",
    "@type": "BlogPosting", // More specific than Article for blog posts
    headline: article.title,
    description: article.content
      ? article.content.substring(0, 160) + "..."
      : article.title, // Use content excerpt or title as fallback
    image: article.image
      ? {
          "@type": "ImageObject",
          url: `${imagesUrl}${article.image.url}`,
        }
      : undefined,
    datePublished: new Date(article.date).toISOString(),
    dateModified: new Date(article.date).toISOString(), // Using the same date since no updatedAt field exists
    author: authors.length > 0 ? authors : undefined,
    publisher: {
      "@type": "Organization",
      name: siteName,
      url: siteUrl,
      logo: {
        "@type": "ImageObject",
        url: `${siteUrl}/images/logo.svg`,
      },
    },
    mainEntityOfPage: {
      "@type": "WebPage",
      "@id": `${siteUrl}/artikelen/${article.slug}`,
    },
    ...(article.tags && {
      keywords: article.tags.map((tag) => tag.title).join(", "),
    }),
    inLanguage: article.locale || "nl-NL",
    wordCount: article.content
      ? article.content.split(/\s+/).length
      : undefined,
  };
}

export function generatePersonStructuredData(options: PersonData) {
  return {
    "@context": "https://schema.org",
    "@type": "Person",
    name: options.name,
    ...(options.jobTitle && { jobTitle: options.jobTitle }),
    ...(options.image && { image: options.image }),
    ...(options.sameAs && { sameAs: options.sameAs }),
  };
}

export function generateBreadcrumbStructuredData(options: {
  items: Array<{ name: string; url: string; position: number }>;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: options.items.map((item) => ({
      "@type": "ListItem",
      position: item.position,
      name: item.name,
      item: item.url,
    })),
  };
}
