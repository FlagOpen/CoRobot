# CoRobot 1.0

[![GitHub Repo stars](https://img.shields.io/github/stars/neo128/CoRobot?style=social)](https://github.com/neo128/CoRobot/stargazers)
[![Issues](https://img.shields.io/github/issues/neo128/CoRobot)](https://github.com/neo128/CoRobot/issues)
[![Last Commit](https://img.shields.io/github/last-commit/neo128/CoRobot)](https://github.com/neo128/CoRobot/commits)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/neo128/CoRobot/pulls)
[![Made with Love](https://img.shields.io/badge/Made%20with-CoRobot-orange)](#corobot-10)

具身数据开源框架 CoRobot 1.0——面向具身数据采集、转化、处理、检索、预览、下载和训练的全流程开源框架。其设计遵循“协同 (Collaboration)、一致 (Coherence)、聚合 (Collective)”三大核心理念，旨在通过一体化的数据基础设施提升多本体机器人数据的标准化程度与复用效率。

## Table of Contents
- [News](#news)
- [Overview](#overview)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Datasets](#datasets)
- [Update & Maintenance](#update--maintenance)
- [Community](#community)
- [Projects](#projects)
- [Model List](#model-list)
- [Contributor](#contributor)
- [Citation](#citation)
- [License](#license)

## News
- **2025-11**：发布 CoRobot 1.0，提供覆盖采集、转化、管理、训练的标准化管线。
- **2025-11**：RTML 轨迹语义描述语言深度集成，实现跨机器人、多模态轨迹统一标注。
- **2025-11**：完成基于 LeRobot 的多机器人数据采集示例与工具链升级。

## Overview
该框架基于 LeRobot 构建，支持多种机器人平台的数据采集与异构数据格式的统一转换，并深度融合机器人轨迹标记语言 RTML，以结构化约束保障轨迹数据的质量一致性。集成了基于大语言模型与规则工具的层次化标注流程，支持轨迹级、段级与帧级细粒度标注，并提供数据检索、可视化预览等功能，赋能多样化模型训练需求。通过模块化工具链与标准化数据管理，显著提升了具身智能数据的生产规范性、质量一致性与训练效率，助力多本体泛化研究与应用落地。

核心能力：
- **全流程**：覆盖采集、转化、处理、检索、预览、下载与训练七大阶段。 
- **一致性**：RTML + 结构化约束确保多模态轨迹质量一致。 
- **可扩展**：模块化工具链、Git submodule 设计方便独立开发与部署。

## Installation
> 推荐使用 macOS 或 Linux，需预装 Git、Python (>=3.10) 与常见机器人依赖。

```bash
git clone git@github.com:neo128/CoRobot.git
cd CoRobot
git submodule update --init --recursive
./scripts/bootstrap.sh         # 初始化所有子模块依赖
git submodule foreach 'git status -sb'
```

常用辅助脚本：
- `scripts/bootstrap.sh`：首次克隆后批量安装依赖。
- `scripts/update-all.sh`：一键更新所有子模块到各自远端最新提交。
- `scripts/foreach.sh '<command>'`：对子模块批量执行同一指令，适合 lint/test。
- `scripts/set-remote-urls.sh --file mapping.txt`：批量切换子模块远程地址。
- `scripts/create-github-remotes.sh --org <org> --visibility private`：基于 gh CLI 自动创建并绑定远程仓库。

## Quick Start
1. **拉起工作区**
   ```bash
   git clone git@github.com:neo128/CoRobot.git
   cd CoRobot
   ./scripts/bootstrap.sh
   git submodule update --remote --merge   # 跟踪外部提交
   ```
2. **采集具身数据**
   - 在 `DataCollect` 中配置机器人驱动与任务脚本。
   - 使用 RTML 描述采集任务与标注 schema，采集后数据默认写入 `DataCollect/output`。
3. **转化与标注**
   - `DataConvert` 负责将多源多模态数据标准化并生成 RTML 约束。
   - `DataForge` & `DataManage` 用于批量处理、质检、检索与可视化预览。
4. **训练模型**
   - 进入 `DataTrain`，参考 `examples/lerobot` 或 `configs/*.yaml` 运行训练：
     ```bash
     cd DataTrain
     python train.py --config configs/lerobot/rtml_multi.yaml --data_root <path>
     ```
5. **发布与集成**
   - 利用 `RoboCoin` 进行数据/模型资产化管理，实现多本体共享。

## Datasets

- 数据集概览：
  
  ![RoboCOIN 平台与任务概览](assets/datasets/robocoin-platforms.png)
  
  ![RoboCOIN 分布统计](assets/datasets/robocoin-stats.png)

- 资源地址：
  - Hugging Face：https://huggingface.co/RoboCOIN
  - ModelScope：https://modelscope.cn/organization/RoboCOIN
  - 数据集持续更新，具体许可与版本以各数据集页面为准。

- 数据格式范例（推荐 RTML/LeRobot 统一结构）：
  ```text
  dataset_root/
    meta.yaml                      # 元信息（机器人、本体、任务、采集参数等）
    trajectories/
      000001/
        rtml.json                  # 轨迹描述（任务、段落、帧级标注）
        observations/
          rgb/
            000001.jpg
            000002.jpg
          depth/
            000001.png
        actions.npy                # 对应每帧的动作（可为关节或笛卡尔增量）
        timestamps.csv             # 时间戳（与帧/动作对齐）
      000002/
        ...
  ```

- 使用方法：
  1) 下载到本地
     - 从 Hugging Face 组织页选择数据集后下载，或使用 Python 快速拉取：
       ```python
       from huggingface_hub import snapshot_download
       snapshot_download(repo_id="RoboCOIN/<dataset_name>", repo_type="dataset", local_dir="data/<dataset_name>")
       ```
     - 从 ModelScope 组织页下载到本地目录 `data/<dataset_name>`（可用其网页下载或官方 SDK/CLI）。
  2) 放置路径与校验
     - 解压/同步至 `data/<dataset_name>`，确保包含 `trajectories/` 与元信息（如 `meta.yaml`）。
  3) 转换（如需）
     - 若为第三方格式，可用本仓工具链在 `DataConvert` 中统一到 RTML/LeRobot 规范，再进入后续流程。
  4) 训练与评估
     - 进入 `DataTrain`，指定数据根目录：
       ```bash
       cd DataTrain
       python train.py --config configs/lerobot/rtml_multi.yaml --data_root ../data/<dataset_name>
       ```
  5) 预览与检索
     - 使用 `DataManage` 进行元数据检索、可视化与下载管理。

## Update & Maintenance
- 子模块 URL 默认指向本机本地路径（`file:///.../corobot-modules/<name>`），便于在未创建远程仓库前进行开发与联调。若需切换到 GitHub/GitLab：
  ```bash
  git submodule set-url RoboCoin <remote-url>
  git submodule set-url DataManage <remote-url>
  git submodule set-url DataTrain <remote-url>
  git submodule set-url DataCollect <remote-url>
  git submodule set-url DataConvert <remote-url>
  git submodule set-url DataForge <remote-url>
  git add .gitmodules && git commit -m "chore: update submodule URLs"
  git submodule sync --recursive
  ```
- 本地“子项目源码仓库”实际存放于仓库外 `../corobot-modules/<name>`，主仓库仅以 submodule 形式引用。
- 在外部目录直接开发子项目，回到主仓库执行 `git submodule update --remote --merge` 即可同步提交。

## Community
- **Issues**：欢迎在 [GitHub Issues](https://github.com/neo128/CoRobot/issues) 反馈 bug、需求与数据协议建议。
- **Discussions**：可在 Discussions（筹备中）进行方案交流与需求共建。
- **Roadmap**：关注 [Projects](https://github.com/users/neo128/projects)（若无则以 Issue 标签追踪）了解迭代计划。

## Projects
| 模块 | 角色 | 能力亮点 |
| --- | --- | --- |
| `RoboCoin` | 数据与模型资产管理 | 提供资产上链、检索与权限控制能力，加速数据共享。 |
| `DataManage` | 数据治理 | 集成元数据检索、预览、下载、审计等工具。 |
| `DataTrain` | 模型训练 | 支持基于 LeRobot/RTML 的模仿学习、策略学习与多模态训练范式。 |
| `DataCollect` | 数据采集 | 面向多机器人平台的采集工具链，支持实时监控与故障回溯。 |
| `DataConvert` | 数据转化 | 将异构格式（ROS bags、视频、传感器流等）统一到 RTML/LeRobot 标准。 |
| `DataForge` | 数据处理 | 自动化切分、质检、增强与层次化标注流水线。 |

## Model List
| 工作流 | 数据来源 | 说明 | 状态 |
| --- | --- | --- | --- |
| LeRobot-RTML 多本体模仿学习 | `DataCollect` + `DataConvert` + `DataTrain` | 以 RTML 描述轨迹，结合 LeRobot 训练策略克隆模型。 | ✅ 可用 |
| 规则 + LLM 层次化标注模型 | `DataForge` | 结合规则校验与 LLM 审核，生成轨迹级/帧级标签。 | 🔄 迭代中 |
| RoboCoin 多模态检索模型 | `DataManage` + `RoboCoin` | 基于元数据与嵌入构建的检索/推荐模型，支持多模态查询。 | 🚧 规划中 |

## Contributor
感谢所有贡献者与多本体机器人伙伴！欢迎通过 PR、Issue 或社区讨论参与共建：
- FlagOpen / CoRobot Team
- 社区志愿者（期待在 `CONTRIBUTORS.md` 中见到你的名字）

## Citation
```bibtex
@misc{corobot2024,
  title        = {CoRobot 1.0: An Open Embodied Data Infrastructure for Multi-Robot Collaboration},
  author       = {CoRobot Team},
  year         = {2024},
  publisher    = {FlagOpen},
  howpublished = {\url{https://github.com/neo128/CoRobot}}
}
```

## License
CoRobot 主仓库及其子模块遵循各自目录下的许可证条款。若需商业合作或大规模部署授权，请联系项目维护者；统一开源协议将于后续版本公布。
