#!/bin/sh

work_path=$(dirname $(readlink -f $0))

# gen
docker run -it \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    hexo g

# 预览
docker run -it -d \
    -p 4000:4000 \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    hexo s