#!/bin/bash

# 変数定義
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_CLI_CMD_FILE=$JBOSS_HOME/customization/jboss-cli-commands.txt
JBOSS_MODE=${JBOSS_MODE:-"standalone"}
JBOSS_CONFIG=${JBOSS_CONFIG:-"$JBOSS_MODE.xml"}

# データソース定義用環境変数の初期値設定
MYSQL_CONNECTOR_VERSION=${MYSQL_CONNECTOR_VERSION:-'5.1.49'}
MYSQL_JNDINAME=${MYSQL_JNDINAME:-'java:jboss/datasources/mysqlds'}
MYSQL_ADDRESS=${MYSQL_ADDRESS:-'localhost'}
MYSQL_PORT=${MYSQL_PORT:-'3306'}
MYSQL_DBNAME=${MYSQL_DBNAME:-'db'}
MYSQL_USERNAME=${MYSQL_USERNAME:-'user'}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-'password'}
# \\\\ → \\ シェルのエスケープ文字ため
# \\ → \ jboss.cliのエスケープ文字のため
CONNECTION_URL="jdbc:mysql://$MYSQL_ADDRESS:$MYSQL_PORT/$MYSQL_DBNAME?useSSL\\=false"

cat $JBOSS_CLI_CMD_FILE

# JBossの起動
echo "=> Starting WildFly server"
echo $JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG &
$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 &

# JBossの起動待ち
echo "=> Waiting for the server to boot"
until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
  sleep 1
done

# データソースの登録
echo "=> Configuring MySQL datasource"
$JBOSS_CLI -c --command="module add --name=org.mysql --resources=/opt/jboss/wildfly/customization/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar --dependencies=javax.api,javax.transaction.api"
$JBOSS_CLI -c --command="/subsystem=datasources/jdbc-driver=mysql:add(driver-module-name=org.mysql,driver-name=mysql,driver-class-name=com.mysql.jdbc.Driver)"
$JBOSS_CLI -c --command="/subsystem=datasources/data-source=mysqlds:add(jndi-name=$MYSQL_JNDINAME,driver-name=mysql,connection-url=$CONNECTION_URL,user-name=$MYSQL_USERNAME,password=$MYSQL_PASSWORD)"
$JBOSS_CLI -c --command="/subsystem=datasources/data-source=mysqlds:test-connection-in-pool"

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi

echo "=> Restarting WildFly"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG

# 参考
# jboss/wildflyイメージでデータソースを登録するためのシェルの書き方
# https://stackoverflow.com/questions/37778656/docker-jboss-wildfly-how-to-add-datasources-and-mysql-connector
#
# jboss-cli.shを非対話的に実施する方法
# https://access.redhat.com/documentation/ja-jp/red_hat_jboss_enterprise_application_platform/7.2/html/management_cli_guide/non_interactive_mode
#
# jboss-cli.shでのデータソース登録方法
# http://mythosil.hatenablog.com/entry/2014/06/30/090410
#
# jboss-cliからデータソース作成時にmysqlへのConnectionURLにuseSSL=falseが指定されている場合にエラーが発生する
# https://stackoverflow.com/questions/48993996/wildfly-jboss-cli-sh-add-datasource-mysql-with-usessl-false
