Git 全局设置

```
git config --global user.name "xxx"
git config --global user.email "ddd@qq.com"
```
创建新版本库

```
git clone ssh://git@192.168.66.40:2222/loit-Infrastructure/loit-seata-order-example.git
cd loit-seata-order-example
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master
```
已存在的文件夹

```
cd existing_folder
git init
git remote add origin ssh://git@192.168.66.40:2222/loit-Infrastructure/loit-seata-order-example.git
git add .
git commit -m "Initial commit"
git push -u origin master
```
已存在的 Git 版本库

```
cd existing_repo
git remote rename origin old-origin
git remote add origin ssh://git@192.168.66.40:2222/loit-Infrastructure/loit-seata-order-example.git
git push -u origin --all
git push -u origin --tags
```