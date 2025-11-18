# CoRobot 架构概览

CoRobot 主仓库通过 Git Submodule 管理六个子项目：
- RoboCOIN：机器人任务与资源结算、积分、令牌模块（示例占位）
- DataManage：数据集元数据、版本与访问管理
- DataTrain：训练脚本与模型管理（与 DataForge/Convert 配合）
- DataCollect：数据采集与标注流程
- DataConvert：数据清洗、转换与格式规范
- DataForge：特征工程、增强与数据处理管线

说明：以上为占位式领域划分，可根据实际业务进一步细化。

## 常见开发流程
- 在子项目源码仓库（外部目录 `../corobot-modules/<name>`）开发与提交
- 在主仓库同步子模块提交引用：`git submodule update --remote --merge`
- 在主仓库提交子模块指针变化，确保团队可以拉取到一致状态
