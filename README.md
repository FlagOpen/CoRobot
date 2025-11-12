# CoRobot (Corobot)

主代码仓库，使用 Git submodules 管理多个子项目：
- RoboCoin
- DataManage
- DataTrain
- DataCollect
- DataConvert
- DataForge

## 使用指南
- 初始化子模块：`scripts/bootstrap.sh`
- 同步子模块：`git submodule update --remote --merge`

## 结构
- 子模块位于仓库根目录（同名文件夹）
- 每个子模块都是独立 Git 仓库，可单独开发和发布

