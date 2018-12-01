# blog
## build
```bash
docker build -t hexo-docker .
```
## 初始化
```bash
docker run -it \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    sh -c 'hexo init . && npm install && npm install hexo-deployer-git --save'
```

## Edit..
in $work_path/hexo

## 本地gen
```bash
docker run -it \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    hexo g
```

## 预览
```bash
docker run -it -d \
    -p 4000:4000 \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    hexo s
```