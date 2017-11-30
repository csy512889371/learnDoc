# 常用命令

```xml

df -h
rm -rf *.log
rm -rf logs/*
ps -ef|grep tomcat
cd /opt/nginx
ls
ps -ef|grep /nginx
./sbin/nginx -t
./sbin/nginx stop
./sbin/nginx -s stop
ps -ef|grep /nginx
./sbin/nginx -t
./sbin/nginx
ps -ef|grep /nginx
   21  ./sbin/nginx -t
   22  df -h
   23  df
   24  cd /root/fay/solr/tomcat
   25  ls
   26  ./tomcat8-8984/bin/shutdown.sh 
   27  ./tomcat8-8985/bin/shutdown.sh 
   28  ps -ef|grep tomcat
   29  rm -rf tomcat8-8984/logs/*
   30  rm -rf tomcat8-8985/logs/*
   31  df
   32  df -h
   33  ./tomcat8-8984/bin/startup.sh 
   34  ./tomcat8-8985/bin/startup.sh 
   35  ps -ef|grep tomcat
   36  cd /opt/tomcat
   37  ./bin/startup.sh 
   38  logout
   39  df -h;
   40  df -hl
   41  cd fay/solr/tomcat/tomcat8-8985/
   42  ls
   43  cd logs/
   44  ls
   45  du -h
   46  du
   47  cd ../webapps/solr/
   48  ls
   49  cd solrhome/
   50  ls
   51  cd item/
   52  ls
   53  cd data/
   54  ls
   55  du
   56  du -h
   57  eixt
   58  exit
   59  ps -ef|grep /opt/tomcat
   60  logout
   61  ps -ef|grep /opt/tomcat
   62  ps -ef|grep redis
   63  cd /opt/tomcat
   64  ./bin/shutdown.sh 
   65  ps -ef|grep /opt/tomcat
   66  ./bin/startup.sh 
   67  cd /opt/redis-3.2.0
   68  ./src/redis-cli
   69  df -h
   70  cd /opt/tomcat
   71  ./bin/shutdown.sh 
   72  rm -rf logs/*
   73  ./bin/startup.sh 
   74  df -h
   75  df 
   76  ./bin/shutdown.sh 
   77  ps -ef|grep /opt/tomcat
   84  rm -rf es/*
   85  df 
   86  cd /opt/tomcat
   87  ./bin/startup.sh 
   88  scp -r /opt/tomcat
   89  scp -r /opt/tomcat/webapps/*.war root@192.168.210.193:/opt/tomcat
   90  cd /opt/tomcat
   91  ./bin/shutdown.sh 
   92  cd /opt/nginx-1.10.1
   93  vi conf/nginx.conf 
   94  cd ..
   95  cd nginx
   96  vi conf/nginx.conf
   97  ./sbin/nginx -s reload
   98  ps -ef|grep /opt/tomcat
   99  vi conf/nginx.conf
  100  ps -ef|grep tomcat
  101  cd fay/simba/
  102  ls
  103  cd simba-server-api/
  104  ls
  105  cd simba-uums-api/
  106  ls
  107  cd apache-tomcat-8.5.11/
  108  ls
  109  cd webapps/
  110  ls
  111  cd ..
  112  cd bin/
  113  ./startup.sh 
  122  cd fay-font-end/
  124  cd fay-uc/
  126  cd nginx/
  128  cd build/
  130  cd nginx
  132  cd sbin/
  133  ls
  134  /root/fay/fay-font-end/fay-uc/nginx/build/nginx/sbin/nginx -c /root/fay/fay-font-end/fay-uc/nginx/build/nginx/conf/nginx.conf
  135  /root/fay/fay-font-end/fay-admin/nginx/sbin/nginx -c /root/fay/fay-font-end/fay-admin/nginx/conf/nginx.conf
  136  ps -ef|grep /opt/tomcat
  137  cd /opt/tomcat
  138  logout
  139  cd /opt/tomcat
  140  cat conf/server.xml 
  141  logout
  142  cd fay/
  143  ls
  144  cd fay-font-end/
  145  ls
  146  cd fay-admin/
  147  ls
  148  cd nginx/
  149  ls
  150  cd conf/
  151  ls
  152  vim nginx.conf
  153  exit
  154  cd /opt/tomcat
  155  cat bin/catalina.sh 
  156  logout
  157  ./redis-cli
  158  find -name redis
  159  cd /usr/local
  160  ls
  161  cd ..
  162  cd opt/
  163  ls
  164  cd redis-3.2.0
  165  ls
  166  cd src/
  167  ls
  168  ./redis-cli 
  169  df -hl
  170  cd fay/solr/
  171  ls
  172  cd tomcat/
  173  ls
  174  cd tomcat8-8985/
  175  ls
  176  cd logs/
  177  ls
  178  df -hl
  179  du -h
  180  rm -f 
  181  ls
  182  rm -f *
  183  ls
  184  rm -f 
  185  cd ..
  186  ls
  187  du -hl
  188  ls
  189  du -hl
  190  ls
  191  cd logs
  192  ls
  193  du -h
  194  cd ..
  195  ls
  196  du -h
  197  ls
  198  df -h
  199  df
  200  du -f
  201  du -hl
  202  cd ..
  203  ls
  204  df
  205  df -hl
  206  cd /dev/mapper/
  207  ls
  208  cd vg_jczjapp-lv_root 
  209  du -sh ~/.local/share/Trash
  210  root/.cache/drag_and_drop
  211  cd root/.cache/drag_and_drop
  212  cd /root/.cache/drag_and_drop
  213  cd /root/.cache/
  214  ls
  215  du -h
  216  cd ~
  217  cd .local/share/
  218  ls
  219  du -h
  220  cd /tmp/
  221  du -hl
  222  cd /var/
  223  du -hl
  224  cd /var/lib/mlocate/
  225  ls
  226  du -hl
  227  cd /root/fay/
  228  ls
  229  cd simba/
  230  ls
  231  cd simba-server-api/
  232  ls
  233  cd simba-uums-api/
  234  ls
  235  cd ../../
  236  s
  237  ls
  238  cd ../fay-font-end/
  239  ls
  240  du -hl
  241  du -h -s 
  242  du -sh /* | sort -nr
  243  lsof -n | grep deleted
  244  kill -9 19358
  245  lsof -n | grep deleted
  246  cd ~
  247  cd /
  248  du -sh /* | sort -nr
  249  lsof |grep delete
  250  kill -9 6908
  251  lsof |grep delete
  252  df -h
  253  lsof |grep delete
  254  kill -9 19249
  255  lsof |grep delete
  256  kill -9 11264
  257  lsof |grep delete
  258  df -h
  259  cd /root/
  260  lsof |grep delete
  261  df -h
  262  free -m
  263  free -m -h
  264  free -g
  265  df -lh
  266  ls
  267  du -h
  268  du -s ztesoft
  269  df -lh
  270  reboot
  271  ls
  272  uname -a
  273  df -h
  274  df -h
  275  curl www.baidu,com
  276  curl www.baidu.com
  277  ps -ef|grep nginx
  278  cd /opt/nginx
  279  ls
  280  ./sbin/nginx
  281  cd /opt/redis-3.2.0/
  282  ./src/redis-cli
  283  ps -ef|grep redis
  284  cd
  285  ls
  286  scp -r /data/static/ root@192.168.210.194:/dataSource
  287  rm -rf /data/static/
  288  df -h
  289  cd /opt/redis-3.2.0/
  290  ./src/redis-cli
  291  service redis_6379 stop
  292  service redis_6379 start
  293  ./src/redis-cli
  294  logout
  295  df -h
  296  ps -ef|grep /tomcat
  297  ps -ef|grep tomcat
  298  rm -rf /root/fay/solr/tomcat/tomcat8-8984/logs/*
  299  df -h
  300  rm -rf /root/fay/simba/simba-server-api/simba-uums-api/apache-tomcat-8.5.11/logs/*
  301  cat /opt/redis-3.2.0/redis.conf 
  302  cd /opt/redis-3.2.0/
  303  ./src/redis-cli
  304  df -h
  305  logout
  306  df -h
  307  fdisk -l
  308  vgdispkay
  309  vgdisplay
  310  lvresize -L +20G /dev/mapper/vg_jczjapp-lv_root
  311  resize2fs /dev/mapper/vg_jczjapp-lv_root
  312  df -h
  313  lvresize -L +19.9G /dev/mapper/vg_jczjapp-lv_root
  314  resize2fs /dev/mapper/vg_jczjapp-lv_root
  315  df -h
  316  ps -ef|grep tomcat
  317  cd /opt/
  318  ls
  319  cd redis-3.2.0/
  320  cd src/
  321  ls
  322  ./redis-server 
  323  ps -ef|grep redis
  324  ps -ef|grep zookeeper
  325  ps -ef|grep tomcat
  326  cd /home/com/rjsoft/
  327  ls
  328  cd simba/
  329  ls
  330  cd service/
  331  ls
  332  cd uums
  333  ls
  334  cd ../uums1/
  335  ls
  336  ./service-uums.sh 
  337  cd ../uums
  338  ls
  339  cd bin/
  340  ls
  341  ./start.sh 
  342  ps -ef|grep tomcat
  343  ls
  344  cd ..
  345  cd bin/
  346  ./restart.sh 
  347  ls
  348  ./server.sh 
  349  ./stop.sh 
  350  ./start.sh 
  351  cd ..
  352  ls
  353  cd ..
  354  ls
  355  cd uums1/
  356  ls
  357  java -jar simba-service-uums-v1.0-SNAPSHOT.jar 
  358  bg
  359  exit
  360  cd /opt/
  361  ls
  362  cd zk_server/
  363  ls
  364  cd bin/
  365  sh zkServer.sh 
  366  sh zkServer.sh start
  367  cd fay/
  368  ls
  369  cd fay-font-end/
  370  ls
  371  cd fay-uc/
  372  ls
  373  cd nginx/
  374  ls
  375  cd build/
  376  ls
  377  cd nginx
  378  ls
  379  cd sbin/
  380  ls
  381  /root/fay/fay-font-end/fay-uc/nginx/build/nginx/sbin/nginx  -c /root/fay/fay-font-end/fay-uc/nginx/build/nginx/conf/nginx.conf
  382  cd ..
  383  cd ../../..
  384  cd ..
  385  ls
  386  cd simba/
  387  ls
  388  cd simba-server-api/
  389  ls
  390  cd simba-uums-api/
  391  ls
  392  cd apache-tomcat-8.5.11/
  393  ls
  394  cd bin/
  395  ./startup.sh 
  396  ./shutdown.sh 
  397  ps -ef|grep tomcat
  398  ./shutdown.sh 
  399  date
  400  hwclock --show
  401  date -s 11:09:15
  402  date
  403  hwclock --show
  404  hwclock --hctosys
  405  hwclock --show
  406  date
  407  date -s 11:10:10
  408  clock --systohc
  409  hwclock --show
  410  cd fay/
  411  ls
  412  cd fay-font-end/
  413  ls
  414  cd fay-admin/
  415  ls
  416  cd nginx/
  417  ls
  418  cd conf/n
  419  cd c
  420  cd conf/
  421  ls
  422  vim nginx.conf
  423  /root/fay/fay-font-end/fay-admin/nginx/sbin/nginx -c /root/fay/fay-font-end/fay-admin/nginx/conf/nginx.conf
  424  vim nginx.conf
  425  cd /root/fay/solr/zookeeper/zookeeper3-2182/zookeeper/bin/
  426  sh zkServer.sh start
  427  cd ../../../../tomcat/tomcat8-8985/bin/
  428  ./startup.sh 
  429  cd ../../tomcat8-8984/bin/
  430  ./startup.sh 
  431  cat /proc/version
  432  exit
  433  ps -ef|grep redis
  434  ps -ef|grep zookeeper
  435  ping 192.168.210.194
  436  cd fay/solr/
  437  ls
  438  cd zookeeper/zookeeper3-2182/zookeeper/
  439  ls
  440  cd bin/
  441  ls
  442  sh zkServer.sh stop
  443  cd ../../../../
  444  cd tomcat/tomcat8-8985/bin/
  445  ./shutdown.sh 
  446  cd ../../tomcat8-8984/bin/
  447  ./shutdown.sh 
  448  ping 192.168.210.194
  449  ping 192.168.210.175
  450  ssh -t root@192.168.210.175
  451  ping 192.168.210.194
  452  cd /home/
  453  ls
  454  cd com/rjsoft/simba/service/uums
  455  ls
  456  cd /etc/init.d/
  457  ls
  458  cat nginx 
  459  ls
  460  cat dubbo-uums 
  461  vi /etc/sysconfig/network-scripts/ifcfg-eth1
  462  ping 192.168.210.192
  463  ping 192.168.210.193
  464  ping 192.168.210.194
  465  ps -ef|grep zookeeper
  466  cd /opt/
  467  ls
  468  cd zk_server/
  469  ls
  470  cd con
  471  ls
  472  cd conf/
  473  ls
  474  vim zoo.cfg 
  475  cd ../bin/
  476  ls
  477  vim zkServer.
  478  vim zkServer.sh 
  479  cd ..
  480  ls
  481  cd src/
  482  ls
  483  cd ..
  484  ls
  485  cd conf/
  486  ls
  487  vim zoo.cfg 
  488  ;s
  489  cd ..
  490  ls
  491  cd dataLog/
  492  ls
  493  cd ../data
  494  ls
  495  vim myid 
  496  cd ../bin/
  497  ls
  498  sh zkServer.sh stop
  499  ./zkServer.sh -server zk01:2181
  500  sh zkServer.sh start-foreground -server zk01:2181
  501  sh zkServer.sh start-foreground 
  502  bg
  503  ps -ef|grep redis
  504  cd /opt/
  505  ls
  506  cd redis-3.2.0/
  507  ls
  508  cd src/
  509  ls
  510  cd ..
  511  ls
  512  vim redis.conf 
  513  ps -ef|grep tomcat
  514  cd /home/
  515  ls
  516  cd com/
  517  ls
  518  cd rjsoft/
  519  ls
  520  cd simba/
  521  ls
  522  cd service/
  523  ls
  524  cd uums
  525  ls
  526  cd bin/
  527  ls
  528  ./start.
  529  ./start.sh 
  530  ./restart.sh 
  531  ps -ef|grep tomcat
  532  ls
  533  cd ..
  534  ls
  535  cd ..
  536  ls
  537  cd uums1/
  538  ls
  539  ./service-uums.sh 
  540  vim service-uums.sh 
  541  ./service-uums.sh start
  542  sh service-uums.sh start
  543  ps -ef|grep tomcat
  544  ls
  545  ps -ef|grep tomcat
  546  java -jar simba-service-uums-v1.0-SNAPSHOT.jar 
  547  ps -ef|grep tomcat
  548  df -g
  549  df -
  550  df -h
  551  ps -ef|grep redis
  552  ps -ef|grep zookeeper
  553  cd /opt/zk_server/
  554  cd bin/
  555  sh zkServer.sh stop
  556  sh zkServer.sh start
  557  ps -ef|grep redis
  558  cd /opt/redis-3.2.0/
  559  ls
  560  cd src/
  561  ls
  562  vi redis-server 
  563  ps -ef|grep redis
  564  df -h
  565  exit
  566   redis-cli -c -p 7000
  567   redis-cli -c -p 6379
  568  cd /opt/redis-3.2.0/src/
  569  ls
  570  ./redis-trib.rb check 192.168.210.192:6379
  571   redis-cli -c -p 6379
  572  cat /etc/redis/6379.conf 
  573  service redis_6379 stop
  574  cd /var/redis/
  575  mkdir 6379bak
  576  cp 6379/* 6379bak/
  577  cd 6379
  578  rm -rf *
  579  service redis_6379 start
  580  cd /opt/redis-3.2.0/src/
  581  vi redis-trib.rb 
  582  vi redis-trib.rb check 192.168.210.192:6379
  583  ./redis-trib.rb check 192.168.210.192:6379
  584  vi redis-trib.rb 
  585  ./redis-trib.rb check 192.168.210.192:6379
  586  service redis_6379 stop
  587  cd /var/redis/
  588  ls
  589  mv 6379 6379.bak
  590  mv 6379bak 6379
  591  ls
  592  service redis_6379 start
  593  cd -
  594  ./redis-trib.rb check 192.168.210.192:6379
  595  vi redis-trib.rb 
  596  ./redis-trib.rb check 192.168.210.192:6379
  597  vi redis-trib.rb 
  598  ./redis-trib.rb check 192.168.210.192:6379
  599  redis-cli 
  600  ls
  601  cd /opt/
  602  ls
  603  cd redis-3.2.0/
  604  ls
  605  cd /etc/redis/
  606  ls
  607  cat 6379.conf 
  608  vi 6379.conf 
  609  cd -
  610  cd src/
  611  ./redis-trib.rb check 192.168.210.192:6379
  612  cd /var/redis/6379
  613  service redis_6379 restart
  614  service redis_6379 stop
  615  service redis_6379 start
  616  cd -
  617  ./redis-trib.rb check 192.168.210.192:6379
  618  service redis_6379 stop
  619  cd /var/redis/6379
  620  rm -rf *
  621  service redis_6379 start
  622  cd /opt/redis-3.2.0/src/
  623  ls
  624  ./redis-trib.rb create 192.168.210.192:6379 192.168.210.193:6379 192.168.210.194:6379
  625  cd /etc/init.d/
  626  cat redis_6379 
  627  cp redis_6379 redis_6380
  628  cd /etc/redis/
  629  ls
  630  cp 6379.conf 6380.conf 
  631  vi 6380.conf 
  632  pwd
  633  service redis_6380 start
  634  vi /etc/init.d/redis_6380 
  635  mkdir -p /var/redis/6380
  636  service redis_6380 start
  637  cd /opt/redis-3.2.0/src/
  638  ./redis-trib.rb check 192.168.210.192:6379
  639  redis-trib.rb add-node --slave --master-id abb3f6b0801d7b3752d50a228639888c224bb2ba 192.168.210.193:6380
  640  ./redis-trib.rb add-node --slave --master-id abb3f6b0801d7b3752d50a228639888c224bb2ba 192.168.210.193:6380
  641  ./redis-trib.rb check 192.168.210.192:6379
  642  cd /opt/redis-3.2.0/src/
  643  ls
  644  vi /etc/sysconfig/iptables
  645  service iptables restart
  646  ./redis-trib.rb check 192.168.210.192:6379
  647  ./redis-trib.rb add-node --slave --master-id abb3f6b0801d7b3752d50a228639888c224bb2ba 192.168.210.193:6380
  648  vi /etc/redis/6379.conf 
  649  ./redis-trib.rb add-node --slave --master-id abb3f6b0801d7b3752d50a228639888c224bb2ba 192.168.210.193:6380 192.168.210.192:6379
  650  telnet 192.168.210.193 6380
  651  ./redis-trib.rb check 192.168.210.192:6379
  652  ./redis-trib.rb add-node --slave --master-id abb3f6b0801d7b3752d50a228639888c224bb2ba 192.168.210.193:6380 192.168.210.192:6379
  653  ./redis-trib.rb check 192.168.210.192:6379
  654  ./redis-trib.rb add-node --slave --master-id 52e3aa2610b4256ce3e96b88762adb3193b59c5a 192.168.210.194:6380 192.168.210.193:6379
  655  ./redis-trib.rb check 192.168.210.192:6379
  656  ./redis-trib.rb add-node --slave --master-id df21d66d97439c54243f68fd57c6052e68aa4c11 192.168.210.192:6380 192.168.210.194:6379
  657  redis-cli 
  658  ./redis-trib.rb --help
  659  ./redis-trib.rb -help
  660  ./redis-trib.rb -h
  661  ./redis-trib.rb help
  662  ./redis-trib.rb info 192.168.210.192:6379
  663  ps -ef|grep redis
  664  cd /opt/redis-3.2.0/
  665  ./src/redis-cli
  666  cd /opt/tomcat
  667  cd ../nginx
  668  cat conf/nginx.conf
  669  ps -ef|grep nginx
  670  logout
  671  df -h
  672  cd /usr/local/
  673  rz
  674  ls
  675  tar -zxvf elasticsearch-5.5.0.tar.gz 
  676  ls
  677  cd elasticsearch-5.5.0
  678  ls
  679  cd bin/
  680  ls
  681  ./elasticsearch.sh
  682  ./elasticsearch
  683  nohup elasticsearch &
  684  tail -f nohup.out 
  685  cd ..
  686  ls
  687  cd config/
  688  ls
  689  cat elasticsearch.yml 
  690  ps -ef | grep elasticsearch
  691  ../bin/elasticsearch -d
  692  ps -ef | grep elasticsearch
  693  ls
  694  cd ..
  695  ls
  696  cd config/
  697  cat log4j2.properties 
  698  ps -ef | grep elasticsearch
  699  netstat -ant 
  700  netstat -ant | grep 9200
  701  ps -ef | grep elasticsearch
  702  kill -9 10748
  703  ps -ef | grep elasticsearch
  704  vi elasticsearch.yml 
  705  ../bin/elasticsearch -d
  706  cd ..
  707  ls
  708  ps -ef | grep elasticsearch
  709  ls
  710  mkdir data
  711  mkdir logs
  712  ls
  713  kill -9 11889
  714  bin/elasticsearch -d
  715  ls
  716  cd logs/
  717  ls
  718  cd ..
  719  ls
  720  cd data/
  721  ls
  722  cd ..
  723  ls
  724  cd bin/
  725  ls
  726  cat elasticsearch
  727  java -version
  728  ps -ef | grep elasticsearch
  729  cd ..
  730  ls
  731  cd logs/
  732  ls
  733  freee
  734  free
  735  kill -9 12166
  736  ps -ef | grep elasticsearch
  737  free
  738  ls
  739  vi /etc/sysconfig/iptables
  740  service iptables restart
  741  cd /usr/local/elasticsearch-5.5.0
  742  ls
  743  vi /etc/sysconfig/iptables
  744  service iptables restart
  745  ls
  746  lspwd
  747  pwd
  748  ulimit -n
  749  ulimit -Hn
  750  df -m
  751  free -m
  752  cat /proc/cpuinfo 
  753  cat /proc/sys/kernel/threads-max 
  754  ps -ef|grep zookeeper
  755  df -h
  756  ps -ef|grep tomcat
  757  cd fay/
  758  ls
  759  cd simba/
  760  ls
  761  cd simba-server-api/
  762  ls
  763  cd simba-uums-api/
  764  ls
  765  cd apache-tomcat-8.5.11/
  766  ls
  767  cd bin/
  768  ls
  769  ./shutdown.sh 
  770  ./startup.sh 
  771  ./shutdown.sh 
  772  ps -ef|grep tomcat
  773  ./shutdown.sh 
  774  ps -ef|grep tomcat
  775  kill -9 28117
  776  ps -ef|grep tomcat
  777  ps -ef|grep zookeeper
  778  cd /home/com/rjsoft/simba/service/uums
  779  ls
  780  cd bin/
  781  ls
  782  vim restart.sh 
  783  vim start.sh 
  784  ls
  785  cd ..
  786  ls
  787  cd ..
  788  ls
  789  cd ..
  790  ls
  791  cd service/
  792  ls
  793  cd uums1
  794  ls
  795  cd /home/com/rjsoft/simba/service/uums
  796  tar -zxvf simba-service-uums-v1.0-SNAPSHOT-assembly.tar.gz
  797  cd lib/
  798  ls
  799  date
  800  ps -ef|grep jetty
  801  ps -ef|grep tomcat
  802  ps -ef|grep zookeeper
  803  ps -ef|grep jetty
  804  ps -ef|grep tomcat
  805  ps -ef|grep jetty
  806  kill -9 2659
  807  ps -ef|grep jetty
  808  ls
  809  cd /home/com/rjsoft/simba/
  810  ls
  811  cd service/
  812  ls
  813  cd uums
  814  ls
  815  stat simba-service-uums-v1.0-SNAPSHOT.pid 
  816  stat simba-service-uums-v1.0-SNAPSHOT-assembly.tar.gz 
  817  cd l
  818  cd lib/
  819  ls
  820  stat simba-service-uums-1.0-SNAPSHOT.jar 
  821  ps -ef|grep redis
  822  cd /usr/local/
  823  ls
  824  cd bin/
  825  ls
  826  netstat -tnlp | grep redis
  827  redis-cli -c -p 6379
  828  ps -ef|grep redis
  829  redis-cli -c -p 6379
  830  ps -ef|grep nginx
  831  cd fay/simba/
  832  ls
  833  cd simba-server-api/
  834  ls
  835  cd simba-uums-api/
  836  ls
  837  cd apache-tomcat-8.5.11/
  838  ls
  839  cd bin/
  840  ./startup.sh 
  841  ps -ef | grep 61616
  842  cd /usr/local/
  843  ls
  844  cd sbin/
  845  ls
  846  cd ..
  847  ls
  848  cd src/
  849  ls
  850  cd ../
  851  ls
  852  cd /opt/
  853  ls
  854  cd ..
  855  netstat -ant | grep 61616
  856  netstat -ant | grep 8983
  857  netstat -ant
  858  cd /usr/local/
  859  ls
  860  cd /home/
  861  lsa
  862  ls
  863  cd /root/
  864  ls
  865  find -name activemq
  866  history
  867  top
  868  rpm -qa
  869  ps -ef | grep activemq
  870  rpm -qa | grep activemq
  871  rpm -qa | grep active
  872  redis-cli 
  873  redis-cli -h 192.168.210.193 -p 6379
  874  redis-cli
  875  redis-cli -p 6380
  876  cd /usr/local/
  877  ls
  878  cd /opt/
  879  ls
  880  cd redis-3.2.0/
  881  ls
  882  cd ..
  883  ls
  884  cd data/
  885  ls
  886  cd /etc/
  887  ls
  888  cd ..
  889  ls
  890  find -name  redis*
  891  service redis_6380 start
  892  redis-cli -p 6380
  893  redis-cli
  894  df -h
  895  vi /etc/exports 
  896  cd /usr/local/
  897  yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-devel -y
  898  yum -y install git 
  899  wget https://www.kernel.org/pub/software/scm/git/git-2.2.0.tar.gz
  900  wget https://www.kernel.org/pub/software/scm/git/git-2.2.0.tar.gz --no-check-certificate
  901  ls
  902  mv git-2.2.0.tar.gz  /usr/local/
  903  cd /usr/local/
  904  ls
  905  tar -zxvf git-2.2.0.tar.gz 
  906  cd git-2.2.0
  907  make prefix=/usr/local/git all
  908  make prefix=/usr/local/git install
  909  ln -s /usr/local/git/bin/* /usr/bin/
  910  git --version
  911  useradd -s /bin/bash git
  912  su - git
  913  ps -ef redis
  914  ps -ef | grep redis
  915  cd fay/simba/simba-server-api/simba-uums-api/apache-tomcat-8.5.11/
  916  ls
  917  cd bin
  918  ./shutdown.sh 
  919  ./startup.sh 
  920  du -h
  921  df -h
  922  ./shutdown.sh 
  923  cd fay/simba/simba-server-api/simba-uums-api/apache-tomcat-8.5.11/bin/
  924  ./startup.sh 
  925  ./shutdown.sh 
  926  ./startup.sh 
  927  ps -ef|grep tomcat
  928  ./shutdown.sh 
  929  sh catalina.sh run
  930  bg
  931  exit
  932  hostname
  933  cat /etc/hosts
  934  cd fay/
  935  ls
  936  cd simba/
  937  ls
  938  cd simba-server-api/
  939  ls
  940  cd simba-uums-api/
  941  ls
  942  cd apache-tomcat-8.5.11/
  943  cd webapps/
  944  ls
  945  cd ../bin/
  946  ./shutdown.sh 
  947  ./startup.sh 
  948  date
  949  exit
  950  date
  951  yum install ntp
  952  cd fay/
  953  ls
  954  cd simba/
  955  ls
  956  cd simba-server-api/
  957  ls
  958  cd simba-uums-api/apache-tomcat-8.5.11/bin/
  959  ./shutdown.sh 
  960  ./startup.sh 
  961  cd fay/
  962  ls
  963  cd fay-font-end/
  964  ls
  965  cd fay-admin/
  966  ls
  967  cd nginx/
  968  ls
  969  cd conf/
  970  ls
  971  vim nginx.conf
  972  clear
  973  cd fay/
  974  ls
  975  cd solr/
  976  ls
  977  cd tomcat/
  978  ls
  979  cd tomcat8-8985/
  980  ls
  981  cd webapps/
  982  ls
  983  cd solr/
  984  ls
  985  cd solrhome/
  986  ls
  987  cd ..
  988  df -h
  989  dh 
  990  cd fay/solr/tomcat/tomcat8-8985/
  991  ls
  992  cd webapps/
  993  ls
  994  cd solr
  995  ls
  996  cd solrhome/
  997  ls
  998  cd ..
  999  du -h
 1000  ls
 1001  ps -ef | tomcat

```