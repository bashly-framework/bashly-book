---
icon: dot
order: 90
---

# Library Functions

Bashly comes with a set of library functions that can be added to your script
by running the `bashly add` command. All libraries are documented inline, and
the documentation below is a high level overview with examples.

!!!success Tip
Run `bashly add --list` to see all available libraries.
!!!



## YAML parser

Adds the ability to read YAML files in your bash script.

```bash
$ bashly add yaml
````

==- :icon-code-review: Usage Example

```bash
yaml_load "settings.yml"             # print variables
yaml_load "settings.yml" "config_"   # use prefix
eval $(yaml_load "settings.yml")     # create variables in scope
````

[!button variant="primary" icon="code-review" text="YAML Example on GitHub"](https://github.com/bashly-framework/bashly/tree/master/examples/yaml#readme)

===



## Config (INI) handler

Adds the ability to create, read and write configuration INI files. This library
uses the [ini library](#ini-handler) under the hood for loading and saving the
INI files.

```bash
$ bashly add config
```

==- :icon-code-review: Usage Example

```bash
# Add or update a key=value pair in the config.
config_set username Operations

# Use dot notation to specify an INI section ([login] in this case).
config_set login.email paul@section.one

# Get the value from the config file.
result=$(config_get login.username)

# Delete a key from the config.
config_del username

# Show the config file.
config_show

# Return an array of the keys in the config file
for key in $(config_keys); do
  echo "- $key = $(config_get "$key")";
done

# Returns true if the specified key exists in the config file
if config_has_key "key" ; then
  echo "key exists"
fi
```

[!button variant="primary" icon="code-review" text="Config Example on GitHub"](https://github.com/bashly-framework/bashly/tree/master/examples/config#readme)

===



## INI handler

Adds the ability to load and save INI files. This is a low-level library that
is used by the [config library](#config-ini-handler).

```bash
$ bashly add ini
```

==- :icon-code-review: Usage Example

```bash
# Load an INI file into the `ini` associative array.
ini_load 'path/to/file.ini'

# Save the associative array back to the INI file.
ini_save 'path/to/file.ini'

# Access a value
name=${ini[key]}
name=${ini[section.key]}
name=${ini[section.key]:-default}

# Create/update a value
ini[section.key]="new value"
ini_save

# Delete a value
unset ini[section.key]
ini_save

# Show the loaded values
ini_show
```

[!button variant="primary" icon="code-review" text="INI Example"](https://github.com/bashly-framework/bashly/tree/master/examples/ini#readme)

===



## Color output

Adds functions for printing colored strings.

```bash
$ bashly add colors
```

==- :icon-code-review: Usage Example

```bash
echo "before $(red this is red) after"
echo "before $(green_bold this is green_bold) after"
```

See the generated script in `src/lib/colors.sh` for the full list of colors.

[!button variant="primary" icon="code-review" text="Colors Example"](https://github.com/bashly-framework/bashly/tree/master/examples/colors#readme)

===



## Auto-update

Files added by the `bashly add *` commands can be automatically updated to their
original state by running

```bash
bashly generate --upgrade
````

The `--upgrade` flag will scan all the files in the `src/lib` directory for a 
special magic comment in this format:

```
[@bashly-upgrade <library>]
```

When found, and assuming the path of the file matches the one in the library,
this file will be updated.

You are encouraged to modify the generated library functions to your liking, but
if you do so, remember to remove this magic comment to prevent accidentally 
overriding it in future runs of `bashly generate --upgrade`.



## See also

[!ref](/advanced/lib-source/)
