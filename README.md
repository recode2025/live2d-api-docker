# live2d-api-docker

前端可调用该api组件库： https://github.com/stevenjoezhang/live2d-widget

容器化管理看板娘插件，国内可以使用阿里云镜像服务同步

source github project: https://github.com/fghrsh/live2d_api

根据这个项目我们可以使用github action进行构造，构造后push到阿里云镜像服务，在服务器端进行拉取操作

### 容器所用技术

caddy-2-alpine、php7.4

## 项目结构

```

.
├── .github/
│   └── workflows/
│       └── build.yml    
├── Caddyfile            
└── Dockerfile           

```
## 需要配置
在你的 GitHub 仓库中，点击 Settings -> Secrets and variables -> Actions。
点击 New repository secret，添加以下三个变量：

| **Secret Name** | **值 (示例)**                     | **说明**
| ----------------------- | ----------------------------------------- | ---------------------------------- | 
| `ALIYUN_REGISTRY` | `registry.cn-hangzhou.aliyuncs.com` | 你的阿里云镜像仓库公网地址       |
| `ALIYUN_USERNAME` | `你的阿里云用户名`                  | 用于登录 ACR 的用户名            |
| `ALIYUN_PASSWORD` | `你的ACR独立密码`                   | 第一步中设置的 docker login 密码 |
| `IMAGE_NAME`      | `my-live2d-space/live2d-api`        | 命名空间/仓库名                  |


### docker-compose.yml参考

```
version: '3'

services:
  live2d-api:
    # 替换为你自己的阿里云镜像地址
    image: registry.cn-hangzhou.aliyuncs.com/你的命名空间/live2d-api:latest #去阿里云镜像仓库看地址
    container_name: live2d_api
    restart: always
    ports:
      - "9189:80"
    volumes:
      # 如果需要挂载本地模型文件夹，取消下面注释
      # - ./model:/var/www/html/model
```


tips:部署时候需要先在服务器docker上登录阿里云域的账号密码

参考指令：`docker login domain`
