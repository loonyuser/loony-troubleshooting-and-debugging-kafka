# In the browser go to localhost:9021

# https://docs.confluent.io/platform/current/platform.html
# https://docs.confluent.io/platform/current/control-center/index.html

# Since we running the control center in the laptop ie a single machine 
# that is showing under healthy clusters

# Click on "controlcenter.cluster" (This will give an overview of the cluster)
# We have come to the overview of the entire cluster
# We can there are one broker then there is 60 topics and 320 petitions by default
# Also note that these topics are not created by ours it is created by the kafka

--------------------------------
Brokers

# Now let's click on the brokers subtopic
# We can observe the throughput
# of the producers and consumers been displayed at the top
# Followed by 60 partitions which of course we did not create it was 
# created by Kafka which are internal topics and there are about 
# 198 partitions and 320 replicas which is by default

# Also we can see other information like it for the zookeeper is connected
# How much disk space is used also below we are observe similar metrics
# of the cluster like the throughput and  latency of both the producer 
# and the consumer


-------------------------------
Topics

# Now let's click on the topic subtopic

# Click on the slider to show internal topics 
# Scroll horizontally and show the information
# Click the slider back to hide the internal topics

# If we click on anyone of those topics lets say in my case
# "default_ksql_processing_log" in the overview section we can observe
# the avalibility the offset and the size 

# Click on Overview, Messages, Schema, Configuration


-------------------------------
Connect

# Now let's click on the connect subtopic
# Connect manages, monitor, and configure connectors with Kafka Connect, 
# the toolkit for connecting external systems to Kafka.

-------------------------------
ksqlDB

# Now let's click on the ksqlDB
# Here we can execute queries against kafka topic data's and also 
# allowing to create streams and table against topic data's

# Click on each option here Editor, Flow, Streams, Tables etc

-------------------------------
Consumers


# Now let's click on the consumer
# Here we will get the list of consumer groups in the cluster also providing
# the info on Messages behind, Number of consumers, Number of topics
# now if we click on any of those consumer groups we will get more
# insights


-------------------------------
Replicators

# Now lets click on the replicators
# Monitor and configure replicated topics and create replica topics 
# that preserve topic configuration in the source cluster.


-------------------------------
Cluster settings

# Now lets click on cluster settings
# Here we can view and edit cluster properties and broker configurations
# like name host ports..etc

# Expand "General" and show the settings
# Click on "Overridden" for broker.id and show

# Click and expand Logs, Replication, Threads, Zookeeper

# Click on "Overidden" in Zookeeper















