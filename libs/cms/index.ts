import { Page } from "./models/page.js";
import { Author } from "./models/author.js";
import { Article } from "./models/article.js";
import { Image } from "./models/image.js";
import { ImageWithTitle } from "./models/imageWithTitle.js";
import { ImageComponent } from "./models/imageComponent.js";
import { Tag } from "./models/tag.js";
import { GlobalSettings } from "./models/globalSettings.js";
import { ListItem } from "./models/listItem.js";
import { Mission } from "./models/mission.js";
import { Link } from "./models/link.js";
import { Hero } from "./models/hero.js";

import { HomePage } from "./models/homePage.js";

import fetchData from "./wrapper/api.js";

export {
  fetchData,
  type Page,
  type GlobalSettings,
  type Article,
  type Author,
  type Image,
  type ImageWithTitle,
  type ImageComponent,
  type Tag,
  type ListItem,
  type Mission,
  type Link,
  type Hero,

  type HomePage
};

