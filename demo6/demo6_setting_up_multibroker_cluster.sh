# https://docs.confluent.io/platform/current/kafka/kafka-basics.html#multi-node-production-ready-deployments
# https://docs.confluent.io/platform/current/control-center/brokers.html

-----------------------------------------------------------------
# Until now we have been using a single broker with a replication factor of 1
# Now lets us create a multi-broker cluster and monitor them
# This will allow us to have a replication factor > 1 for our topics


# Open a terminal on full screen

# Stop all the running services
$ confluent local services stop

$ cd $CONFLUENT_HOME/etc/kafka/

$ ls -l


# Drag the kafka/ folder to Sublimetext to edit the server.properties file

# There should be 4 files 

# server-0.properties
# server-1.properties
# server-2.properties
# server-3.properties

# Click on server-0.properties and show the changes

# ---------Individual broker properties


# Scroll and show these properties 
broker.id=0

listeners=PLAINTEXT://127.0.0.1:9092
advertised.listeners=PLAINTEXT://127.0.0.1:9092

log.dirs=/tmp/kafka-logs-0


# Scroll to the very bottom and show this line
confluent.http.server.listeners=http://localhost:8090


# ---------Common properties for all brokers


# Search for metrics.reporter and show these two properties
metric.reporters=io.confluent.metrics.reporter.ConfluentMetricsReporter
confluent.metrics.reporter.bootstrap.servers=localhost:9092


# Search for replication.factor in Sublime text and show
# that we have updated these 4 properties
offsets.topic.replication.factor=3
transaction.state.log.replication.factor=3
confluent.license.topic.replication.factor=3
confluent.metadata.topic.replication.factor=3
confluent.balancer.topic.replication.factor=3


# Search for replicas in Sublime text and show
# that we have updated these 2 properties
confluent.metrics.reporter.topic.replicas=3
confluent.security.event.logger.exporter.kafka.topic.replicas=3


# Search for min.isr and show this property
transaction.state.log.min.isr=3


# Now just open up the remaining 3 files

# server-1.properties
# server-2.properties
# server-3.properties

# And scroll from the top to the bottom

-----------------------------------------------------------------

# This is to run Connect

# Open connect-distributed.properties on Sublimetext

# connect-distributed.properties
# Search for storage.replication.factor

offset.storage.replication.factor=3
config.storage.replication.factor=3
status.storage.replication.factor=3


-----------------------------------------------------------------


# In terminal
$ cd ../confluent-control-center/

$ ls -l

# Open control-center.properties in Sublimetext

# control-center.properties
# Add the below line of code
bootstrap.servers=localhost:9092
zookeeper.connect=localhost:2181
confluent.controlcenter.id=1
confluent.controlcenter.data.dir=/tmp/confluent/control-center
confluent.controlcenter.connect.connect-default.cluster=http://localhost:8083
confluent.controlcenter.ksql.ksqlDB.url=http://localhost:8088
confluent.controlcenter.schema.registry.url=http://localhost:8081
confluent.controlcenter.streams.cprest.url=http://localhost:8090,http://localhost:8091,http://localhost:8092, http://localhost:8093
confluent.controlcenter.internal.topics.replication=1
confluent.controlcenter.internal.topics.partitions=2
confluent.controlcenter.command.topic.replication=1
confluent.controlcenter.ui.autoupdate.enable=false
confluent.controlcenter.usage.data.collection.enable=true
confluent.monitoring.interceptor.topic.partitions=2
confluent.monitoring.interceptor.topic.replication=1
confluent.metrics.topic.replication=1
confluent.controlcenter.connect.cluster=http://localhost:8083
confluent.controlcenter.ksql.ksqlDB.url=http://localhost:8088
confluent.controlcenter.schema.registry.url=http://localhost:8081

# Open a terminal
# If the control center is working from the before demos lets stop it
$ confluent local services stop

# Open a terminal with 5 tabs
$ zookeeper-server-start $CONFLUENT_HOME/etc/kafka/zookeeper.properties

$ kafka-server-start $CONFLUENT_HOME/etc/kafka/server-0.properties

$ kafka-server-start $CONFLUENT_HOME/etc/kafka/server-1.properties

$ kafka-server-start $CONFLUENT_HOME/etc/kafka/server-2.properties

$ kafka-server-start $CONFLUENT_HOME/etc/kafka/server-3.properties


