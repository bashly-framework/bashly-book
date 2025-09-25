---
icon: dot
order: 50
---

# Variable

This option allows you to define bash variables that will be accessible in your
script and its subcommands. While it's possible to define variables directly
within your bash script, this feature provides a structured alternative by
enabling you to centralize variable definitions in the YAML configuration file.

This approach helps to organize your variables separately from the main script
logic, improving readability and maintainability. It is important to note that
using this option is optional, and you can continue to define variables
directly in your bash script if preferred.

==- :icon-code-review: Show Me How
```yaml bashly.yml
variables:
  # Simple value
  - name: output_folder
    value: output

  # Array
  - name: download_sources
    value:
    - youtube
    - instagram

  # Associative array
  - name: zip_options
    value:
      pattern: "*.json"
      compression_level: fast
```
===

!!!success Tip 
Variables defined in the root command are available globally (in the
`initialize()` function), while those defined in subcommands are only accessible
within those specific commands.
!!!

[!button variant="primary" icon="code-review" text="Variables Example"](https://github.com/bashly-framework/bashly/tree/master/examples/variables#readme)

## Basic Options

### name

[!badge String] [!badge variant="danger" text="Required"]

The name of the variable.

### value

[!badge Any Type]

The variable's value can be a simple type such as a string, number, or boolean,
or a one-level complex structure like an array or associative array (hash).
