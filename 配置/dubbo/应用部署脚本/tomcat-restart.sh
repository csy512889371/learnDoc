## java env
export JAVA_HOME=/usr/local/java/jdk1.7.0_72
export JRE_HOME=$JAVA_HOME/jre

## restart tomcat
current_dir=$(cd `dirname $0`; pwd)
echo "=== current_dir is:$current_dir"
$current_dir/bin/shutdown.sh
sleep 3
rm -rf $current_dir/webapps/*/
sleep 2
$current_dir/bin/startup.sh

