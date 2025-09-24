---
icon: dot
order: 90
---

# Argument

Specify positional arguments (required or optional) used by your script.

==- :icon-code-review: Show Me How
```yaml bashly.yml
args:
  - name: user
    help: AWS Username.
    required: true

  - name: role
    help: User role.
    default: admin
    allowed:
      - admin
      - guest

  - name: key
    help: Path to SSH key.
    validate: file_exists
```
===


The argument's value will be available to you as `${args[name]}` in your bash
function.

!!! Note
Most properties are optional, unless specified otherwise.
!!!


## Basic Options

### name

[!badge String]
[!badge variant="danger" text="Required"]

The name of the argument. Use lowercase letters, since it serves multiple
purposes:

- It will be capitalized in the help text.
- It will be used as the hash key in the `${args[...]}` associative bash array.


### help

[!badge String]

The message to display when using `--help`. Can have multiple lines.


## Common Options


### default

[!badge String / Array of Strings]

The value to use in case it is not provided by the user. Implies that this
argument is optional.

When using [`repeatable`](#repeatable), you may provide an array here. It will
be provided to your script as a space delimited string (similar to how it is
provided when the user inputs values).

[!button variant="primary" icon="code-review" text="Default Values Example"](https://github.com/bashly-framework/bashly/tree/master/examples/default-values#readme)


### required

[!badge Boolean]

Specify that this argument is required.

!!! Note
Once you define an optional argument (without `required: true`) then you cannot
define required arguments after it.
!!!


## Advanced Options

### allowed

[!badge Array of Strings]

Limit the allowed values to a specified whitelist. Can be used in conjunction
with [`default`](#default) or [`required`](#required).

[!button variant="primary" icon="code-review" text="Whitelist Example"](https://github.com/bashly-framework/bashly/tree/master/examples/whitelist#readme)


### repeatable

[!badge Boolean]

Specify that this argument can be provided multiple times.

The received value will be formatted as a quoted, space-delimited string which
you will need to convert to array with something like
`eval "data=(${args[path]})"`.

[!button variant="primary" icon="code-review" text="Repeatable Argument Example"](https://github.com/bashly-framework/bashly/tree/master/examples/repeatable-arg#readme)

### unique

[!badge Boolean]

Specify that the values for this `repeatable` argument must be unique.
Non-unique values will be ignored.


### validate

[!badge String / Array of Strings]

Apply a custom validation function.

[!ref](/advanced/validations)
