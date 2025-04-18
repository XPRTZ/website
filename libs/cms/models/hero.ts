import { Link } from "./link.js";
import { Image } from "./image.js";

export type Hero = {
  __component: "ui.hero";
  id: number;
  title: string;
  description: string;
  CTO: Link;
  link: Link;
  images: Image[];
};