# Open another terminal with 5 tabs
$ kafka-rest-start $CONFLUENT_HOME/etc/kafka-rest/kafka-rest.properties

$ connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed.properties

$ ksql-server-start $CONFLUENT_HOME/etc/ksqldb/ksql-server.properties

$ schema-registry-start $CONFLUENT_HOME/etc/schema-registry/schema-registry.properties

$ control-center-start $CONFLUENT_HOME/etc/confluent-control-center/control-center.properties


------------------------------------------------------------

# Now go back to the browser and go to localhost:9021

# Click on "controlcenter.cluster" card
# Observe now we are having 4 brokers
# Click on "broker" card

# Scroll down to the end we can observe here we have 4 brokers and we can observe other
# information like throughput, latency...etc

# Click through to broker-1
# Lets click on any one of the brokers as broker.0 we can see indepth information on that
# particular broker.0 

# Now click on "Configuration" we can remove the broker from here
# we can click on "Listener", "Logs" and show overrides


------------------------------------------------------------

# Go to Topics on the left navigation pane
# Create a new topic
# topic name ->  "user_signups"
# number of partitions -> 5

# Click "customize settings"
# Click "custom"

# replication factor -> 3
# min insync replicas -> 2


# click "Save and create"

# Click on "topic" from the left pane

# Show the "user_signups" topic on this page

# Scroll down we can see all the partitions and their leaders and their followers and other details


------------------------------------------------------------

# Open up the following files in Sublimetext and show the code

fakeProfileProducer.py
fakeProfileConsumerA.py
fakeProfileConsumerB.py
fakeProfileConsumerC.py


# Open a terminal with 4 tabs
$ python fakeProfileProducer.py

$ python fakeProfileConsumerA.py

$ python fakeProfileConsumerB.py

$ python fakeProfileConsumerC.py


# IMPORTANT: Let things run for 2-3 minutes

------------------------------------------------------------
Brokers page


# In control center go to broker from the left pane

# Click on Production

# Make sure we are seeing the metrics in 30 min timeframe

# Observe here we will get full information of production,
# consumption, latency, disk .... of each broker when we hover mouse of the graph


# If we want we can see metrics of each broker if we scroll up we can click on
# "Filter brokers" and select the only broker we want to see lets click broker 0 and 1

# Now go back to the filter option and select all again

# Now in "Request latency" under production or consumption we can see the request latency
# for 95th, 99th, 99.9th percentile and also the median we can choose that using the drop
# down.
#
# Now click on the "Request latency" graph of either the production or consumption
# we will get a "Production/Consumption request latency"
# page popup here we can see more information using the diagram

# https://docs.confluent.io/platform/current/control-center/topics/overview.html

------------------------------------------------------------
Topics page

# Now goto topic from the left pane -> "user_signups" -> click "production"

# Go to Consumption and show
# Go to Avaliability and show
# there are 0 under replication partitions and 0 under min in-sync replicas this is important

# Go to Consumer Lag and show

# Now go back to "topics" overview of "user_signups" and scroll down to looks at all the partitions
# and their replica placement

# https://www.cloudkarafka.com/blog/what-does-in-sync-in-apache-kafka-really-mean.html
# https://sagarkudu.medium.com/how-kafka-handles-data-loss-replication-and-in-sync-replica-isr-9d72d0134234

# Open a terminal in full screen

$ kafka-topics --describe \
--topic user_signups \
--bootstrap-server localhost:9092
# Topic: user_signup	Partition: 0	Leader: 0	Replicas: 0,2,3	Isr: 0,2,3	Offline:
# Topic: user_signup	Partition: 1	Leader: 2	Replicas: 2,3,1	Isr: 2,3,1	Offline:
# Topic: user_signup	Partition: 2	Leader: 3	Replicas: 3,1,0	Isr: 3,1,0	Offline:
# Topic: user_signup	Partition: 3	Leader: 1	Replicas: 1,0,2	Isr: 1,0,2	Offline:
# Topic: user_signup	Partition: 4	Leader: 0	Replicas: 0,3,1	Isr: 0,3,1	Offline:


------------------------------------------------------------
Killing brokers

# Kill broker.0
# Now lets say a broker failed say broker.0 lets go to the terminal where broker.0 is running
# and click "control+c" to showcase broker failure and wait for the broker.0 to stop

