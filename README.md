# shuoliangju-backend-open

微信论坛小程序后端的开源实现，需要基于Ruby on Rails实现，提供JSON API给到前端的小程序，并基于Bootstrap开发了运营端和管理端。

## 特性
1. 支持后端JSON API
2. 自带管理端和运营端
3. 支持全接口自动化测试
4. 支持词典敏感词过滤

## 依赖服务
1. 阿里云OSS
2. 微信内容审查服务

## 如何使用

### 使用流程

1. 注册一个微信小程序，并获取**APPID**和**APP_SECRET**。
2. 注册一个阿里云OSS服务，并且获取**ACCESS_KEY_ID、ACCESS_KEY_SECRET、BUCKET、ENDPOINT**参数。
3. 创建自己的Docker镜像仓库，也可以使用阿里云的镜像服务
4. 创建好后把**.env.production.tmp**重命名为**.env.production**，并填入相关的参数
5. 修改部署脚本**deploy-production.sh**填入镜像仓库地址
6. 使用**deploy-production.sh**进行服务的部署


## 配置说明
**.env.production**
```
MYSQL_USERNAME= //mysql用户名
MYSQL_PASSWORD= //mysql密码
MYSQL_ADDRESS= //mysql地址
RAILS_ENV=production

RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true

#[Aliyun OSS]
ACCESS_KEY_ID= //阿里云OSS ACCESS_KEY_ID
ACCESS_KEY_SECRET= //阿里云OSS ACCESS_KEY_SECRET
BUCKET= //阿里云OSS BUCKET
DIR_PATH=production/
ENDPOINT=  //阿里云OSS ENDPOINT 地址
CDN_HOST= //阿里云OSS CDN的地址，上传OSS的时候可以通过内网的地址上传，但是用户访问的时候需要考虑走CDN的地址

#[Redis]
REDIS_URL=redis://:6379/2  //redis 用于登录信息的缓存
SIDEKIQ_REDIS_URL=redis://:6379/4 //redis 主要用于邮件发送、微信消息推送等异步服务的队列

#[Wechat]
WECHAT_APPID= //微信 APPID
WECHAT_APP_SECRET= //微信 APP_SECRET
WECHAT_TOKEN=//微信 TOKEN
WECHAT_ACCESS_TOKEN=/var/tmp/wechat_access_token
WECHAT_JSAPI_TICKET= /var/tmp/wechat_jsapi_ticket

```

## 贡献项目

如果你是用户，你可以通过上方的 [issue](https://github.com/sanvibyfish/shuoliangju-backend-open/issues) 或 discussion 参与讨论，提出你的问题

如果你是开发者，你可以直接通过 [Pull Request](https://github.com/sanvibyfish/shuoliangju-backend-open/pulls) 提交你的修改。需要注意的是，你的修改将会以 AGPLv3 授权给其他开发者。

## LICENSE 
[AGPLv3](LICENSE)

如果希望商业使用，请联系邮箱 [sanvibyfish@gmail.com](sanvibyfish@gmail.com) 或微信 `sanvibyfish` 了解商业授权以及独立部署版本

