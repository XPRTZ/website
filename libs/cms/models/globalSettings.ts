import { Page } from "../index.js";

export type GlobalSettings = {
  documentId: string;
  site: string;
  locale: string;
  pages: Page[] | null;
}
