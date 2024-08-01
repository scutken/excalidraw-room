# 使用较小的基础镜像
FROM node:18-slim AS build

# 设置工作目录
WORKDIR /excalidraw-room

# 复制package.json和yarn.lock文件，并安装依赖
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# 复制tsconfig.json和源代码文件
COPY tsconfig.json ./
COPY src ./src

# 构建项目
RUN yarn build

# 使用较小的运行时镜像
FROM node:18-slim

# 设置工作目录
WORKDIR /excalidraw-room

# 复制构建产物和依赖
COPY --from=build /excalidraw-room .

# 暴露端口
EXPOSE 80

# 启动命令
CMD ["node", "dist/index.js"]