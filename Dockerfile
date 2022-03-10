FROM python:3.9.0

WORKDIR /app

COPY requirements.txt /app/

RUN pip install -r requirements.txt

#download spark without Hadoop
RUN mkdir spark && \
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

# Set environment variables
ENV HADOOP_HOME=hadoop/hadoop-3.3.1
ENV SPARK_HOME=spark/spark-3.2.1-bin-without-hadoop
ENV JAVA_HOME=java/jdk1.8.0_131

# download winutils.exe
RUN  wget -P $HADOOP_HOME/bin https://github.com/kontext-tech/winutils/raw/master/hadoop-3.3.1/bin/winutils.exe 


RUN export JAVA_HOME=java/jdk1.8.0_131
ENV PATH="$PATH:/app/java/jdk1.8.0_131/bin:/app/spark/spark-3.2.1-bin-without-hadoop/bin:/app/hadoop/hadoop-3.3.1/bin"

ENV SPARK_DIST_CLASSPATH=app/hadoop/hadoop-3.3.1/etc/hadoop:/app/hadoop/hadoop-3.3.1/share/hadoop/common/lib/*:/app/hadoop/hadoop-3.3.1/share/hadoop/common/*:/app/hadoop/hadoop-3.3.1/share/hadoop/hdfs:/app/hadoop/hadoop-3.3.1/share/hadoop/hdfs/lib/*:/app/hadoop/hadoop-3.3.1/share/hadoop/hdfs/*:/app/hadoop/hadoop-3.3.1/share/hadoop/mapreduce/*:/app/hadoop/hadoop-3.3.1/share/hadoop/yarn:/app/hadoop/hadoop-3.3.1/share/hadoop/yarn/lib/*:/app/hadoop/hadoop-3.3.1/share/hadoop/yarn/*:/app/hadoop/hadoop-3.3.1/share/hadoop/tools/lib/*
ENV PYSPARK_PYTHON=python

COPY azure_connector.py azure_connector.py

ENTRYPOINT [ "python", "azure_connector.py" ]