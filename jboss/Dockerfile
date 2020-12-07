FROM jboss/wildfly:10.0.0.Final

USER root
# タイムゾーンをAsia/Tokyoに変更
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# カスタマイズ用のファイルを配備
COPY customization /opt/jboss/wildfly/customization/
RUN chmod +x /opt/jboss/wildfly/customization/execute.sh \
    && chown jboss:jboss -R /opt/jboss/wildfly/customization

USER jboss
CMD ["/opt/jboss/wildfly/customization/execute.sh"]