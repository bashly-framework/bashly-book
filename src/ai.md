---
icon: copilot
order: 50
---

# Using Bashly with AI

There are three practical ways to use AI while building Bashly projects.
Choose the one that matches your workflow.

## Quick chooser

| Route                 | Best for                                                    | Setup         |
|:----------------------|:------------------------------------------------------------|:--------------|
| Chat with any AI      | You already know Bashly and want fast iteration             | None          |
| [Bashly Chat][chat]   | You want Bashly-focused guidance with minimal prompt tuning | Open link     |
| [Bashly Skill][skill] | You use coding agents and want repeatable project workflows | Install skill |

## Route 1: Chat with your favorite AI

This is the simplest route if you are already familiar with Bashly.

Give the model:

1. Your CLI goal.
2. Your current `bashly.yml` (or desired command tree).
3. The behavior you want for each command.

Example starter prompt:

```text
I am building a Bashly CLI.
Please design or update my bashly.yml and command partials under src/.
Keep names and help text concise.
After editing, list the exact bashly generate command and 3 test commands.
```

## Route 2: Use Bashly Chat

[!button variant="primary" icon="copilot" text="Open Bashly Chat"](https://bashly.dev/chat)

Use this when you want a Bashly-oriented assistant without setting up a local
agent skill.

!!!success Tip
The bashly AI chat is available at [bashly.dev/chat][chat].
!!!


It is a good fit for:

- Learning Bashly conventions.
- Drafting command trees quickly.
- Reviewing or improving existing `bashly.yml`.

## Route 3: Use the Bashly Skill

[!button variant="primary" icon="code-review" text="Bashly AI Kit"](https://github.com/bashly-framework/bashly-ai-kit)

The Bashly Skill is intended for agent-based workflows (for example Codex or
Claude Code), where the agent edits project files directly and follows a
defined Bashly workflow.

Install in Codex using the installer prompt shown in the repository README:

```text
install the skill from https://github.com/bashly-framework/bashly-ai-kit/tree/main/skills/bashly
(master branch)
```

## Prompting tips for all routes

To get better results, include these in your request:

1. The exact command UX you want (`tool action ARG --flag`).
2. Required vs optional arguments and flags.
3. Validation rules and error behavior.
4. Expected output examples.
5. Your current file layout (`src/`, settings, overrides).

When you have edits, run:

```shell
bashly generate
```

Then test at least one `--help` path, one success path, and one error path.


[chat]: https://bashly.dev/chat
[skill]: https://github.com/bashly-framework/bashly-ai-kit
