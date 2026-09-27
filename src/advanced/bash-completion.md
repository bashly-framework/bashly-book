---
icon: dot
order: 60
---

# Runtime Completions

Bashly can generate native runtime completions for your application. The
generated completion script suggests commands, aliases, flags, positional
arguments with `allowed` values, and flag arguments with `allowed` values.

Runtime completions are disabled by default. Bashly provides adapters for Bash
and Zsh.

## Enable runtime completions

Enable the runtime engine and all available shell adapters in your Bashly
settings file:

```yaml settings.yml
completions: full
```

Add a command that users can call to generate the completion script:

```yaml bashly.yml
commands:
- name: completions
  help: Generate a shell completion script
  args:
  - name: shell
    help: Shell to generate completions for
    allowed: [bash, zsh]
    default: bash
```

In the command handler, call `send_completions` with the requested shell:

```bash src/completions_command.sh
send_completions "${args[shell]}"
```

After regenerating your application, users can load its completion script in
their shell:

```bash
# Bash
source <(cli completions bash)

# Zsh
source <(cli completions zsh)
```

Replace `cli` with the name or path of your generated application.

[!button variant="primary" icon="code-review" text="Runtime Completions Example"](https://github.com/bashly-framework/bashly/tree/master/examples/completions#readme)

## Configure completion candidates

In addition to the candidates Bashly generates automatically, you can
configure custom completions for positional arguments and flags that have an
`arg`.

The `completions` mapping accepts three optional keys:

- `static`: literal completion candidates.
- `dynamic`: Bash commands that print completion candidates.
- `options`: completion behavior and filesystem candidate sources.

### Static candidates

Use `static` for literal suggestions:

```yaml bashly.yml
args:
- name: environment
  help: Environment to deploy to
  completions:
    static:
      - staging
      - production
```

!!! Note
Use [`allowed`](/configuration/argument/#allowed) when values should be
validated. Use `completions.static` when they should only be suggested.
Values configured with `allowed` are suggested automatically.
!!!

### Dynamic candidates

Use `dynamic` to run external commands or Bash functions included in your
generated application:

```yaml bashly.yml
args:
- name: branch
  help: Branch to deploy
  completions:
    dynamic:
      - git branch --format='%(refname:short)'
      - completion_branches
```

Each command or function must print one candidate per line to standard output.
A producer that fails contributes no candidates. Its failure and error output
do not fail or pollute the overall completion request.

!!! Note
Dynamic entries run whenever the user requests a completion. Keep them fast
and side-effect free.
!!!

### Completion options

Use `options` to add filesystem candidates or change how an inserted
completion behaves:

```yaml bashly.yml
flags:
- long: --config
  arg: file
  help: Configuration file
  completions:
    options: [files]

- long: --directory
  arg: path
  help: Working directory
  completions:
    options: [directories]
```

The supported options are:

- `files`: add file and directory candidates.
- `directories`: add directory candidates only.
- `no-space`: do not append a space after inserting a completion.

Filesystem completion is not implicit. Without `files` or `directories`, the
shell uses only candidates returned by Bashly.

Normal spacing is the default. Use `no-space` only when the user should
continue typing immediately after the inserted candidate. Candidate
de-duplication is always enabled and is not configurable.

## Combine completion sources

You can combine `static`, `dynamic`, and `options` on the same argument or
flag:

```yaml bashly.yml
args:
- name: environment
  help: Environment to deploy to
  completions:
    static: [staging, production]
    dynamic: [completion_environments]
    options: [no-space]
```

## Test completion candidates

The generated application includes an internal `__complete` command. You can
use it to inspect the raw candidates returned for a command line without
loading the completion script:

```bash
cli __complete deploy main st
```

Each argument after `__complete` represents one word in the command line. Pass
an empty final argument to represent the blank word after a trailing space:

```bash
cli __complete deploy --config ""
```

Candidate lines are written to standard output, followed by an internal
`:options=` line used by the shell adapters. This makes `__complete`
useful when testing custom `static`, `dynamic`, or filesystem completions.

!!! Note
`__complete` is an internal completion endpoint intended for testing and shell
integration. Users should normally load completions with
`source <(cli completions bash)` or `source <(cli completions zsh)`.
!!!

[!button variant="primary" icon="code-review" text="Advanced Completions Example"](https://github.com/bashly-framework/bashly/tree/master/examples/completions-advanced#readme)
