FROM brpedromaia/hadoop
LABEL Pedro Maia Martins de Sousa <brpedromaia@gmail.com> and  Rodolfo Silva <Homaru> 

#######################################################
### Hive Installation
#######################################################

ADD  apache-hive-1.2.1-bin.tar.gz /usr/local/

RUN ln -s /usr/local/apache-hive-1.2.1-bin /usr/local/hive

ENV HIVE_HOME /usr/local/hive
ENV HCAT_HOME $HIVE_HOME/hcatalog/
ENV CLASSPATH $CLASSPATH:/usr/local/hadoop/lib/*:$HIVE_HOME/lib/*:.
ENV PATH $PATH:$HIVE_HOME/bin


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

