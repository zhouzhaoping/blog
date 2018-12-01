#!/bin/sh

work_path=$(dirname $(readlink -f $0))

# build
docker build -t hexo-docker .

# 初始化
docker run -it \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    sh -c 'hexo init . ; npm install ; npm install hexo-deployer-git --save'