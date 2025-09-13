---
icon: mortar-board
order: 95
---

# Bashly Tutorial

In this tutorial we're going to create a random number generator to show some basic Bashly features.

The app is going to be called `rndm`.

## Starting the Project

Create a directory for our project:

```bash
mkdir rndm
cd rndm
```

A way to start a Bashly project is by running `bashly init`, which creates the `src/bashly.yml`.

You'll note that the file comes filled with some data, but for this tutorial we're going to write our `bashly.yml` from scratch, learning each configuration.

Open your `src/bashly.yml`, remove all its contents and add this:

```yaml
name: rndm
help: Prints a random number
version: 0.0.1
```

Now we can run `bashly generate` and see an output like this:

```
$ bashly generate
creating user files in src
created src/root_command.sh
created ./rndm
run ./rndm --help to test your bash script
```

Let's do exactly what it's suggesting:

```
$ ./rndm --help
rndm - Prints a random number

Usage:
  rndm
  rndm --help | -h
  rndm --version | -v

Options:
  --help, -h
    Show this help

  --version, -v
    Show version number
```

We didn't write a single bash line and look at that beautiful help message we already have!

In simple terms, this is what Bashly did:

1. read the `src/bashly.yml` file
2. understood that we want to create a script named `rndm`
3. read the script's description in the `help:` directive
4. read the script's version in `version:`
5. created a file named `src/root_command.sh`
6. generated the final script `rndm`

One thing we already noticed is that the `rndm` script was already generated with a `--help` and `--version` feature.

The final `rndm` script is "self-contained", which means that you can distribute it to anyone with bash available to run it (as long as you don't introduce external dependencies, which we'll talk about soon).

Let's take a look at the `src/root_command.sh`:

```bash
echo "# This file is located at 'src/root_command.sh'."
echo "# It contains the implementation for the 'rndm' command."
echo "# The code you write here will be wrapped by a function named 'root_command()'."
echo "# Feel free to edit this file; your changes will persist when regenerating."
inspect_args
```

One interesting thing to notice here is that in the final `rndm` script all the contents of this file will be wrapped in a function named `root_command()` (you can confirm this if you open the `rndm`  script).

### Generating Random Numbers

We can now delete everything in `src/root_command.sh` and put our great random number generator code:

```bash
echo "$RANDOM"
```

Regenerate the script:

```
$ bashly generate
creating user files in src
skipped src/root_command.sh (exists)
created ./rndm
run ./rndm --help to test your bash script
```

Note that this time Bashly skipped the `src/root_command.sh` creation (because it already exists). Just the final `rndm` script was generated again, this time with our new code.

If we run the program a few times we'll see a different random number after each execution:

```
$ ./rndm
8783

$ ./rndm
32008

$ ./rndm
12550
```

✅ Done! We have our basic random number generator.

Let's add more features while learning more Bashly goodness.

## Handling `--options`

Some people take randomness very seriously (especially those who deal with cryptography). There's even a web service called [random.org](https://random.org/) self-described as "a **true** random number service that generates randomness via atmospheric noise". Well, I don't know exactly what "atmospheric noise" means, but as the site exists since 1998 and is still running, I'm assuming they're good at randomness.

A cool thing about the site is that they offer an endpoint from where we can get random numbers. Here's an example of how we can get one:

```bash
curl "https://www.random.org/integers/?num=1&min=0&max=32767&col=1&base=10&format=plain"
```

