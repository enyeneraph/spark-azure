FROM python:3.9.0

WORKDIR /app

#install pyspark, pandas and delta-spark
RUN pip install pyspark pandas delta-spark


#download spark
RUN mkdir spark && \
    # wget -P spark https://github.com/kontext-tech/winutils/raw/master/hadoop-3.3.1/bin/winutils.exe && \
    wget -P spark https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-without-hadoop.tgz && \
    cd spark && \
    tar -xvzf spark-3.2.1-bin-without-hadoop.tgz && \
    rm spark-3.2.1-bin-without-hadoop.tgz 


#download hadoop
RUN mkdir hadoop && \
    wget -P hadoop  https://archive.apache.org/dist/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz && \
    cd hadoop && \
    tar -xvzf hadoop-3.3.1.tar.gz && \ 
    rm hadoop-3.3.1.tar.gz


#download java
RUN mkdir java && \
    wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz && \
    tar -xvzf jdk-8u131-linux-x64.tar.gz -C java && \ 
    rm jdk-8u131-linux-x64.tar.gz

# download winutils.exe and save in bin
RUN  wget -P $HADOOP_HOME/bin https://github.com/kontext-tech/winutils/raw/master/hadoop-3.3.1/bin/winutils.exe 

COPY azure-datalake.py azure-datalake.py

# RUN export JAVA_HOME=java/jdk1.8.0_131

#set environment variables
ENV HADOOP_HOME=hadoop/hadoop-3.3.1
ENV SPARK_HOME=spark/spark-3.2.1-bin-without-hadoop
ENV JAVA_HOME=java/jdk1.8.0_131
ENV PATH="$PATH:/app/java/jdk1.8.0_131/bin:/app/spark/spark-3.2.1-bin-without-hadoop/bin:/app/hadoop/hadoop-3.3.1/bin"
ENV SPARK_DIST_CLASSPATH=app/hadoop/hadoop-3.3.1/etc/hadoop:/app/hadoop/hadoop-3.3.1/share/hadoop/common/lib/*:/app/hadoop/hadoop-3.3.1/share/hadoop/common/*:/app/hadoop/hadoop-3.3.1/share/hadoop/hdfs:/app/hadoop/hadoop-3.3.1/share/hadoop/hdfs/lib/*:/app/hadoop/hadoop-3.3.1/share/hadoop/hdfs/*:/app/hadoop/hadoop-3.3.1/share/hadoop/mapreduce/*:/app/hadoop/hadoop-3.3.1/share/hadoop/yarn:/app/hadoop/hadoop-3.3.1/share/hadoop/yarn/lib/*:/app/hadoop/hadoop-3.3.1/share/hadoop/yarn/*:/app/hadoop/hadoop-3.3.1/share/hadoop/tools/lib/*
ENV PYSPARK_PYTHON=python

ENTRYPOINT [ "python", "azure-datalake.py" ]








# # Set env variables
# ENV SPARK_HOME=/spark
# ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info
# ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip


# # Add additional repo's for apk to use
# RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.3/main > /etc/apk/repositories; \
#     echo http://mirror.yandex.ru/mirrors/alpine/v3.3/community >> /etc/apk/repositories

# # Update commands
# RUN apk --update add wget tar bash coreutils procps openssl
    

# RUN export PATH="/usr/local/sbt/bin:$PATH" &&  apk update && apk add ca-certificates wget tar && mkdir -p "/usr/local/sbt"

# # Get Apache Spark
# RUN wget http://mirror.ox.ac.uk/sites/rsync.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# # Install Spark and move it to the folder "/spark" and then add this location to the PATH env variable
# RUN tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
#     mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark && \
#     rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
#     export PATH=$SPARK_HOME/bin:$PATH

# # Install jars needed for communication with Azure
# RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/${HADOOP_VERSION}.0/hadoop-azure-${HADOOP_VERSION}.0.jar -P $SPARK_HOME/jars/ && \
#     wget https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/8.6.3/azure-storage-8.6.3.jar -P $SPARK_HOME/jars/

