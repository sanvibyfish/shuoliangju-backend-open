#!/bin/bash
export SERVER='root@shuoliangju.cn'
# 先打包bundle gem
bundle package

# # 1. 打包镜像
docker build -t registry.cn-hangzhou.aliyuncs.com/shuolianju/shuoliangju-backend-production:1.2.3 .
# # 2. push镜像
docker push registry.cn-hangzhou.aliyuncs.com/shuolianju/shuoliangju-backend-production:1.2.3

# 3. 传输部署文件
scp .env.production $SERVER:/app/shuoliangju-backend-production/.env.production
scp docker-compose.production.yml $SERVER:/app/shuoliangju-backend-production/docker-compose.yml
scp Dockerfile $SERVER:/app/shuoliangju-backend-production/Dockerfile


# 4. pull镜像 && 启动
ssh $SERVER << EOF
  cd /app/shuoliangju-backend-production
  docker-compose pull shuoliangju-backend-production
  docker-compose down && docker-compose up -d
  docker-compose run -d shuoliangju-backend-production bundle exec rails db:migrate RAILS_ENV=production
  rm -rf .env.production
  docker image prune -f
  docker container prune -f
EOF
docker image prune -f
docker container prune -f
echo 'deploy success!!!'


