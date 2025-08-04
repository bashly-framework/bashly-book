---
icon: tools
order: 80
---

# Settings

Some of bashly's commands can be tweaked through the use of environment
variables, or a settings file.

## Settings file

If you wish to load settings from a configuration file, you can generate an
initial settings file by running:

```shell
$ bashly add settings
```

which will create the default `settings.yml` file in the working directory.

Bashly will look for the settings file in one of these paths:

- A path set in the environment variable `BASHLY_SETTINGS_PATH`.
- A file named `bashly-settings.yml` in the working directory.
- A file named `settings.yml` in the working directory.

!!!success YAML Tips
- The words `yes` and `no` are equivalent to `true` and `false`
- To specify a `null` value, use `~`
!!!

[!button variant="primary" icon="code-review" text="Settings Example"](https://github.com/bashly-framework/bashly/tree/master/examples/settings#readme)

## Environment variables

All settings are optional (with their default values provided below), and
can also be set with an environment variable with the same name, capitalized
and prefixed by `BASHLY_` - for example: `BASHLY_SOURCE_DIR`

When setting environment variables, you can use:

- `0`, `false` or `no` to represent false
- `1`, `true` or `yes` to represent true

## Path Options

### `source_dir`

```yaml
# default
source_dir: src
```

Set the path containing the bashly source files.

### `config_path`

```yaml
# default
config_path: "%{source_dir}/bashly.yml"
```

Set the path to bashly.yml. You can use the special token `%{source_dir}` to
reference the value of the `source_dir` option.

### `target_dir`

```yaml
# default
target_dir: .
```

Set the path to use for creating the final bash script.

### `lib_dir`

```yaml
# default
lib_dir: lib
```

Set the path to use for common library files, relative to `source_dir`.

### `commands_dir`

```yaml
# default
commands_dir: ~

# example
commands_dir: commands
```

Set the path to use for command files, relative to `source_dir`.

- When set to `nil` (denoted by `~`), command files will be placed directly under `source_dir`.
- When set to any other string, command files will be placed under this
  directory, and each command will get its own sub-directory.

In case you plan on creating a large script with many commands, it is
recommended to enable this by setting it to something like
`commands_dir: commands`.

[!button variant="primary" icon="code-review" text="Command Paths Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-paths#readme)

### `partials_extension`

```yaml
# default
partials_extension: sh

# example
partials_extension: bash
```

Set the extension to use when reading/writing partial script snippets.

## Format Options

### `strict`

```yaml
# default
strict: false

# examples
strict: true
strict: ''
strict: set -o pipefail
```

Specify which bash options to apply on initialization.

- `strict: true` - Bash strict mode (`set -euo pipefail`)
- `strict: false` - Only exit on errors (`set -e`)
- `strict: ''` - Do not add any `set` directive
- `strict: <string>` - Add any other custom `set` directive, for example
   `strict: set -o pipefail`{style="white-space: nowrap;"}

### `tab_indent`

```yaml
# default
tab_indent: false
```

Specify the indentation style of the generated script.

- `tab_indent: false` - Indent with two spaces.
- `tab_indent: true` - Indent with Tab (every 2 leading spaces will be converted
   to a tab character).

## Interface Options

### `compact_short_flags`

```yaml
# default
compact_short_flags: true
```

Specify how the generated script should treat flags in the form of `-abc`

- `compact_short_flags: true` - Expand `-abc` to `-a -b -c`.
- `compact_short_flags: false` - Do not expand `-abc` (consider this an invalid input).

### `conjoined_flag_args`

```yaml
# default
conjoined_flag_args: true
```

Specify how the generated script should treat flags in the form of `--flag=value`
or `-f=value`

- `conjoined_flag_args: true` - Expand `--flag=value` to `--flag value` and `-f=value` to `-f value`.
- `conjoined_flag_args: false` - Do not expand `--flag=value` or `-f=value` (consider this an invalid input).

### `show_examples_on_error`

```yaml
# default
show_examples_on_error: false
```

Specify if you want to show the
[command examples](/configuration/command/#examples) whenever the user fails to 
provide the required arguments.

[!button variant="primary" icon="code-review" text="Show Examples on Error Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-examples-on-error#readme)

### `private_reveal_key`

```yaml
# default
private_reveal_key: ~

# example
private_reveal_key: ADVANCED_FEATURES
```

When using private commands, flags, or environment variables, you may set 
this option to a name of an environment variable that, if set, will reveal
all the private elements in the usage texts, as if they were public.

[!button variant="primary" icon="code-review" text="Private Reveal Example"](https://github.com/bashly-framework/bashly/tree/master/examples/private-reveal#readme)

### `usage_colors`

```yaml
# default
usage_colors:
  caption: ~
  command: ~
  arg: ~
  flag: ~
  environment_variable: ~

# example
usage_colors:
  caption: bold
  command: green_underlined
  arg: blue
  flag: magenta
  environment_variable: cyan_bold
```

Enable color output for several aspects of the help message of the generated
script. Each of these options may be a name of a color function that exists in
your script, for example: `green` or `bold`.

You can run `bashly add colors` to add a standard colors library.

!!! Note
This option cannot be set using environment variables.
!!!

[!button variant="primary" icon="code-review" text="Usage Colors Example"](https://github.com/bashly-framework/bashly/tree/master/examples/colors-usage#readme)

## Feature Toggles

### `env`

```yaml
# default
env: development
```

Specify one of two script rendering environments:

- `env: development` - Generate a script suitable for development, which is usually slightly larger
   and contains additional development-specific features.
- `env: production` -  Generate a script suitable for distribution, which is usually smaller.

Use the `enable_*` options below to adjust settings for each environment.

!!! Note
It is recommended to leave this set to `development` in the settings file, and
use either the `BASHLY_ENV` environment variable or the
`bashly generate --env production` command when the slimmer production script is needed.
!!!


### `enable_header_comment`

```yaml
# default (allowed: always, never, development, production)
enable_header_comment: always
```

Specify if you wish to render the "do not modify" comment at the beginning of
the script.

### `enable_bash3_bouncer`

```yaml
# default (allowed: always, never, development, production)
enable_bash3_bouncer: always
```

Specify if you wish to render the piece of code that aborts the script execution
when bash version is < 4.

### `enable_view_markers`

```yaml
# default (allowed: always, never, development, production)
enable_view_markers: development
```

Specify if you want the rendered script to include view marker comments.

View markers provide the name of the internal bashly template (view) or the
path to the user's partial code files in the final script, to help locate
the source file for each piece of code.

### `enable_inspect_args`

```yaml
# default (allowed: always, never, development, production)
enable_inspect_args: development
```

Specify if you want the rendered script to include the `inspect_args()` function.

The `inspect_args()` function can help in reviewing the input for each command.

### `enable_deps_array`

```yaml
# default (allowed: always, never, development, production)
enable_deps_array: always
```

Specify if you want to populate the `$deps` bash array.

This is applicable only if your script uses the
[Dependency](/configuration/dependency) configuration option.

### `enable_env_var_names_array`

```yaml
# default (allowed: always, never, development, production)
enable_env_var_names_array: always
```

Specify if you want to populate the `$env_var_names` bash array.

This is applicable only if your script uses the
[Environment Variable](/configuration/environment-variable) configuration option.

### `enable_sourcing`

```yaml
# default (allowed: always, never, development, production)
enable_sourcing: development
```

Specify if you want the generated script to include a condition that checks if
the script was sourced and only execute it if it is not.

## Scripting Options

### `var_aliases`

```yaml
# default
var_aliases:
  args: ~
  other_args: ~
  deps: ~
  env_var_names: ~

# example
var_aliases:
  args: ARGS
  other_args: catch_all
  deps: dependencies
  env_var_names: ENV_VARS
```

Update one or more of these options in case you wish to change the name of the
public global array that bashly uses for storing data.

Note that this feature will not change the original name, but rather create
an alias using `declare -gn`.

!!! Note
This option cannot be set using environment variables.
!!!

### `function_names`

```yaml
# default
function_names:
  run: ~
  initialize: ~

# example
function_names:
  run: bashly_run
  initialize: bashly_initialize
```

Update one or more of these options in case you wish to change the name of the
equivalent internal bashly function.

This feature can be useful when you wish to reserve the function name `run` or
`initialize` for something else.

!!! Note
This option cannot be set using environment variables.
!!!
