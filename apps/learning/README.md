# XPRTZ Learning Platform

A modern, interactive learning platform for creating engaging learning experiences.

## Getting Started

### Prerequisites

- Node.js (v20 or newer)
- npm

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourname/polyglot-programming.git
   cd learning
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. Open your browser and navigate to `http://localhost:4321`

## Available Commands

| Command                   | Description                                      |
|:--------------------------|:-------------------------------------------------|
| `npm run dev`             | Start local dev server at `localhost:4321`       |
| `npm run build`           | Build your production site to `./dist/`          |
| `npm run preview`         | Preview your build locally before deploying      |
| `npm run astro -- --help` | Get help using the Astro CLI                     |

## Creating Content

This platform is built around MDX files to create interactive course content. Here's how to add and structure your own lessons:

### Folder Structure

```
src/
├── content/
│   └── lessons/
│       ├── 01-basics/
│       │   ├── 01-getting-started.mdx
│       │   ├── 02-variables.mdx
│       │   └── ...
│       ├── 02-control-flow/
│       │   ├── 01-conditionals.mdx
│       │   └── ...
│       └── ...
```

The numeric prefixes (`01-`, `02-`) determine the order of sections and lessons in the navigation.

### Creating a new lesson

1. Create a new `.mdx` file in the appropriate section folder (or create a new section folder if needed)
2. Add the required frontmatter
3. Write your lesson content using Markdown and MDX components

### Frontmatter requirements

Each lesson MDX file needs the following frontmatter:

```mdx
---
title: "Your Lesson Title"
description: "A brief description of the lesson"
section: "01-Basics"  # Must match the section folder name
order: 2              # Determines order within section
languages: ["csharp", "python", "go"]  # Languages used in this lesson
---

# Your lesson content here
```

### Using the Collapsible component

The platform includes a `Collapsible` component that's perfect for creating expandable/collapsible sections, such as solution blocks or code examples:

```markdown
<Collapsible title="C# Solution">
```csharp
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Hello, World!");
    }
}
{close markdown here with ```}
</Collapsible>
```

You can use this component anywhere in your MDX files without needing to import it. This will should the component collapsed by default, but you can set it to open by default by adding the `defaultOpen={true}` prop.

## Navigation Features

- **Collapsible sections**: click on section headers to collapse/expand lesson lists within each section
- **Next/Previous navigation**: move between lessons sequentially using the navigation buttons at the bottom of each lesson

## Customization

### Styling

The platform uses Tailwind CSS for styling. You can modify the appearance by:

- Editing the Tailwind configuration in `tailwind.config.mjs`
- Modifying component styles in their respective `.astro` files
- Adding custom CSS in the `<style>` sections of components

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

[MIT License](LICENSE)
