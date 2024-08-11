# 使用更小的基础镜像
FROM node:18-alpine AS build

# 设置工作目录
WORKDIR /excalidraw-room

# 复制package.json和yarn.lock文件，并安装依赖
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production

# 复制tsconfig.json和源代码文件
COPY tsconfig.json ./
COPY src ./src

# 构建项目并清理缓存
RUN yarn build --noEmitOnError && yarn cache clean

# 使用更小的运行时镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /excalidraw-room

# 复制构建产物
COPY --from=build /excalidraw-room/dist ./dist
COPY --from=build /excalidraw-room/node_modules ./node_modules

# 暴露端口
EXPOSE 80

# 启动命令
CMD ["node", "/excalidraw-room/dist/index.js"]