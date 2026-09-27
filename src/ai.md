---
icon: copilot
order: 50
---

# Using Bashly with AI

The recommended way to use Bashly with a coding agent is to install the
**Bashly Skill**. It gives the agent a maintained Bashly workflow and the
references it needs to work on your project directly.

[!button variant="primary" icon="code-review" text="Get the Bashly Skill"](https://github.com/bashly-framework/bashly-ai-kit)

The skill helps agents:

- Design and update command trees in `bashly.yml`.
- Write command and library partials in the correct source folder.
- Respect project-specific Bashly settings and paths.
- Generate the CLI and validate representative command paths.
- Use the installed Bashly reference and current official documentation instead
  of guessing configuration keys.

## Install the skill

### Codex

Ask Codex:

```txt
Install the skill from the master branch at https://github.com/bashly-framework/bashly-ai-kit/tree/master/skills/bashly
```

### Claude Code

Ask Claude Code:

```text
Install the Bashly skill from the master branch of
https://github.com/bashly-framework/bashly-ai-kit into my user skills directory
(~/.claude/skills/bashly/)
```

See the [Bashly AI Kit][skill] repository for manual and project-level
installation details.

## Use the skill

Once installed, ask your coding agent for Bashly work normally. The skill can
activate automatically for relevant requests, or you can mention the Bashly
skill explicitly.

For example:

```text
Create a Bashly CLI with commands for adding, listing, and completing tasks.
Generate it and test the main command paths.
```

```text
Add a required FILE argument and a --force flag to the import command in this
Bashly project, then regenerate and validate the CLI.
```

```text
Find out why this Bashly command is not receiving its arguments and fix it.
```

For the best results, describe the command-line interface you want, including
required arguments, optional flags, validation rules, and expected output.

## Keep the skill current

The installed skill is a local copy. To refresh it, ask your agent:

```text
Update the installed Bashly skill from the master branch at:
https://github.com/bashly-framework/bashly-ai-kit/tree/master/skills/bashly

Replace the existing installation.
```

## Alternative: project-level instructions

If installing a skill is not practical, copy the
[`AGENTS.md` template][agents-template] into the root of your Bashly project.
This gives a coding agent a compact Bashly workflow without installing anything
globally.

The template is intentionally a fallback. The installable skill is the
canonical and more complete option.

[skill]: https://github.com/bashly-framework/bashly-ai-kit
[agents-template]: https://github.com/bashly-framework/bashly-ai-kit/blob/master/templates/AGENTS.md
