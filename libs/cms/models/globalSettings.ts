import { Page } from "../index.js";
import { AlgemeneVoorwaarden } from "./algemeneVoorwaarden.js";
import { Social } from "./social.js";

export type GlobalSettings = {
  documentId: string;
  site: string;
  locale: string;
  pages: Page[] | null;
  algemeneVoorwaarden: AlgemeneVoorwaarden;
  socials: Social[];
  straat: string;
  postcode: string;
  gemeente: string;
};

