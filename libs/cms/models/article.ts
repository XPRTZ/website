import { Author } from "./author.js";
import { Image } from "./image.js";

export type Article = {
  title: string;
  content: string;
  authors: Author[];
  date: string;
  slug: string;
  image: Image;
  tags: string[];
  site: string;
  locale: string;
  documentId: string;
}
