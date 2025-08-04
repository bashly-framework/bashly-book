---
icon: code
order: 90
---

# Writing Your Scripts

The `bashly generate` command is performing the following actions:

1. Generates placeholder files in the `src` directory - one file for each of the
   defined commands in your `bashly.yml` file. These files are generated only once
   and are never overwritten.
2. Merges all these partial scripts into a single bash script, and saves it in
   the root directory of your project.

## Processing user input

In order to access the parsed arguments in any of your partial scripts, you may
simply access the `$args` associative array.

For example:

+++ Commands

```shell
# Generate a minimal configuration:
$ bashly init --minimal

# Generate the bash script:
$ bashly generate

# Run the script:
$ ./download hello --force
```

+++ Output

```shell
# this file is located in 'src/root_command.sh'
# you can edit it freely and regenerate (it will not be overwritten)
args:
- ${args[--force]} = 1
- ${args[source]} = hello
```

+++

You will notice that all the arguments of the associative array are printed on
screen. This is done by the `inspect_args` function that was inserted into the
generated partial script `src/root_command.sh`.

You can now access these variables by modifying `src/root_command.sh` like
this:

```bash src/root_command.sh
source_url=${args[source]}
force=${args[--force]}

if [[ $force ]]; then
  echo "downloading $source_url with --force"
else
  echo "downloading $source_url"
fi
```

After editing the file, run these commands:

+++ Commands

```shell
# Regenerate the script:
$ bashly generate   # or bashly g for short

# Test its new functionality:
$ ./download a --force
```

+++ Output

```shell
downloading a with --force
```

+++

## Adding common functions

In case you wish to add functions that can be used from multiple locations in
your code, you can place `*.sh` files inside the `src/lib` - these files will
be merged as is to the final bash script.

To get a starting point, you can run the convenience command:

```shell
$ bashly add lib
```

[!button variant="primary" icon="code-review" text="Custom Includes Example"](https://github.com/bashly-framework/bashly/tree/master/examples/custom-includes#readme)

## Hooks

### Initialization

Any code within the `src/initialize.sh` file will be called before anything else
in your generated bash script. 

!!!success Tip
If your script defines [Environment Variables](/configuration/environment-variable)
with [`default`](/configuration/environment-variable/#default) values, these
values will be available to you in the `initialize.sh` file.
!!!

### Before/after hooks

Any code within the `src/before.sh` file will be called before executing any
command, but after processing and validating the command line. Similarly, any
code within the `src/after.sh` file will be called after executing any command.

[!ref](/advanced/hooks)

## Custom header

In case you wish to replace the header in the generated script, simply put the new
content in `src/header.sh`.

!!! Note
Be sure to start your header with a shebang:
`#!/usr/bin/env bash`{style="white-space: nowrap;"}
!!!

!!!success Tip
If you just want to remove the header comment, you can adjust the
[`enable_header_comment`](/usage/settings/#enable_header_comment) setting instead.
!!!

## Hidden comments

Any comment in your source files that begins with two `#` symbols, will be 
removed from the final generated script. This is ideal for adding developer
notes that should not be visible to your end users.

```bash
## this comment will be hidden
# this one will be visible
```
