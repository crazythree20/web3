#!/bin/bash

# 安装 NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# 配置 NVM 环境变量
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # 加载 nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # 加载 nvm bash_completion

# 将 NVM 配置写入 .bashrc 以便以后使用
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
source ~/.bashrc

# 安装 Node.js 20 并使用
nvm install 20
nvm use 20

# 全局安装 Yarn
npm install -g yarn

# 克隆 GitHub 仓库
git clone https://github.com/CATProtocol/cat-token-box.git
cd cat-token-box

# 安装依赖并构建项目
yarn install && yarn build

# 进入 packages/tracker 目录
cd packages/tracker

# 安装依赖并构建 tracker
yarn install
yarn build

# 安装 Docker
snap install docker

# 修改文件夹权限
sudo chmod 777 docker/data 
sudo chmod 777 docker/pgdata

# 回到项目根目录并构建 Docker 镜像
cd ../../
docker build -t tracker:latest .

# 运行 Docker 容器
docker run -d \
    --name tracker \
    --add-host="host.docker.internal:host-gateway" \
    -e DATABASE_HOST="host.docker.internal" \
    -e RPC_HOST="host.docker.internal" \
    -p 3000:3000 \
    tracker:latest

# 进入 packages/cli 目录
cd packages/cli

# 安装依赖并构建 CLI 工具
yarn install
yarn build

# 创建钱包
yarn cli wallet create

# 显示钱包地址
yarn cli wallet address
