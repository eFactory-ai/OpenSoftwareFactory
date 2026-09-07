# OpenSoftwareFactory

English | [中文](README.zh.md)

A software factory that owns the full software lifecycle for end-to-end agentic projects. An objective goes in; running, deployed software comes out.

OpenSoftwareFactory is built as plugins on the [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness), which supplies the agent loop, tools, sandboxing, and sessions. We add the capabilities a factory needs and the harness does not have — starting with deployment.

> **Current milestone:** an agent that takes the project in your working directory and puts it on the internet — publish a preview, check a domain, and pay for it through [PromptPay](https://github.com/AaEll/PromptPay) — without a credential ever reaching the model. [`MVP.md`](MVP.md) is the scope, including what is deliberately outside it.

## Run

```sh
pnpm install
pnpm run build
pnpm dsh web
```

The Web UI starts at `http://127.0.0.1:3080`.

## Develop

Start with [`AGENTS.md`](AGENTS.md) for the working rules, [`MVP.md`](MVP.md) for what we are building, and [docs/architecture.md](docs/architecture.md) for how the harness fits together.

This repository tracks upstream DeepSeek Harness. Sync with `scripts/osf-sync.sh`, never `git rebase` — the reasons are in `AGENTS.md`.

## License

[MIT](LICENSE). Upstream harness sources and third-party dependencies keep their own licenses, disclosed in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
