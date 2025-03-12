import { visit } from 'unist-util-visit';

export function remarkSolution() {
  return (tree) => {
    visit(tree, (node) => {
      if (
        node.type === 'containerDirective' ||
        node.type === 'leafDirective' ||
        node.type === 'textDirective'
      ) {
        if (node.name !== 'solution') return;

        const data = node.data || (node.data = {});
        data.hName = 'Collapsible';
        data.hProperties = {
          ...node.attributes,
          title: 'Solution',
          defaultOpen: false
        };
      }
    });

    visit(tree, 'code', (node, index, parent) => {
      let isInSolution = false;
      let current = parent;

      while (current && current.parent) {
        if (current.type === 'containerDirective' && current.name === 'solution') {
          isInSolution = true;
          break;
        }
        current = current.parent;
      }

      if (isInSolution) return;

      const language = node.lang || 'text';
      let title = language.charAt(0).toUpperCase() + language.slice(1) + ' Code';

      if (language === 'csharp') title = 'C# Code';
      else if (language === 'python') title = 'Python Code';
      else if (language === 'go') title = 'Go Code';

      const codeWrapper = {
        type: 'paragraph',
        children: [node],
        data: {
          hProperties: {
            className: 'code-block'
          }
        }
      };

      const collapsibleNode = {
        type: 'mdxJsxFlowElement',
        name: 'Collapsible',
        attributes: [
          {
            type: 'mdxJsxAttribute',
            name: 'title',
            value: title
          },
          {
            type: 'mdxJsxAttribute',
            name: 'defaultOpen',
            value: false
          }
        ],
        children: [codeWrapper],
        data: { _mdxExplicitJsx: true }
      };

      parent.children[index] = collapsibleNode;
    });
  };
}
