# OpenSoftwareFactory

English | [中文](README.zh.md)

**A software factory that owns the full software lifecycle for end-to-end agentic projects.** An objective goes in; running, deployed software comes out.

```sh
pnpm sf
```

## The vision

Most agent tools stop at the edit. They write code into your working directory and hand it back, leaving every step that turns code into a product — proving it runs, reviewing it, shipping it, paying for the infrastructure it needs, watching it afterwards — to a human with a terminal.

OpenSoftwareFactory is built on the premise that those steps are the work, and that an agent that cannot finish them has not finished anything. A factory takes an objective and owns it through the whole SDLC lifecycle:

| Stage | What the factory does |
|---|---|
| **Understand** | Ask what it needs to know, and stop asking once it knows enough |
| **Plan** | Propose the work in steps you can redirect in plain language, with a check that proves each one |
| **Build** | Edit the real repository under policy, in place, with the diff always visible |
| **Prove** | Run the check, feed failures back to itself, and stop when it cannot pass |
| **Review** | Show what changed, keep or revert it file by file, and never commit on your behalf |
| **Deploy** | Publish it, claim a domain, and pay for both — without a credential ever reaching the model |
| **Operate** | Know what it deployed and where, so the next change updates rather than orphans it |

The destination is a factory that runs that loop with a human at only the decision points they care about: approve the plan, keep the result, authorize the spend. Everything between those points is the agent's job.

## Where it stands

OpenSoftwareFactory is built as a fork with plugins on the [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness), which supplies the agent loop, tool policy, sandboxing, and durable sessions. Understanding, planning, building, proving, and reviewing work today because the harness provides them.

**Deploying does not exist yet, and that is the current milestone.** An agent that takes the project in your working directory and puts it on the internet — publish a preview, check a domain, and pay for it through [PromptPay](https://github.com/AaEll/PromptPay) — with no credential reaching the model.

[`MVP.md`](MVP.md) is the scope: why deployment is the slice, the capability seams it adds, the implementation plan, and what is deliberately out of it.

## Run

```sh
pnpm install
pnpm run build
pnpm sf            # the agent, in the current directory
pnpm sf web        # the browser UI at http://127.0.0.1:3080
```

For an `sf` command on your `PATH`, alias it to this checkout:

```sh
alias sf='pnpm --dir /path/to/OpenSoftwareFactory sf'
```

## Develop

Start with [`AGENTS.md`](AGENTS.md) for the working rules, [`MVP.md`](MVP.md) for what we are building, and [docs/architecture.md](docs/architecture.md) for how the harness fits together.

This repository tracks upstream DeepSeek Harness. Sync with `scripts/osf-sync.sh`, never `git rebase` — `AGENTS.md` has the reason.

## License

[MIT](LICENSE). Upstream harness sources and third-party dependencies keep their own licenses, disclosed in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
