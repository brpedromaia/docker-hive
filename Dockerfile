FROM brpedromaia/hadoop
LABEL Pedro Maia Martins de Sousa <brpedromaia@gmail.com> and  Rodolfo Silva <Homaru> 

#######################################################
### Hive Installation
#######################################################

#COPY apache-hive-2.1.0-bin.tar.gz /usr/local/
#RUN ln -s /usr/local/hive/lib/hive-contrib-2.1.0.jar /usr/local/hive/lib/hive-contrib.jar

ADD  apache-hive-1.2.1-bin.tar.gz /usr/local/
RUN ln -s /usr/local/apache-hive-1.2.1-bin /usr/local/hive
ENV CLASSPATH $CLASSPATH:/usr/local/hadoop/lib/*:/usr/local/hive/lib/*:.
ENV PATH $PATH:/usr/local/hive/bin

#CARGA TESTE -- git aqui
#ADD carga-teste.tar.gz /
#RUN mv /carga-teste /carga


COPY hive_test_sh.tar.gz /

#RUN  chmod 777 -R /carga/

#######################################################
### Expose Ports
#######################################################

EXPOSE 10000 10002 1527 22

#######################################################
### Entrypoint
#######################################################

ADD hive-entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