If you want to understand each parameter being passed to the endpoint, you can check the [official documentation](https://www.random.org/clients/http/api/). But if you want to keep your focus on learning Bashly, stay here...

We're going to provide the `--web` option so the user can tell our program to get the number from "the web". The first step is to put this in our `src/bashly.yml`:

```yaml
name: rndm
help: Prints a random number
version: 0.0.1

# specifying flags
flags:
    # long version:
  - long: --web
    # also a short version:
    short: -w
    help: Get the random number from <https://random.org>.
```

With just this YAML we can run `bashly generate` and check the help message:

```
$ bashly generate
creating user files in src
skipped src/root_command.sh (exists)
created ./rndm
run ./rndm --help to test your bash script

$ ./rndm --help
rndm - Prints a random number

Usage:
  rndm [OPTIONS]
  rndm --help | -h
  rndm --version | -v

Options:
  --web, -w
    Get the random number from <https://random.org>.

  --help, -h
    Show this help

  --version, -v
    Show version number
```

Cool, we got a neat help message generated with only a few lines in our YAML. But we still need to implement the feature.

Now we need to make our code aware that the user passed the `--web` flag.

When a flag is passed to our program, Bashly put it in an associative array named `$args`, where each key is precisely the name of the flag. As we used `--web`, now in our code we access this data with `${args[--web]}`. And as it's a boolean flag, with no arguments, the value here is `1` to mean "true, the `--web` option was passed".

Note: even if we use the short version `-w`, in our code we still access the value via `${args[--web]}`.

Let's use it in our code:

```bash
# src/root_command.sh

# if we use `rndm --web` or `rndm -w`,
# the value ${args[--web]} will be '1'
if [[ "${args[--web]}" ]]; then
  curl \
    --silent \
    --location \
    "https://www.random.org/integers/?num=1&min=0&max=32767&col=1&base=10&format=plain"
else
  echo "$RANDOM"
fi
```

We can now regenerate the script

> **Smarter way to `bashly generate`**
>
> You'll soon notice that we constantly run `bashly generate` after each file change, which can tedious. To make it easier, open a new terminal and run:
>
> ```
> bashly generate --watch
> ```
>
> This makes Bashly watch for changes and regenerate automatically.

Let's confirm the `--web` option works:

```
$ # numbers generated locally
$ ./rndm
2934

$ ./rndm
16891

$ # numbers coming from random.org
$ ./rndm --web
18253

$ ./rndm -w
137
```

You'll notice that when we run `rndm --web` the answer takes some milliseconds more than the local version. Such latency is expected when we're using a distributed system. There's nothing we can do in our code to solve that.

## Listing Dependencies

When we added the option to get a number from the web we ended up introducing a dependency for our program: the `curl` command.

In an environment without `curl`, our program crashes:

```
$ # environment without 'curl'
$ ./rndm --web
./rndm: line 17: curl: command not found
```

Let's make this more explicit for the users. We can edit our `src/bashly.yml` and add this:

```yaml
help: Prints a random number
version: 0.0.1

# specifying the dependencies
dependencies:
  - curl

flags:
  - long: --web
    short: -w
    help: Get the random number from <https://random.org>.
```

> **NOTE**: from now on I'm assuming you're using `bashly generate --watch` and I won't be telling you to regenerate after each change.

Let's check the output:

```
$ # environment without 'curl'
$ ./rndm --web
missing dependency: curl
```

That's slightly better than the "command not found at line 17", isn't it?

Moving on...

## Making Our Code Modular

Let's check our code again:

```bash
# src/root_command.sh

if [[ "${args[--web]}" == 1 ]]; then
  curl \
    --silent \
    --location \
    "https://www.random.org/integers/?num=1&min=0&max=32767&col=1&base=10&format=plain"
else
  echo "$RANDOM"
fi
```

Although it's simple, I'm willing to give names to these operations. Example: rather than that big `curl` I want to call `get_random_number_from_web`.

We need to create functions, and for that we're going to create a directory:

```bash
mkdir -p src/lib/
```

Now we create a file named `src/lib/random_number_functions.sh` and put our functions there, this way:

```bash
# src/lib/random_number_functions.sh

generate_random_number() {
  echo "$RANDOM"
}

get_random_number_from_web() {
  curl \
    --silent \
    --location \
    "https://www.random.org/integers/?num=1&min=0&max=32767&col=1&base=10&format=plain"
}
```

After doing this 👆 we can now make our `src/root_command.sh` much more pleasant to read:

```bash
# src/root_command.sh

if [[ "${args[--web]}" == 1 ]]; then
  get_random_number_from_web
else
  generate_random_number
fi
```

Run your `rndm` (you regenerated it, right?) and make sure things are working as expected.

Note that Bashly took the contents of `src/lib/random_number_functions.sh` and put in the final script (the `rndm` file). That's why we can call the functions we've created with no need to `source` anything.

You can keep in mind that Bashly take the contents of any `src/lib/*.sh` file and puts them in the final script. Therefore, it's a good way to make your code modular, allowing you to keep each file focused on solving one kind of problem (aka Separation of Concerns). Your bash code can be more readable and organized.

## Using `--options-with arguments`

Sometimes we want to generate a random number up to a given limit. For example to simulate rolling a dice. For such situation I'd like to have a command like this:

```bash
# prints a random number between 1 and 6
rndm --max 6
```

To create such option let's add this to our YAML file:

```yaml
name: rndm
help: Prints a random number
version: 0.0.1

# ...
flags:
  # ...
  # specifying a flag that accepts an argument
  - long: --max
    arg: max_num
    help: Specifies the maximum number to be generated
```

Before writing any code, let's check the help message:

```
$ ./rndm --help
rndm - Prints a random number

Usage:
  rndm [OPTIONS]
  rndm --help | -h
  rndm --version | -v

Options:
  --web, -w
    Get the random number from <https://random.org>.

  --max MAX_NUM
    Specifies the maximum number to be generated

  --help, -h
    Show this help

  --version, -v
    Show version number
```

An interesting detail: as we passed `arg: max_num` in the YAML, Bashly does two things:

1. understand that the `--max` flag requires an argument
2. mentions such requirement in the help message

Although we used the name `max_num`, this name is **not** used in our code (it's used only in the help message).

In our code we get the value given to the `--max` via `${args[--max]}`. Let's get the value in our code and pass it to the proper function:

```bash
# src/root_command.sh

# note that the '--max' argument is
# obtained via '${args[--max]}':
max_number="${args[--max]}"
# we're putting it in a 'max_number' variable
# just to use it more easily below.

if [[ "${args[--web]}" == 1 ]]; then
  get_random_number_from_web "$max_number"
else
  generate_random_number "$max_number"
fi
```

Now we need to make use if it in our functions:

```bash
# src/lib/random_number_functions.sh

generate_random_number() {
  local max_number="$1"
  # new logic to generate a number up to a number
  echo $((RANDOM % max_number + 1))
}

get_random_number_from_web() {
  local max_number="$1"
  curl \
    --silent \
    --location \
    "https://www.random.org/integers/?num=1&min=0&max=${max_number}&col=1&base=10&format=plain"
    # specify the maximum value passed to random.org 👆
}
```

Let's run it sometimes:

```
$ ./rndm --max 6
5

$ ./rndm --max 6
1

$ ./rndm --max 6
4

$ # from the web
$ ./rndm --max 6 -w
6

$ ./rndm --max 6 -w
4

$ # not specifying a maximum value
$ ./rndm
./rndm: line 29: RANDOM % max_number + 1: division by 0 (error token is "max_number + 1")

$ ./rndm --web
Error: The maximum value must be an integer in the [-1000000000,1000000000] interval
```

😱 - What?! Scary bugs!

If the user doesn't specify a `--max` value, our scripts crash.

Let's solve it!

### Assigning a Default Value to an Argument

We ended up making it mandatory a max number to be given.

We can solve this by defining a default value. The question is: which value should we use as default?

In the Bash manpage we can see (in the "Shell Variables" session) that the `$RANDOM` generates an integer between 0 and 32,767. So, for consistency sake, let's set the default as `32767`.

And Bashly offers a simple way to define a default value:

```yaml
name: rndm
help: Prints a random number
version: 0.0.1

# ...
flags:
  # ...
  - long: --max
    arg: max_num
    help: Specifies the maximum number to be generated
    # NOTE: the "double-quotes" are mandatory,
    #       so the value is seen as a string.
    default: "32767"
```

Check the help:

```
$ ./rndm --help
rndm - Prints a random number

Usage:
  rndm [OPTIONS]
  rndm --help | -h
  rndm --version | -v

Options:
  --web, -w
    Get the random number from <https://random.org>.

  --max MAX_NUMBER
    Specifies the maximum number to be generated
    Default: 32767

  --help, -h
    Show this help

  --version, -v
    Show version number
```

Cool! It puts clearly for the user what's the default value! 👍

Now let's see if it actually works:

```
$ ./rndm
8654

$ ./rndm
26564

$ ./rndm --web
9511

$ ./rndm --web --max 100
45

$ ./rndm --web --max 100
3

$ ./rndm --max 100
88
```

Apparently it's fine, but let's try to mess things up:

```
$ ./rndm --max text
./rndm: line 29: RANDOM % max_number + 1: division by 0 (error token is "max_number + 1")

$ ./rndm --max text --web
Error: The maximum value must be an integer in the [-1000000000,1000000000] interval
```

😖 - Ouch! Invalid input is crashing our program!

This feature looked innocent but brought a lot of headaches for us to handle... 😓

### Validating Arguments

We now need a validation to ensure the given `--max` argument is a positive integer.

Bashly supports custom validation functions for our flag arguments. Here's how it works:

- In the flag configuration we add a line like this: `validate: function_name`.
- Create a function called `validate_function_name`, which will be automatically called before the user input is used.
- If the function prints anything to stdout, that's considered an error. The content is print as an error message and the program aborts.

Let's see how to apply this for our `--max`  argument validation.

**Step 1**: add `validate: positive_integer` in our `src/bashly.yml`:

```yaml
name: rndm
# ...

flags:
  # ...
  - long: --max
    # ...
    # 👇👇👇 just add this line
    validate: positive_integer
```

**Step 2**: create a function named `validate_positive_integer`.

Let's do it by creating a function in a new file named `src/lib/validations.sh` (any filename would work).

**Step 3**: the function needs to print something to stdout to be considered a failure

Our function already does that. One thing to keep in mind is that your validation function must NOT have an explicit `exit` call. This is going to be handled by Bashly.

Here's the validation code:

```bash
# src/lib/validations.sh

validate_positive_integer() {
  local number="$1"
  if ! is_positive_integer "$number"; then
    echo "The argument must be a positive integer. Given value: $number"
  fi
}

# good practice:
# if something is done with a regular expression,
# it should be wrapped in a function (or variable)
# with a meaningful name.
is_positive_integer() {
  [[ "$1" =~ ^[1-9][0-9]*$ ]]
}
```

And let's test it:

```
$ ./rndm
26086

$ ./rndm --max 0
validation error in --max MAX_NUMBER:
The argument must be a positive integer. Given value: 0

$ ./rndm --max text
validation error in --max MAX_NUMBER:
The argument must be a positive integer. Given value: text

$ ./rndm --max -1
validation error in --max MAX_NUMBER:
The argument must be a positive integer. Given value: -1
```

Not that we didn't changed anything in our "main code" at `src/root_command.sh`. We only need to specify the validation in the YAML file and in our code we should already expect the input as validated.

Now our program is ready to be distributed, right? Uhmm, ok... Maybe you are thinking in more edge-cases to be addressed. But for our purpose of showing how to start working with Bashly I think we're done.

## Finishing (for now)

I'd like to call your attention for a moment and invite you to appreciate our `src/root_command.sh`. Look how simple that code is:

```bash
# src/root_command.sh

max_number="${args[--max]}"

if [[ "${args[--web]}" == 1 ]]; then
  get_random_number_from_web "$max_number"
else
  generate_random_number "$max_number"
fi
```

Check also the directory structure of our project:

```
$ tree
.
├── rndm
└── src
    ├── bashly.yml
    ├── lib
    │   ├── random_number_functions.sh
    │   └── validations.sh
    └── root_command.sh

2 directories, 5 files
```

From those 5 files, one is the final built script, and only 3 (small) ones are bash code that you actually wrote, with their specific goals:

- `validations.sh`: responsible for input validation
- `random_number_functions.sh`: storing the functions that actually bring random numbers.
- `root_command.sh`: the entrypoint of our application, calling the right function based on user input.

Now let's remember all the details we didn't need to spend energy on because Bashly solved for us:

- neat help and usage messages
- `--options` parsing
- dependency checking
- call the right input validation
- code modularization

Keep reading the documentation and you'll find out other things Bashly can do.
