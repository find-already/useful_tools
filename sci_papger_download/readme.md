
#### 下载步骤
- 首先通过网站(?)获取论文的  doi 集合
- 将 doi 写入一个文本文件中: file_src.list
- 启动 sci_smart_download.sh, 开始下载

#### 下载结果
```
//第一篇论文
001.html
001_miller2018.pdf
//第N篇论文
...

//map_file.txt: 论文和原始 doi 的映射关系
001/003 - 10.1080/10668926.2018.1504700 - 001_miller2018.pdf
002/003 - 10.1016/j.tele.2018.07.012 - 002_zhang2018.pdf
```

#### 参考网址
- https://tool.yovisun.com/scihub/
- https://sci-hub.se/
