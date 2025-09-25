---
icon: dot
order: 100
---

# Command

The `command` object serves two purposes, it:

1. Defines the root CLI application (command).
2. Defines any nested subcommands, if any.

==- :icon-code-review: Show Me How
```yaml bashly.yml
name: rush
help: Personal package manager
version: 0.6.5

commands:
- name: add
  alias: a
  help: Register a local repository
  args:
  - name: repo
    required: true
    help: Repository name.

  - name: path
    required: true
    help: Path to the repository.

  examples:
  - rush add default ~/rush-repos/default

- name: remove
  alias: r
  help: Unregister a local repository
  args:
  - name: repo
    required: true
    help: Repository name.

  flags:
  - long: --purge
    short: -p
    help: Also remove the local directory.

  examples:
  - rush remove bobby
  - rush remove bobby --purge
```
===

Unless otherwise specified, these definitions can be used for both the root
command and subcommands (under the `commands` definition).

!!! Note
Most properties are optional, unless specified otherwise.
!!!


## Basic Options

### name

[!badge String] [!badge variant="danger" text="Required"]

The name of the script or subcommand.


### alias

[!badge String / Array of Strings] [!badge variant="warning" text="Subcommands Only"]

One or more additional optional names for this command. This can be used to
create a shortcut for a command, or provide alternative names for it.

This option accepts either a string, or an array of strings.

You can add `*` as a suffix, to denote a *starts with* pattern - for example:

```yaml bashly.yml
name: index
alias: i  # simple shortcut

name: download
alias: d*  # anything that starts with d

name: upload
alias: [u, push]  # upload, u and push will all run the same command
```

