#!/bin/sh

work_path=$(dirname $(readlink -f $0))

# build
docker build -t hexo-docker .

# 初始化
docker run -it \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    sh -c 'hexo init . && npm install && npm install hexo-deployer-git --save'

# 本地测试
docker run -it \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    hexo g

# 预览
docker run -it \
    -p 4000:4000 \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    hexo s