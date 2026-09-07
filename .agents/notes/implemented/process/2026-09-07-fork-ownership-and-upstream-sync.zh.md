# Agent Note: 分叉归属与上游同步

Status: implemented

[English](2026-09-07-fork-ownership-and-upstream-sync.md) | 中文

## 问题

本仓库是 DeepSeek Harness 的一个分叉，并持续跟踪上游。harness 源码由另一个团队拥有，我们在其之上添加能力。我们每修改一个上游拥有的文件，都会在每次同步时再次产生冲突，因此一次修改的代价是反复支付的，而非一次付清。

此前缺少两项机制。没有任何记录说明我们可以修改哪些文件，因此扩展行为的 agent 缺少区分「新建软件包」与「修改既有软件包」的规则。品牌内容同样没有保护：分叉的 `README.md` 会被第一次触及它的上游合并静默覆盖，且不经审查。

## 决策

根目录 [AGENTS.md](../../../../AGENTS.md) 以 `## Fork ownership` 一节开篇，承载五条常驻指令：按 cookbook 表格放置新软件包来添加能力、通过我们自己的 bundle patch 层挂载、使用 [scripts/osf-sync.sh](../../../../scripts/osf-sync.sh) 而非 `git rebase` 进行同步，以及保持每个 PR 小而原子。该节位于它所限定的上游规则之上，处于上游改动最少的区域。

[.gitattributes](../../../../.gitattributes) 将 `README.md`、`BRAND_GUIDELINES.md` 及其 `.zh.md` 与 `.i18n.yaml` 配对文件标记为 `merge=ours`。这些行位于上游 `*.i18n.yaml merge=dsh-translation-pairing` 条目之后，而最后匹配的模式生效，因此这两份品牌配对记录会绕过该驱动。

`scripts/osf-sync.sh` 是同步入口。它注册 `ours` 合并驱动，在工作区不干净或缺少 `upstream` 远端时拒绝执行，随后抓取、合并，并检查 `README.md` 是否仍包含分叉名称。

`AGENTS.md` 本身刻意**不**使用 `merge=ours`。它承载约束我们所添加的每个软件包的上游工程规则——覆盖率门禁、测试策略、软件包清单不变量——而 `merge=ours` 会使这些更新无法送达，且从不报告冲突。我们的章节与上游各节互不重叠，因此普通合并可以干净地解决。

新增该节使 [scripts/doc-budgets.manifest.json](../../../../scripts/doc-budgets.manifest.json) 中 `AGENTS.md` 的字数上限，以及 [docs/AGENTS.md](../../../../docs/AGENTS.md) 中的目标值，从 1,950 提高到 2,200，保留了该文件要求的 5% 余量。

## 曾考虑的替代方案

**`AGENTS.md merge=ours`。** 否决：它会把上游工程规则冻结在分叉时刻。该失败是静默的——驱动从不产生冲突——因此 agent 会遵循过时规则，而没有任何信号提示偏移。

**改为 rebase 到上游而非合并。** 依据实测否决。rebase 期间 Git 会把我们的提交重放到上游之上，因此 `ours` 指上游、`theirs` 指我们；此时 `merge=ours` 会丢弃品牌文件，并以「patch contents already upstream」丢弃该提交，且没有冲突标记。只有合并方向才能让该属性表达其名称所暗示的含义。

**压缩已过时的 `## Repository layout` 段落以腾出字数预算。** 否决：删除约 250 词的上游散文，其冲突面比两行上限修改更大且更持久。该段落列出了两个已不存在的软件包，并遗漏了十七个现存软件包，但这份清单应由上游修正。

**为分叉规则单独建立说明文件。** 否决：agent 每次会话都会加载根 `AGENTS.md` 及其 `CLAUDE.md` 符号链接，而 agent 不会读取的规则不成其为规则。

**从上游 `scripts/install-lefthook.mjs` 注册合并驱动**，该文件已注册配对驱动。否决：它是上游文件，修改它恰好会造成本次变更意在避免的反复冲突。

## 后果

我们的品牌内容在上游合并中得以保留，同时上游的规则变更仍会送达。归属规则为 agent 提供了决策流程，使我们几乎所有工作都落在新软件包中，而合并在那里从不冲突。

在 `git config merge.ours.driver true` 运行之前，`merge=ours` 是无效的，而 `.gitattributes` 无法承载该配置。每个克隆与 CI 检出都必须运行 `scripts/osf-sync.sh` 来注册它。在全新克隆中直接执行 `git merge upstream/master` 会产生冲突，而不会保护品牌文件。

与此处多数由脚本强制执行的规则不同，这套规则是散文。没有任何机制拒绝修改上游软件包的提交，也没有任何机制阻止 `git rebase upstream/master`。当差异触及上游拥有的路径时使其失败的门禁，是自然的后续工作。

## 验证

`merge=ours` 的行为通过构造验证而非提交的测试：在注册驱动后，合并会保留分叉的 `README.md`，而 rebase 会将其丢弃。`scripts/osf-sync.sh` 中的标记检查，是针对「合并成功但品牌文件被替换」情形的兜底；冲突路径由合并本身的 `set -e` 覆盖。
