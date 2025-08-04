---
icon: dot
order: 40
---

# Extensible Scripts

You may configure your generated bash script to delegate any unknown command to an external executable, by setting the `extensible` option to either `true`, or to a different external command.

This is similar to how `git` works. When you execute `git whatever`, the `git` command will look for a file named `git-whatever` in the path, and execute it.

!!! Note
The `extensible` option cannot be specified together with the `default` option,
since both specify a handler for unknown commands.
!!!

The `extensible` option supports two operation modes:

## Extension mode

`extensible: true`

By setting `extensible` to `true`, a specially named executable will be called when an unknown command is called by the user.

Given this configuration:

```yaml bashly.yml
name: myscript
help: Example
version: 0.1.0
extensible: true

commands:
- name: upload
  help: Upload a file
```

And this user command:

```shell
$ myscript something

```

The generated script will look for an executable named `myscript-something` in the path. If found, it will be called.

[!button variant="primary" icon="code-review" text="Extensible Extension Example"](https://github.com/bashly-framework/bashly/tree/master/examples/extensible#readme)

## Delegate mode

`extensible: <executable name>`

By setting `extensible` to any string, unknown command calls by the user will be delegated to the executable with that name.

Given this configuration:

```yaml bashly.yml
name: mygit
help: Example
version: 0.1.0
extensible: git

commands:
- name: push
  help: Push to my repository
```

And this user command:

```shell
$ mygit status

```

The generated script will execute `git status`.

[!button variant="primary" icon="code-review" text="Extensible Delegate Example"](https://github.com/bashly-framework/bashly/tree/master/examples/extensible-delegate#readme)

