---
icon: dot
order: 60
---

# Dependency

Specify a list of required external dependencies (commands). The script
execution will be halted with a friendly error unless all dependency commands
exist.

==- :icon-code-review: Show Me How
```yaml bashly.yml
# Array syntax
dependencies:
- docker
- curl

# Simple hash syntax, to provide additional (optional) help message
dependencies:
  docker: see https://docker.com for installation instructions
  git: "install by running: sudo apt install git"
  ruby:

# Explicit hash syntax, to provide additional help message and
# look for "one of" a given list of dependencies
dependencies:
  http_client:
    command: [curl, wget]
    help: Run 'sudo apt install curl' or 'sudo apt install wget'
```
===

This configuration option can be provided in one of three ways:

- A simple array, just listing the needed dependencies.
- A hash specifying an additional help message to show in case the dependency is
  not installed (for example, to provide installation instructions).
- A hash of hashes, providing a list of commands for a single dependency, and
  an optional help message. This is designed to provide an "or" functionality
  for a single dependency (for example: curl or wget).

When a command defines `dependencies`, it will also have the paths of the found
dependencies in an associative array named `deps`. Call the `inspect_args`
function from your command code to see this array.

[!button variant="primary" icon="code-review" text="Dependencies Example"](https://github.com/bashly-framework/bashly/tree/master/examples/dependencies#readme) [!button variant="primary" icon="code-review" text="Alternate Dependencies Example"](https://github.com/bashly-framework/bashly/tree/master/examples/dependencies-alt#readme)

## Basic Options

These options are valid when using the explicit hash syntax.

### command

[!badge Array of Strings]
[!badge variant="danger" text="Required"]

One or more commands that are required by your script. If more than one is
provided, the dependency will be considered as satisfied if any of the commands
exist.

For example, given this configuration:

```yaml bashly.yml
dependencies:
  http_client:
    command: [curl, wget]
    help: run 'sudo apt install curl' or 'sudo apt install wget'
```

the script will exit with the following error if both `curl` and `wget` are
not available:

```
$ ./myscript
missing dependency: http_client (curl/wget)
run 'sudo apt install curl' or 'sudo apt install wget'
```

### help

[!badge String]

An additional optional help message to show when the dependency is not met. 
This can be useful for providing installation instructions or a download URL.