[!button variant="primary" icon="code-review" text="Command Aliases Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-aliases#readme)


### help

[!badge String]

The header text to display when using `--help`.

This option can have multiple lines. In this case, the first line will be used
as summary wherever appropriate.

### args

[!badge Array of Arguments]

Specify the array of positional arguments this script needs.

[!ref](argument.md)


### flags

[!badge Array of Flags]

Specify the array of option flags this script needs.

!!! Note
Flags that are defined in a command that has subcommands, are considered
"global flags", and will be available to all subcommands, in addition to any
flag defined in any of the subcommands themselves.

The [docker-like example](https://github.com/bashly-framework/bashly/tree/master/examples/docker-like#readme)
demonstrates this feature.
!!!

[!ref](flag.md)


### commands

[!badge Array of Commands]

Specify the array of commands. Each command will have its own args and flags.

!!! Note
Using `commands` on a given command implies that this command does not have flags or args.
!!!

[!button variant="primary" icon="code-review" text="Commands Example"](https://github.com/bashly-framework/bashly/tree/master/examples/commands#readme) [!button variant="primary" icon="code-review" text="Subcommands Example"](https://github.com/bashly-framework/bashly/tree/master/examples/commands-nested#readme) 



### version

[!badge String] [!badge variant="warning" text="Root Command Only"]

The string to display when using `--version`.



## Common Options


### default

[!badge Boolean / String] [!badge variant="warning" text="Subcommands Only"]

- Setting this to `true` on any command, will cause any **unrecognized**
  command line to be passed to this command.
- Setting this to `force` will also execute this command (instead of showing
  the root usage text) when executed without any arguments.

[!button variant="primary" icon="code-review" text="Default Command Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-default#readme) [!button variant="primary" icon="code-review" text="Forced Command Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-default-force#readme)


### environment_variables

[!badge Array of Environment Variables]

Specify an array of environment variables required or desired by your script. 

[!ref](environment-variable.md)


### examples

[!badge String / Array of Strings]

Specify an array of examples to show when using `--help`, or a multi-line
string. 

[!button variant="primary" icon="code-review" text="Command Examples Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-examples#readme)

### footer

[!badge String]

Add a custom message that will be displayed at the end of the `--help` text. 

[!button variant="primary" icon="code-review" text="Footer Example"](https://github.com/bashly-framework/bashly/tree/master/examples/footer#readme)


### group

[!badge String] [!badge variant="warning" text="Subcommands Only"]

In case you have many commands, use this option to specify a caption to display
before this command.

This option is purely for display purposes.

[!button variant="primary" icon="code-review" text="Command Groups Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-groups#readme)

### variables

[!badge Array of Variables]

Specify an array of variables that can be accessed globally in your script, or subcommands.

[!ref](variable.md)

## Advanced Options

### catch_all

[!badge Boolean / String / Hash]

Specify that this command should allow for additional arbitrary arguments or
flags.

It can be set in one of three ways:

- Set to `true` to just enable it.
- Set to a string, to show this string in the usage help text.
- Set to a hash containing `label`, `help` and `required` keys, to show a
  detailed help for it when running with `--help`. By default, `catch_all`
  arguments are optional, but you can specify `required: true` to require at
  least one argument.

To access arguments captured by `catch_all` in your script, use the
`$other_args` array (or call the `inspect_args` command to see them).

[!button variant="primary" icon="code-review" text="Catch All Example"](https://github.com/bashly-framework/bashly/tree/master/examples/catch-all#readme) [!button variant="primary" icon="code-review" text="Catch All Advanced Example"](https://github.com/bashly-framework/bashly/tree/master/examples/catch-all-advanced#readme)


### completions

[!badge Array of Strings]

Specify an array of additional completion suggestions when used in conjunction
with `bashly add completions`.

[!ref](/advanced/bash-completion.md)


### dependencies

[!badge Array of Strings / Hash / Array of Dependencies]

Specify a list of required external dependencies (commands) required by your
script.

[!ref](dependency.md)

### help_header_override

[!badge String]

Provide an alternative bash code or function call to be executed at the start of
the help message. This is useful for displaying ASCII art when running your CLI
with the `--help` option.

[!button variant="primary" icon="code-review" text="Help Header Override Example"](https://github.com/bashly-framework/bashly/tree/master/examples/help-header-override#readme)

### expose

[!badge Boolean / String] [!badge variant="warning" text="Subcommands Only"]

Setting this to `true` or `always` on any command that has subcommands, will
show its subcommands in the help or usage text of the parent command.

- Set to `true` to show the subcommands only when the parent command is
  executed with `--help`.
- Set to `always` to show the subcommands also when the parent command is
  executed without any arguments.

You can use `expose` with the [`group`](#group) option, to show subcommands
in a logical, visual grouping.

[!button variant="primary" icon="code-review" text="Commands Expose Example"](https://github.com/bashly-framework/bashly/tree/master/examples/commands-expose#readme)


### extensible

[!badge Boolean / String] [!badge variant="warning" text="Root Command Only"]

Specify that this command can be extended by external means.

[!ref](/advanced/extensible-scripts.md)


### filename

[!badge String]

The path (relative to `src`) to the partial source code file, in case you wish
to store your source files in a different path than the default one.

!!!success Tip
To instruct bashly to store *all* command files in sub-directories, see 
[Settings :icon-chevron-right: commands_dir](/usage/settings/#commands_dir)
!!!

[!button variant="primary" icon="code-review" text="Command Filenames Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-filenames#readme)


### filters

[!badge Array of Strings]

Add custom filter functions that will prevent the command from running unless 
certain conditions are met.

[!ref](/advanced/filters)


### function

[!badge String]

The base name of the internal functions bashly will use when generating the
script.

This is useful for scripts that contain several commands that otherwise evaluate
to the same internal function name.

Note that the name specified here is just used as a base name. Bashly will
generate several functions from it:

- `<cli name>_<base function name>_command`
- `<cli name>_<base function name>_usage`
- and possibly more

!!! Note
Under most circumstances you should avoid using this directive. It is provided
as a "last resort" mechanism to help in solving more complex scenarios.
!!!

[!button variant="primary" icon="code-review" text="Command Function Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-function#readme)



### private

[!badge Boolean] [!badge variant="warning" text="Subcommands Only"]

Setting this to `true` on any command, will hide it from the command list.

!!!success Tip
To allow users to see private commands, see
[Settings :icon-chevron-right: private_reveal_key](/usage/settings/#private_reveal_key)
!!!

[!button variant="primary" icon="code-review" text="Private Command Example"](https://github.com/bashly-framework/bashly/tree/master/examples/command-private#readme)
