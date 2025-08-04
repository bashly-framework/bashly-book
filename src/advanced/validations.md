---
icon: dot
order: 80
---

# Custom Validations

Bashly supports custom validation functions for your arguments, flag
arguments, and environment variables. This is how it works:

1. In your bashly configuration file, arguments and flags (with arguments)
   may have a `validate: function_name` option.
2. Whenever you run your script, it will look for a function with that name,
   prefixed by `validate_` and will run it before allowing the user
   input to pass.
3. If the function returns any string, it is considered an error. The
   string will be displayed on screen, as the error message.

+++ Configuration

```yaml bashly.yml
name: viewer

args:
- name: path
  validate: file_exists
```

+++ Custom Function

```shell src/lib/validate_file_exists.sh
validate_file_exists() {
  [[ -f "$1" ]] || echo "must be an existing file"
}
```

+++


## Built-in Custom Validations

In addition, bashly comes with several built-in custom validations for common
tasks:

- `file_exists` - Ensures that the argument points to a file.
- `dir_exists` - Ensures that the argument points to a directory.
- `integer` - Ensures that the argument is an integer.
- `not_empty` - Ensures that the argument is not empty.

In order to add these validations to your code, run:

```bash
$ bashly add validations
```

[!button variant="primary" icon="code-review" text="Validations Example"](https://github.com/bashly-framework/bashly/tree/master/examples/validations#readme)
