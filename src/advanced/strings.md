---
icon: dot
order: 100
---

# Custom Strings

Bashly lets you control all the strings emitted by your generated bash script.

Most of these strings (for example, help messages) are configured as part of
your `bashly.yml` configuration file.

However, if you also wish to customize other strings (for example, error
messages), you will need to add a file named `bashly-strings.yml` to your 
`src` folder.

To do so, run:

```bash
$ bashly add strings
```

This will add a configuration file with all the internal strings for you to
configure.

For example:

```yaml
flag_requires_an_argument: "%{name} requires an argument: %{usage}"
invalid_argument: "invalid argument: %s"
```

!!! Note
Some strings contain special tokens, such as `%s` and `%{name}`.
These will be replaced at runtime and you should keep them in your custom
strings.
!!!

[!button variant="primary" icon="code-review" text="Custom Strings Example"](https://github.com/bashly-framework/bashly/tree/master/examples/custom-strings#readme)
