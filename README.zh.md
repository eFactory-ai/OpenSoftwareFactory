# OpenSoftwareFactory

[English](README.md) | 中文

**一座软件工厂，负责端到端 agent 项目的完整软件生命周期。** 输入一个目标，产出可运行且已部署的软件。

```sh
pnpm sf
```

## 愿景

多数 agent 工具止步于编辑。它们把代码写进你的工作目录便交还给你，而把代码变成产品的每一步——验证其可运行、评审、发布、为其所需的基础设施付费、以及此后的运维——统统留给一个守着终端的人。

OpenSoftwareFactory 的前提是：这些步骤才是真正的工作，无法完成它们的 agent 等于什么都没完成。工厂接下一个目标，并贯穿整个 SDLC 生命周期地对其负责：

| 阶段 | 工厂做什么 |
|---|---|
| **理解** | 询问它需要知道的事，并在知道得足够多时停止追问 |
| **规划** | 以你可用自然语言调整的步骤提出方案，每步都带一项验证 |
| **构建** | 在策略约束下就地编辑真实仓库，差异始终可见 |
| **验证** | 运行检查，将失败反馈给自身，无法通过时停下 |
| **评审** | 展示变更内容，可逐文件保留或回退，且绝不代你提交 |
| **部署** | 发布站点、认领域名并为二者付费——凭据始终不会到达模型 |
| **运维** | 知晓自己部署了什么、部署在何处，使下次变更是更新而非遗弃 |

最终目标是：工厂自主运行该循环，人类只出现在其真正关心的决策点上——批准计划、保留结果、授权支出。其间的一切都是 agent 的职责。

## 当前进展

OpenSoftwareFactory 是 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) 的一个分叉，并以插件形式构建其上，由后者提供 agent 循环、工具策略、沙箱与持久会话。理解、规划、构建、验证与评审今天已可用，因为 harness 提供了它们。

**部署尚不存在，这正是当前的里程碑。** 一个 agent，能把你工作目录中的项目发布到互联网上——发布预览、查询域名，并通过 [PromptPay](https://github.com/AaEll/PromptPay) 完成支付——且凭据不会到达模型。

[`MVP.md`](MVP.md) 定义了范围：为何选择部署这一切片、它新增哪些能力接缝、实施计划，以及哪些内容被刻意排除。

## 运行

```sh
pnpm install
pnpm run build
pnpm sf            # 在当前目录中启动 agent
pnpm sf web        # 浏览器 UI，位于 http://127.0.0.1:3080
```

若希望在 `PATH` 中直接使用 `sf` 命令，可将其别名指向本检出目录：

```sh
alias sf='pnpm --dir /path/to/OpenSoftwareFactory sf'
```

## 开发

先阅读 [`AGENTS.md`](AGENTS.md) 了解工作规则，[`MVP.md`](MVP.md) 了解我们正在构建的内容，[docs/architecture.md](docs/architecture.md) 了解 harness 的整体结构。

本仓库跟踪上游 DeepSeek Harness。请使用 `scripts/osf-sync.sh` 同步，切勿使用 `git rebase`——原因见 `AGENTS.md`。

## 许可证

[MIT](LICENSE)。上游 harness 源码与第三方依赖各自保留其许可证，详见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
