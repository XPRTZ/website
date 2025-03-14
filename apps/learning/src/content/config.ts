import { defineCollection, z } from 'astro:content';

const lessons = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    languages: z.array(z.enum(['csharp', 'python', 'go'])),
    section: z.string(),
    order: z.number(),
  }),
});

export const collections = {
  lessons,
};
