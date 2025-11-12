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
- 更新所有子模块：`scripts/update-all.sh`
- 同步子模块：`git submodule update --remote --merge`

## 结构
- 子模块位于仓库根目录（同名文件夹）
- 每个子模块都是独立 Git 仓库，可单独开发和发布

## 注意事项（本地子模块 URL）
- 当前 `.gitmodules` 中的子模块 URL 指向本机本地路径（`file:///.../corobot-modules/<name>`），便于在未创建远程仓库前进行开发与联调。
- 如果需要在其他机器上使用或托管到 GitHub/GitLab，请先为每个子模块创建远程仓库，然后执行以下命令将 URL 切换为远程地址：
  - `git submodule set-url RoboCoin <remote-url-for-RoboCoin>`
  - `git submodule set-url DataManage <remote-url-for-DataManage>`
  - `git submodule set-url DataTrain <remote-url-for-DataTrain>`
  - `git submodule set-url DataCollect <remote-url-for-DataCollect>`
  - `git submodule set-url DataConvert <remote-url-for-DataConvert>`
  - `git submodule set-url DataForge <remote-url-for-DataForge>`
- 更新完成后，建议提交 `.gitmodules` 与子模块引用提交：
  - `git add .gitmodules && git commit -m "chore: update submodule URLs to remotes"`
  - `git submodule sync --recursive`

## 本地开发路径说明
- 本地“子项目源码仓库”实际存放在仓库外部目录：`../corobot-modules/<name>`。
- 主仓库将它们以 submodule 的方式“克隆”到当前目录（同名文件夹）。
- 如需直接在子项目仓库中开发，可进入外部目录进行提交；在主仓库中执行 `git submodule update --remote --merge` 即可同步更新。
