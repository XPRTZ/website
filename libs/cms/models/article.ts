import { Author } from "./author.js";
import { Image } from "./image.js";
import { Tag } from "./tag.js";

export type Article = {
  title: string;
  content: string;
  authors: Author[];
  date: string;
  slug: string;
  image: Image;
  tags: Tag[];
  site: string;
  locale: string;
  documentId: string;
}
