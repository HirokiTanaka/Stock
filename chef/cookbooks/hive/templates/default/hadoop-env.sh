# java
export JAVA_HOME=/usr/java/latest

# hadoop
export HADOOP_INSTALL=<%= node.hadoop.install_dir %>/hadoop
export HADOOP_HOME=${HADOOP_INSTALL}
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_INSTALL}/share/hadoop/tools/lib/*

# hive
export HIVE_HOME=<%= node.hive.install_dir %>/hive

# set up path
export PATH=${PATH}:${HADOOP_HOME}/bin:${HIVE_HOME}/bin