# Go immediately to Brokers and show that broker.0 will show in red (if you take more than a few minutes the broker will disappear)

# Click on Production and show that the first brokers lines are dipping towards 0

# Now go back to "topics" overview of "user_signup" and scroll down to looks at all the partitions
# and their replica placement

# The leader replicas are all running brokers - but some of the followes may be on broker 0

# Observe a bit above in "avaliability" we can see there was a spike in "under replicated partitions" and  
# "out of sync followers" it may be back to 0 or it may still be red

# on "avaliability" card we can get more info on this using the graph.

# In terminal (note we have to bootstrap to 9093)

$ kafka-topics --describe \
--topic user_signup \
--bootstrap-server localhost:9093


# Topic: user_signup	Partition: 0	Leader: 0	Replicas: 0,2,3	Isr: 0,3	Offline: 2
# Topic: user_signup	Partition: 1	Leader: 3	Replicas: 2,3,1	Isr: 3,1	Offline: 2
# Topic: user_signup	Partition: 2	Leader: 3	Replicas: 3,1,0	Isr: 3,1,0	Offline:
# Topic: user_signup	Partition: 3	Leader: 1	Replicas: 1,0,2	Isr: 1,0	Offline: 2
# Topic: user_signup	Partition: 4	Leader: 0	Replicas: 0,3,1	Isr: 0,3,1	Offline:

# Observe here we can see broker.2 is offline in certain partitions
# and also observe there is now only 2 in sync replicas in certain partitions where broker.0
# was present as replicas

# Also observe here new leaders are elected for the partitions as well

# Since now we have only 2 isr and 3 replicas this means the quarom is unhealthy and the missing replica
# has to be replaced

# In the browser if we go back to "localhost:9021" we can see the cluster is unhealthy

-----------------------------------------------------------------
Killing another broker

# Kill broker.3

# Now lets say we crash another broker say broker.3 go to the terminal where we have broker.3 running
# and click control+c

# In terminal (we're now using another bootstrap server)

$ kafka-topics --describe \
--topic user_signup \
--bootstrap-server localhost:9094

# Topic: user_signup	Partition: 0	Leader: 0	Replicas: 0,2,3	Isr: 3,0	Offline: 2
# Topic: user_signup	Partition: 1	Leader: 3	Replicas: 2,3,1	Isr: 3	Offline: 2,1
# Topic: user_signup	Partition: 2	Leader: 3	Replicas: 3,1,0	Isr: 3,0	Offline: 1
# Topic: user_signup	Partition: 3	Leader: 0	Replicas: 1,0,2	Isr: 0	Offline: 1,2
# Topic: user_signup	Partition: 4	Leader: 0	Replicas: 0,3,1	Isr: 3,0	Offline: 1


# Go to the Brokers page and show one more broker lost

# Go to Topics you will see warnings on the main page for user_signups

# Click through user_signups and go to the bottom and show partitions and replica placement


# Now lets go back to the terminal where broker 0 and 3 where running and restart them
$ kafka-server-start $CONFLUENT_HOME/etc/kafka/server-0.properties

$ kafka-server-start $CONFLUENT_HOME/etc/kafka/server-3.properties

# Now in terminal type below

$ kafka-topics --describe \
--topic user_signup \
--bootstrap-server localhost:9092
# Topic: user_signup	Partition: 0	Leader: 0	Replicas: 0,2,3	Isr: 0,3,2	Offline:
# Topic: user_signup	Partition: 1	Leader: 2	Replicas: 2,3,1	Isr: 1,3,2	Offline:
# Topic: user_signup	Partition: 2	Leader: 3	Replicas: 3,1,0	Isr: 0,3,1	Offline:
# Topic: user_signup	Partition: 3	Leader: 1	Replicas: 1,0,2	Isr: 0,1,2	Offline:
# Topic: user_signup	Partition: 4	Leader: 0	Replicas: 0,3,1	Isr: 0,3,1	Offline:

# In the Control Center go to Brokers and at the bottom show 4 brokers are online

# Go to the Topics and show user_signups shows Healthy again

# Show the terminals with producers and consumers, they would have started moving again

# In the browser if we go back to "localhost:9021" we can see the cluster is now healthy (this takes a long time 5=-7 minutes)

# Leave the producers and consumers running















