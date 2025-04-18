import { ListItem } from "./listItem.js"

export type Mission = {
  __component: "ui.missie-met-statistieken";
  title: string;
  description: string;
  extraDescription: string;
  statistieken: ListItem[];
};

