```
第一步：查看容器的CONTAINER ID

​```
docker ps
​```

第二步：获取root权限，例如需要进入的CONTAINER ID为4650e8d1bcca

​```
docker exec -it -u root 4650e8d1bcca bash
​```
```

