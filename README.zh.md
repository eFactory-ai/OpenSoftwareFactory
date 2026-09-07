# OpenSoftwareFactory

[English](README.md) | 中文

一座软件工厂，负责端到端 agent 项目的完整软件生命周期。输入一个目标，产出可运行且已部署的软件。

OpenSoftwareFactory 以插件形式构建在 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) 之上，由后者提供 agent 循环、工具、沙箱与会话。我们补充软件工厂所需、而 harness 尚未具备的能力——从部署开始。

> **当前里程碑：** 一个 agent，能把你工作目录中的项目发布到互联网上——发布预览、查询域名，并通过 [PromptPay](https://github.com/AaEll/PromptPay) 完成支付——且凭据始终不会到达模型。[`MVP.md`](MVP.md) 定义了范围，也包括刻意排除在外的内容。

## 运行

```sh
pnpm install
pnpm run build
pnpm dsh web
```

Web UI 默认启动于 `http://127.0.0.1:3080`。

## 开发

先阅读 [`AGENTS.md`](AGENTS.md) 了解工作规则，[`MVP.md`](MVP.md) 了解我们正在构建的内容，[docs/architecture.md](docs/architecture.md) 了解 harness 的整体结构。

本仓库跟踪上游 DeepSeek Harness。请使用 `scripts/osf-sync.sh` 同步，切勿使用 `git rebase`——原因见 `AGENTS.md`。

## 许可证

[MIT](LICENSE)。上游 harness 源码与第三方依赖各自保留其许可证，详见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
