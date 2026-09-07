# MVP

## The goal

OpenSoftwareFactory is a software factory that owns the full software lifecycle for end-to-end agentic projects: an objective goes in, running software comes out — planned, built, proven, reviewed, deployed, and operated by agents, with humans at the decision points that matter to them.

This fork builds that factory as plugins on the DeepSeek Harness. The harness supplies the agent loop, tools, sandboxing, sessions, and interfaces; we supply the capabilities a factory needs and the harness does not have.

## What the MVP is

**The deployment half.** An agent that takes the project in your working directory and puts it on the internet: publish a preview, check a domain, and pay for it through [PromptPay](https://github.com/AaEll/PromptPay) — without a credential ever reaching the model.

Building software is the part the harness already does. Deploying it is the part nothing here can do yet, and it is the step that turns an agent that edits files into a factory that ships product. That is the whole MVP.

## Why this slice

`packages/` has no deployment, domain, or payment capability. Everything else the MVP needs already ships:

| Need | Provided by |
|---|---|
| Editing the project in place | `packages/fs/`, `packages/sandbox/` |
| Planning with a human | `packages/plan/`, `packages/interaction/user-approval` |
| Proving the result runs | `packages/shell/`, `packages/guard/` |
| Durable, resumable sessions | `packages/session/` |
| Unattended runs with exit codes | the `headless` profile |
| Browser and terminal interfaces | `packages/client/`, `apps/cli` |
| **Deployment, domains, payment** | **nothing — this is the MVP** |

A prior Python implementation reached the same conclusion from the other direction: it hand-built the agent half, deferred durability and concurrency, and found its remaining gap was exactly deployment reachability. We inherit the agent half instead of rebuilding it.

## Architecture

Three capability seams, each a complete Service Definition / Provider / Consumer trio, all new packages.

```
packages/promptpay/
  promptpay-broker/    Library, not model-facing. HTTP client, config, /authorize.
                       Injected by the providers below. No ctx key the model can reach.

packages/deploy/
  deploy/              ctx.deploy — publish(SiteSpec) · get(id) · list()
                       Owns the Deployment record and resolve(request): SiteSpec
  deploy-promptpay/    Provider over POST /previews
  deploy-tool/         Consumer: the model-facing `deploy` tool, event, presenter

packages/domain/
  domain/              ctx.domains — search · check · preview · register
  domain-promptpay/    Provider over POST /domains/*
  domain-tool/         Consumer: model-facing tool; register gated on human approval

packages/promptpay/promptpay-bundle/   dsh.bundle.patch — our mount layer
```

Four constraints shape this:

**`/authorize` sits behind the seam, never in front of it.** It is the call that spends money. As a model-facing tool, the model would decide when to pay. Instead both providers call it internally, and the human gate is `user-approval` on `domain.register`.

**Site scoping is an explicit `resolve(request): SiteSpec` step**, not a default inside `publish()`. What gets published must respect `.gitignore` and be a site directory, not the whole repository.

**A deployment is a session event.** Under the repository's model-visible-implies-logged rule, state the model can see must be reconstructable from the session log. This is what makes a second publish update the same preview instead of orphaning the first.

**Nothing mounts by editing `packages/bundle/`.** Our bundle declares its own patch layer, per the fork ownership rules in [AGENTS.md](AGENTS.md).

## Implementation plan

One goal per PR, each independently verifiable, each with its tests and an Agent Note.

1. **`promptpay-broker`** — HTTP client, `Config`, `/healthz` and `/authorize`, recorded-response tests. No model surface, so it lands and is provable on its own.
2. **`deploy` Service Definition** — the `Deployment` record, `SiteSpec`, and `resolve()` with `.gitignore`-aware scoping. Unit tests over scoping, including the empty and everything-ignored cases.
3. **`deploy-promptpay`** — the provider. Recorded-response tests against `POST /previews`.
4. **`deploy-tool`** — model-facing tool, session event, Host presenter, snapshot coverage. First PR where the model can deploy.
5. **`domain` seam** — definition, provider, and tool together; `register` behind `user-approval`. A test proves denial through the executor, not through schema omission.
6. **`promptpay-bundle` + cold start** — the patch layer, profile wiring, and one documented command that brings up PromptPay and the profile from nothing.

## Done when

- [ ] An agent in a fresh git repository produces a working site from one sentence
- [ ] `deploy` returns a live preview URL for the files in *that* directory
- [ ] A second deploy updates the same preview rather than orphaning it
- [ ] A domain can be checked and claimed in the same session, with the purchase approved by a human
- [ ] The headless profile does the same unattended and exits non-zero on failure
- [ ] Nothing outside the project is published, and no credential reaches the model
- [ ] The publish path is covered offline, with no broker running and no spend
- [ ] A stranger can follow one documented sequence on a clean machine

## Out of scope

Named so nobody builds them by accident:

- **The autonomous forge loop.** No driver agent reviewing pull requests, no merge-on-green. That is the destination, not this milestone.
- **Cloud execution of the agent.** The agent runs on your machine; only the deployment touches the cloud.
- **Multi-tenant or shared deployment state.** One user, one machine, one session's record.
- **Provider breadth.** PromptPay is the only provider behind each seam. The seams exist so a second one is additive, not so we ship two.
