# WildFly-MySQL

WildflyとMySQLを起動するdocker-composeです。

## WildFly

イメージ起動時にMySQLのデータソースを作成します。

### 環境変数

- MYSQL_CONNECTOR_VERSION
    - 使用するMySQL Connectorのバージョン
    - 5.1.49(mysql-connector-java-[バージョン].jarの[バージョン]に相当)
- MYSQL_JNDINAME
    - 作成するデータソースのJNDI名
    - default: java:jboss/datasources/mysqlds
- MYSQL_ADDRESS
    - MySQLサーバのアドレス
    - default: localhost
- MYSQL_PORT
    - MySQLサーバのポート
    - default: 3306
- MYSQL_DBNAME
    - 使用するMySQLデータベース名
    - default: db
- MYSQL_USERNAME
    - 使用するMySQLユーザ名
    - default: user
- MYSQL_PASSWORD
    - 使用するMySQLユーザのパスワード
    - default: password

### ディレクトリ構成

- jboss/customization
    - execute.sh
        - イメージ起動時に実行するシェル
    - mysql-connector-java-5.1.49
        - MySQL JDBCドライバ
    - /deployments
        - デプロイするアプリケーションのファイルを格納する

## MySQL

### 環境変数
- MYSQL_ROOT_PASSWORD
    - MySQL rootユーザパスワード
- MYSQL_DATABASE
    - 作成するデータベース名
- MYSQL_USER
    - 作成するユーザ名
- MYSQL_PASSWORD
    - 作成するユーザのパスワード名

### ディレクトリ構成

- mysql/customization
    - my.cnf
        - MySQLの設定ファイル
- mysql/init
    - イメージ起動時に実行したいSQLファイルを格納する
