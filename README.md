# CoRobot 1.0

[![GitHub Repo stars](https://img.shields.io/github/stars/FlagOpen/CoRobot?style=social)](https://github.com/FlagOpen/CoRobot/stargazers)
[![Issues](https://img.shields.io/github/issues/FlagOpen/CoRobot)](https://github.com/FlagOpen/CoRobot/issues)
[![Last Commit](https://img.shields.io/github/last-commit/FlagOpen/CoRobot)](https://github.com/FlagOpen/CoRobot/commits)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/FlagOpen/CoRobot/pulls)
[![Made with Love](https://img.shields.io/badge/Made%20with-CoRobot-orange)](#corobot-10)

具身数据开源框架 CoRobot 1.0——面向具身数据采集、转化、处理、检索、预览、下载和训练的全流程开源框架。其设计遵循“协同 (Collaboration)、一致 (Coherence)、聚合 (Collective)”三大核心理念，旨在通过一体化的数据基础设施提升多本体机器人数据的标准化程度与复用效率。


## News
- **2025-11**：发布 CoRobot 1.0，发布RoboCoin数据集及对应工具。

## RoboCoin Datasets

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

## Community
- **Issues**：欢迎在 [GitHub Issues](https://github.com/FlagOpen/CoRobot/issues) 反馈 bug、需求与数据协议建议。
- **Discussions**：可在 Discussions（筹备中）进行方案交流与需求共建。
- **Roadmap**：关注 [Projects](https://github.com/users/neo128/projects)（若无则以 Issue 标签追踪）了解迭代计划。

## Projects
| 模块 | 角色 | 能力亮点 |
| --- | --- | --- |
| `RoboCoin` (`robocoin-lerobot`) | 数据与模型资产管理 | 多本体双臂操作数据集，16 款本体、20 万+ 轨迹、10+ 场景、1000+ 任务、50+ 技能、500+ 物体。 |
| `DataManage` | 数据治理 | 数据可视化检索：关键词检索、可视化展示，便于查询与针对性下载。 |
| `DataTrain` | 模型训练 | 统一训练工具：支持 OpenPI、RDT、DP 等具身模型的快速接入与训练。 |
| `DataCollect` | 数据采集 | 多本体数采工具：支持多种本体与遥操作，已接入睿尔曼、松灵、银河通用、宇树、乐聚、星海图、灵御、智元等。 |
| `DataConvert` | 数据转化 | 数据格式转化工具：支持 RLDS、HDF5、JSONL 与 LeRobotDataset 的双向转换。 |
| `DataForge` | 数据处理 | 数据处理工具：缺陷过滤（静止帧、跳帧、维度错位、字段缺失、轨迹抖动）与补充标注（场景、子任务、运动描述）。 |


## Contributor
感谢所有贡献者与多本体机器人伙伴！欢迎通过 PR、Issue 或社区讨论参与共建：
- FlagOpen / CoRobot Team
- 社区志愿者（期待在 `CONTRIBUTORS.md` 中见到你的名字）

## Citation
```bibtex
@misc{corobot2024,
  title        = {CoRobot 1.0: An Open Embodied Data Infrastructure for Multi-Robot Collaboration},
  author       = {CoRobot Team},
  year         = {2025},
  publisher    = {FlagOpen},
  howpublished = {\url{https://github.com/FlagOpen/CoRobot}}
}
```

## License
CoRobot 主仓库及其子模块遵循各自目录下的许可证条款。若需商业合作或大规模部署授权，请联系项目维护者；统一开源协议将于后续版本公布。
