GITLAB



```
version: '2'
services:
    gitlab:
      image: 'twang2218/gitlab-ce-zh:11.1.4'
      restart: always
      hostname: '192.168.66.40'
      environment:
        TZ: 'Asia/Shanghai'
        GITLAB_OMNIBUS_CONFIG: |
          external_url '192.168.66.40'
          gitlab_rails['gitlab_shell_ssh_port'] = 2222
          unicorn['port'] = 8888
          nginx[listen_port] = 80
          gitlab_rails['time_zone'] = 'Asia/Shanghai'
          # 需要配置到 gitlab.rb 中的配置可以在这里配置，每个配置一行，注意缩进。
          # 比如下面的电子邮件的配置：
          # gitlab_rails['smtp_enable'] = true
          # gitlab_rails['smtp_address'] = "smtp.exmail.qq.com"
          # gitlab_rails['smtp_port'] = 465
          # gitlab_rails['smtp_user_name'] = "xxxx@xx.com"
          # gitlab_rails['smtp_password'] = "password"
          # gitlab_rails['smtp_authentication'] = "login"
          # gitlab_rails['smtp_enable_starttls_auto'] = true
          # gitlab_rails['smtp_tls'] = true
          # gitlab_rails['gitlab_email_from'] = 'xxxx@xx.com'
      ports:
        - '80:80'
        - '443:443'
        - '2222:22'
      volumes:
        - ./config:/etc/gitlab
        - ./data:/var/opt/gitlab
        - ./logs:/var/log/gitlab
```



```
创建文件夹
mkdir -p /usr/local/docker/gitlab
编辑
vi docker-compose.yml
如下代码
version: '3'
services: 
  web:
    image: 'twang2218/gitlab-ce-zh:11.1.4'
    restart: always
    hostname: '192.168.66.40'
    environment:
      TZ: 'Asia/Shanghai'
      GITLAB_OMNIBUS_CONFIG: |
        external_url  'http://192.168.66.40'
        gitlab_rails['gitlab_shell_ssh_port'] = 2222
        unicorn['port'] = 8888
        nginx['listen_port'] = 80
    ports: 
      - '80:80'
      - '8443:443'
      - '2222:22'
    volumes:
      - /usr/local/docker/gitlab/config:/etc/gitlab
      - /usr/local/docker/gitlab/data:/var/opt/gitlab
      - /usr/local/docker/gitlab/logs:/var/log/gitlab

```



查看日志

```
docker ps

docker logs -f mmmmmm
```



