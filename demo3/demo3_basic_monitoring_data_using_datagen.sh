# Links used in this demo
# https://docs.confluent.io/platform/current/platform-quickstart.html


# Open terminal


$ kafka-topics --list \
--bootstrap-server localhost:9092

# Observe here we are getting lots of topic the point to note here is all 
# of these topics are internal topics created by kafka


$ kafka-topics --create \
--topic first_topic \
--bootstrap-server localhost:9092 \
--partitions 1 \
--replication-factor 1


# Set up two terminal windows side-by-side

# Left hand side

kafka-console-producer --topic first_topic \
--bootstrap-server localhost:9092


# Right hand side

kafka-console-consumer --topic first_topic \
--bootstrap-server localhost:9092


# Send these messages on the producer

This is the first message
Here is the second message
One more - message number three


# Wait for 1 minute and then send 3 more messages

Message 4
Message 5
Message 6


# Show that these messages are received on the consumer

--------------------------------------------------------------------------

# Go to the Control Center

# Click on "Cluster overview"

# Click on "Brokers"

# Click on "Topics"

# Notice that first_topic is present here (scroll horizontally and show when it was created)

# Click through and show details

# Click on "Production" and show the graph

# Click on "Consumption" and show the graph

---------------------------------------------------------------------------


# Go to control center -> Topics

# Click on "Add a topic"



# Topic Name -> random_topic
# Number of Partitions -> 1

# Click on "Customize Settings" and show the settings -> go back without changing anything

# Click "Create with defaults"


# Click on the "topic" subtopic again we can see "random_topic" being added here

# Click on "random_topic"

# Click through "Messages", "Schema", "Configuration"
# In "Configuration"

# Under configuration click on "Show full config"
# Show the configuration and then click on "Hide full config"

# Click on "Edit settings" -> Show the settings

# Click on "Expert mode" and scroll and show all the settings

# Cancel out

# Go back to "Messages" observe here there are no messages here


# Click "Produce a new message to this topic" a random message will be generated
# in my case the below

{
	"ordertime": 1497014222380,
	"orderid": 18,
	"itemid": "Item_184",
	"address": {
		"city": "Mountain View",
		"state": "CA",
		"zipcode": 94041
	}
}


# Click "Produce"
# Now scroll down and observe the new message is produced



# Goto terminal

$ kafka-topics.sh --describe --topic "random_topic" \
--bootstrap-server localhost:9092

# Just to double check if the topic is present



$ kafka-console-consumer --topic random_topic \
--bootstrap-server localhost:9092 \
--from-beginning

# This will retrive the messages produced from the begining


# Go back to browser and click "Producer" 3 more times 

{
	"ordertime": 1997014222344,
	"orderid": 19,
	"itemid": "Item_185",
	"address": {
		"city": "Montgomery",
		"state": "AL",
		"zipcode": 35004
	}
}

{
	"ordertime": 1935014222355,
	"orderid": 20,
	"itemid": "Item_186",
	"address": {
		"city": "Atlanta",
		"state": "GA",
		"zipcode": 30002
	}
}

{
	"ordertime": 1497888222000,
	"orderid": 21,
	"itemid": "Item_187",
	"address": {
		"city": "Topeka",
		"state": "KS",
		"zipcode": 66002
	}
}


# Go back to the terminal and see the messages being received

# Goto to terminal and press "control+c" to stop the consumer

# Now go to "Configuration" and click "Delete topic"
# enter topic name and click "Delete"



--------------------------------------------------------------


# Now let's learn to create fake data using Datagen Connector
# Now create a new topic called "stock_market_data"


# Now goto Connect from the left pane
# Click "connect-default"
# Click "Add connector"
# Click "DatagenConnector"



Name -> datagen_stock_data
Key converter class -> org.apache.kafka.connect.storage.StringConverter
kafka.topic -> stock_market_data
quickstart -> stock_trades


# Click "Next" -> "Launch"


# The below is some of the inbuild quickstart modules


# clickstream_codes,clickstream,clickstream_users,orders,ratings,users,
# users_,pageviews,stock_trades,inventory,product,purchases,transactions,
# stores,credit_cards,campaign_finance,fleet_mgmt_description,
# fleet_mgmt_location,fleet_mgmt_sensors,pizza_orders,pizza_orders_completed,
# pizza_orders_cancelled,insurance_offers,insurance_customers,
# insurance_customer_activity,gaming_games,gaming_players,
# gaming_player_activity,payroll_employee,payroll_employee_location,
# payroll_bonus,syslog_logs,device_information,siem_logs,shoes,shoe_customers,
# shoe_orders,shoe_clickstream


# Give it a few seconds to run

# Let it run for 5-7 minutes so the graphs have more data to show

# Next goto "topics" from the left pane
# Click on "stock_market_data"
# Click on "Production" tile and change the time to "30 minutes" and click "Apply"

# Now we can see the throughtput of the producer now if we go to consumer side
# we see there is no consumption happening


# go back to "topics" -> "stock_market_data" -> "messages"
# we can see new messages being create every 500ms


# Now click "schema" to looks at the schema of the messages by default 
# the message is produced in Avro format


-----------------------------------------------------------------------------

# Open a terminal

$ kafka-avro-console-consumer --topic stock_market_data \
--bootstrap-server localhost:9092

# Now we get the output in proper format

# Run the consumer for 2-3 minutes


# Back to Control Center

# Click on Topics -> stock_market_data


# There will be a consumption graph - click and show


# Click on consumers from the left-hand pane


# Click on the console-consumer


# Show that the consumer lag is 0 messages behind (the console consumer does not have the interceptors to actually show this information)


-----------------------------------------------------------------------------

# Back to the terminal window

# Kill the running consumer

# Restart it to read from the beginning


$ kafka-avro-console-consumer --topic stock_market_data \
--from-beginning \
--bootstrap-server localhost:9092


# Go to Control Center

# Click on Topics -> stock_market_data

# Click on Production and show that the producers have been producing at a steady rate

# Click on Consumption and show that there is a spike in the consumption throughput as it catches up to old messages
























