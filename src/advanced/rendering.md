---
icon: dot
order: 35
---

# Rendering Documentation

## Overview

Bashly is capable of rendering documentation for your script based on
your `bashly.yml` configuration by using the `bashly render` command.

This command can generate any kind of output using either templates that are 
built into Bashly (for example Markdown or man pages), or by using
any custom templates.

## Built-in templates

Bashly comes with several documentation templates. In order to see a list of
all templates, run:

```bash
$ bashly render --list
```

Some built-in templates may have special optional features that let you
customize the output. Learn more about each template by running:

```bash
$ bashly render SOURCE --about
# for example
$ bashly render :mandoc --about
```

## Example

[!button variant="primary" icon="code-review" text="Markdown Example"](https://github.com/bashly-framework/bashly/tree/master/examples/render-markdown#readme) [!button variant="primary" icon="code-review" text="Mandoc Example"](https://github.com/bashly-framework/bashly/tree/master/examples/render-mandoc#readme)

## Custom templates

### Create your own

To create custom templates, it is recommended to use one of the built-in
templates as a starting point. To copy the template source code to your project
run:

```bash
$ bashly add render_markdown
# or
$ bashly add render_mandoc
```

!!! Note
Creating custom templates requires some minimal understanding of Ruby.
!!!

### Template structure

Template directories are expected to:

1. Have a `render.rb` file  
   Will be executed when running `bashly render`.
2. Have a `README.md` file  
   Will be shown when running with `--about`.

The `render.rb` file will be executed when running `bashly render` and 
will have access to these variables and methods:

| Variable  | Description
|-----------|---------
| `command` | The root command of your bashly script ([`Bashly::Script::Command`](https://github.com/bashly-framework/bashly/blob/master/lib/bashly/script/command.rb)).
| `source`  | A string containing the path to the template source directory.
| `target`  | A string containing the path to the target directory, as provided by the user at run time (`bashly render SOURCE TARGET`).
| `show`    | A string that will contain the value of `--show PATH` if provided by the user at runtime.

| Method | Description
|--------|-------------
| `save` | The method your script should call in order to save an output file.
| `say`  | Print a message with colors (see [Colsole](https://github.com/dannyben/colsole))

The `render.rb` script is executed with the [`Bashly::RenderContext`](https://github.com/bashly-framework/bashly/blob/master/lib/bashly/render_context.rb) context.

### Render script example

This approach allows you to use any template engine that is available in Ruby.

For example, this `render.rb` file uses GTX to render the markdown
documentation:

```ruby render.rb
# render script - markdown
require 'gtx'

# for previewing only (not needed for rendering)
require 'tty-markdown'

# Load the GTX template
template = "#{source}/markdown.gtx"
gtx = GTX.load_file template

# Render the file for the main command
save "#{target}/index.md", gtx.parse(command)

# Render a file for each subcommand
command.deep_commands.reject(&:private).each do |subcommand|
  save "#{target}/#{subcommand.full_name}.md", gtx.parse(subcommand)
end

# Show one of the files if requested
if show
  file = "#{target}/#{show}"
  puts TTY::Markdown.parse_file(file) if File.exist?(file)
end
```

[!button variant="primary" icon="mark-github" text="See it on GitHub"](https://github.com/bashly-framework/bashly/tree/master/lib/bashly/libraries/render/markdown)

### Custom properties

The `bashly.yml` allows the use of arbitrary properties. Any property that starts with `x_` is
ignored by the validation process, and is therefore allowed.

You can use this functionality to add properties that can be used in your
rendering templates. See one of the built-in templates for usage example.
