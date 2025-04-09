import { Image } from "./image.js";

export type Author = {
  firstname: string;
  lastname: string;
  email: string;
  gitHub: string;
  bio: string;
  avatar: Image;
  jobTitle: string;
}
