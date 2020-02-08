# GITLAB



```
创建文件夹
mkdir -p /usr/local/loit/soft/docker/gitlab
编辑
vi docker-compose.yml
如下代码

```

```
version: '3'
services:
  web:
    image: 'twang2218/gitlab-ce-zh:11.1.4'
    restart: always
    hostname: '39.100.254.140'
    environment:
      TZ: 'Asia/Shanghai'
      GITLAB_OMNIBUS_CONFIG: |
        external_url  'http://39.100.254.140'
        gitlab_rails['gitlab_shell_ssh_port'] = 12222
        unicorn['port'] = 12011
        nginx['listen_port'] = 80
    ports:
      - '12011:80'
      - '12443:443'
      - '12222:22'
    volumes:
      - /usr/local/loit/soft/docker/gitlab/config:/etc/gitlab
      - /usr/local/loit/soft/docker/gitlab/data:/var/opt/gitlab
      - /usr/local/loit/soft/docker/gitlab/logs:/var/log/gitlab
```



查看日志

```
docker ps

docker logs -f mmmmmm
```



