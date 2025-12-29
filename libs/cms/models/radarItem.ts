import { ListItem } from "./listItem.js";
import { Tag } from "./tag.js";

export type RadarQuadrant = "Technieken" | "Tools" | "Platformen" | "Talen & Frameworks";
export type RadarRing = "Adopt" | "Trial" | "Assess" | "Hold";

export type RadarItem = {
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

export type RadarItemWithNumber = RadarItem & {
  number: number;
}
