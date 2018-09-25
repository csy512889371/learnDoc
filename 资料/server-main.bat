for \f "tokens=5" %%i in ('netstat -ano ^| findstr 8102 ^| findstr LISTENING') do (
taskkill -pid  %%i -f
)
title server-main
ping -n 3 127.0.0.1
java -jar -Xms800m -Xmx800m -Denv=fat -Dfat_meta=http://205.0.3.94:8180 D:\spring-cloud-court\test\court-cxtj-main-1.0-SNAPSHOT.jar 