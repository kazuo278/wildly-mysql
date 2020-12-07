FROM mysql:5.7

RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# MySQL設定ファイルのコピー
COPY customization/my.cnf /etc/mysql/conf.d/my.cnf
# 初期データ
COPY init/*.sql /docker-entrypoint-initdb.d
# 参考
# https://www.xlsoft.com/jp/blog/blog/2019/10/09/post-7617/
# https://hub.docker.com/_/mysql