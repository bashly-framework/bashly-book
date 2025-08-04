---
icon: dot
order: 65
---

# Function Hooks

Bashly provides you with three general purpose hooks that let you inject your
own code. To use a hook, simply create one of the files listed below in your
`src` directory.

!!!success Tip
Run `bashly add hooks` to create the hook files in your source directory.
!!!

| Hook File           | Description
|---------------------|---------------
| `src/initialize.sh` | Execute code inside the `initialize()` function, which is called before anything else.
| `src/before.sh`     | Execute code before calling any command, but after processing the command line input.
| `src/after.sh`      | Execute code after calling any command.

[!button variant="primary" icon="code-review" text="Hooks Example"](https://github.com/bashly-framework/bashly/tree/master/examples/hooks#readme)

## Alternatives

These hooks should be considered a last resort, for any functionality that is not
covered by more native means.

Below is a list of some related features that can
be used instead of using these hooks:

- To change bash runtime parameters (e.g. `set -o pipefail`), use the [`strict` setting](/usage/settings/#strict) instead.
- To verify a program is installed, use [`dependencies`](/configuration/command/#dependencies) instead.
- To verify an environment variable is defined, use [`environment_variables`](/configuration/command/#environment_variables) instead.
- To perform validation operations, use [Custom Validations](/advanced/validations/) instead.
- To halt the execution of the command unless certain conditions are met, use [Custom Filters](/advanced/filters/) instead.


