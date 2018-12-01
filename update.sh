#!/bin/sh

work_path=$(dirname $(readlink -f $0))

# 本地测试
docker run -it \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    hexo g