# 第一阶段：从官方 Caddy 镜像中获取二进制文件
FROM caddy:2-alpine AS caddy-builder

# 第二阶段：构建最终的 PHP-FPM 镜像
FROM php:7.4-fpm-alpine

# 1. 安装基础依赖：Git (用于拉代码) 和 libstdc++ (Caddy 运行依赖)
RUN apk add --no-cache git libstdc++

# 2. 从第一阶段复制 Caddy 到当前镜像
COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy

# 3. 设置工作目录
WORKDIR /var/www/html

# 4. 拉取 GitHub 源码
# 注意：PHP 7.4 已内置 json 扩展，无需额外安装
RUN rm -rf * && \
    git clone https://github.com/fghrsh/live2d_api.git . && \
    chown -R www-data:www-data /var/www/html

# 5. 复制 Caddy 配置文件 (下一步创建)
COPY Caddyfile /etc/caddy/Caddyfile

# 6. 暴露容器内部端口
EXPOSE 80

# 7. 启动命令：同时启动 PHP-FPM (后台) 和 Caddy (前台)
# php-fpm -D 表示以守护进程运行，确保后续的 caddy 命令能执行
CMD php-fpm -D && caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
