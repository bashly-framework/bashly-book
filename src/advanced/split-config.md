---
icon: dot
order: 50
---

# Split Config

In case your `bashly.yml` file becomes too large, you may import smaller
configuration snippets by using the `import` keyword.

Loaded configuration snippets can be placed in:

1. Other YAML files, anywhere you want (typically, inside your `src` folder).
2. As a YAML front matter, alongside the shell code that they represent.

## Importing other YAML files

Consider the below, standard `bashly.yml` config:

```yaml bashly.yml
name: cli
help: Sample application

commands:
  name: download
  alias: d
  help: Download something

  args:
  - ...
```

Extracting the `download` command to a separate YAML file, looks like this:

+++ bashly.yml

```yaml bashly.yml
name: cli
help: Sample application

commands:
- import: src/download.yml
- import: ... additional files ...

```

+++ download.yml

```yaml download.yml
name: download
alias: d
help: Download something

args:
- ...
```

+++

## Embedding the YAML definition alongside its bash code

The `import` directive can also be used to load YAML front matter from any text
file. This feature can be useful in case you wish to embed the definition of
the command alongside its source code (shell script).

+++ bashly.yml

```yaml bashly.yml
name: cli
help: Sample application

commands:
- import: src/download_command.sh

```

+++ download_command.sh

```shell download_command.sh
name: download
alias: d
help: Download a file
args:
- name: source
  required: true
  help: File to upload
---
# Your shell script starts here, after the '---' YAML marker
inspect_args

```

+++

## Debugging complex configuration

Running `bashly validate --verbose` shows the configuration file as Bashly sees
it, even if it is invalid. This can be helpful when trying to debug validation
errors for complex configuration files.

[!button variant="primary" icon="code-review" text="Split Config Example"](https://github.com/bashly-framework/bashly/tree/master/examples/split-config#readme)