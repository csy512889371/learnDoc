# git回退到某个历史版本

> git log 命令查看所有的历史版本，获取某个历史版本的id，假设查到历史版本的id是139dcfaa558e3276b30b6b2e5cbbb9c00bbdca96

# 回退

```shell
git reset --hard 139dcfaa558e3276b30b6b2e5cbbb9c00bbdca96
```

# 把修改推到远程服务器

```shell
git push -f -u origin master
```
