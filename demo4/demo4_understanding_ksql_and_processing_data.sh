
--------------------------------------------------------------

# Add a second datagen connector

# Click "connect-default"
# Click "Add connector"
# Click "DatagenConnector"


Name -> datagen_user_data
Key converter class -> org.apache.kafka.connect.storage.StringConverter
kafka.topic -> users_data # (create it here)
quickstart -> users


# Go to Topics and make sure that both topics have been created and are healthy


----------------------------------------------------------


# Now click on "ksql" on the left pane

# Now click "ksqlDB" we can see there is one registered stream
# called "KSQL_PROCESSING_LOG" this is an internal stream created by kafka


# Now using ksql we can create either a stream or a table the difference 
# is given below


# A stream is a an immutable, append-only collection that represents a series 
# of historical facts, or events. Once a row is inserted into a stream, the row 
# can never change. You can append new rows at the end of the stream, but you 
# can’t update or delete existing rows.


# A table is a mutable collection that models change over time. It uses row 
# keys to display the most recent data for each key. All but the newest rows 
# for each key are deleted periodically. Also, each row has a timestamp, so you 
# can define a windowed table which enables controlling how to group records 
# that have the same key for stateful operations – like aggregations and joins 
# – into time spans. Windows are tracked by record key.



# We can see an editor of KSQL being presented paste the below code and run the query



CREATE OR REPLACE STREAM stock_data_stream
WITH (KAFKA_TOPIC='stock_market_data', VALUE_FORMAT='AVRO');


# We get the below output with "status": "SUCCESS"

# {
#   "@type": "currentStatus",
#   "statementText": "CREATE OR REPLACE STREAM STOCK_DATA_STREAM (SIDE STRING, QUANTITY INTEGER, SYMBOL STRING, PRICE INTEGER, ACCOUNT STRING, USERID STRING) WITH (KAFKA_TOPIC='stock_market_data', KEY_FORMAT='KAFKA', VALUE_FORMAT='AVRO');",
#   "commandId": "stream/`STOCK_DATA_STREAM`/create",
#   "commandStatus": {
#     "status": "SUCCESS",
#     "message": "Stream created",
#     "queryId": null
#   },
#   "commandSequenceNumber": 8,
#   "warnings": [

#   ]
# }


# Observe towards the right "STOCK_DATA_STREAM" stream is created 

# Click on it we can observe all the different columns of that stream


# Now paste the below code and run the query

SELECT * FROM stock_data_stream EMIT CHANGES;


# Now all the messages that are produced from the topic stock_market_data
# are being displayed here
# 'EMIT CHANGES' indicates that a query is continuous and outputs all changes.


# Note: We can change the auto.offset.reset to either latest or earliest
# we will keep it to latest here


# We can click on the drop down of each of the messages to get a sense of
# it in the JSON format


# Also we can click on the "table" view on the top right near the messages
# to look at the messages in table format. 

# Pause and play the messages

# Now click on "Flow" we can see here we have STOCK_DATA_STREAM and KSQL_PROCESSING_LOG

# Click on STOCK_DATA_STREAM and show the same stream

# Now click "Streams" we can see details on the streams click on STOCK_DATA_STREAM

# we can see more information of STOCK_DATA_STREAM stream here we can drop the stream or even inspect the processing log and also query the stream

# also click on "Tables" right now we have no tables and click on
# "Persistant queries" and "Settings"

-------------------------------------------------------------------------


CREATE OR REPLACE TABLE users_table (id VARCHAR PRIMARY KEY)
WITH (KAFKA_TOPIC='users_data', VALUE_FORMAT='AVRO');

# This will create a new table called users_table
# Observe towards the right "USERS_TABLE" table is created click
# on it we can observe all the different columns of that stream
# OUTPUT
# {
#   "@type": "currentStatus",
#   "statementText": "CREATE OR REPLACE TABLE USERS_TABLE (ID STRING PRIMARY KEY, REGISTERTIME BIGINT, USERID STRING, REGIONID STRING, GENDER STRING) WITH (KAFKA_TOPIC='users_data', KEY_FORMAT='KAFKA', VALUE_FORMAT='AVRO');",
#   "commandId": "table/`USERS_TABLE`/create",
#   "commandStatus": {
#     "status": "SUCCESS",
#     "message": "Table created",
#     "queryId": null
#   },
#   "commandSequenceNumber": 6,
#   "warnings": [

#   ]
# }



# Now paste the below code and run the query

SELECT * FROM users_table EMIT CHANGES;


# Now all the messages that are produced from the topic users_data
# are being displayed here


# Now click on "Flow" we can see here we have STOCK_DATA_STREAM, USERS_TABLE and KSQL_PROCESSING_LOG
# Now click "Tables" we can see details on the tables click on USERS_TABLE
# we can see more information of USERS_TABLE table here we can drop the table
# or even inspect the processing log and also query the table


-------------------------------------------------------------------------


# Go back to the "Editor"

SELECT 
	* 
FROM stock_data_stream 
WHERE 
	SIDE='BUY' AND QUANTITY>1500 AND SYMBOL='ZVV'
LIMIT 5;

# Here we are running some basic queries here we are list 5 messages
# where the person buys more than 1500 shares of ZVV 



SELECT 
	SYMBOL, 
	QUANTITY, 
	PRICE, 
	QUANTITY*PRICE AS TOTAL_COST
FROM stock_data_stream
LIMIT 10;

# Here we are running a query where we are just calculating the total cost
# per user



CREATE OR REPLACE STREAM user_stock_purchases
AS SELECT 
	users_table.id AS USERID, GENDER, REGIONID, SIDE, 
	SYMBOL, PRICE, QUANTITY, PRICE*QUANTITY AS TOTAL_COST
FROM 
stock_data_stream LEFT JOIN users_table 
ON stock_data_stream.USERID = users_table.ID
EMIT CHANGES;


# We are getting the below result
# OUTPUT
# {
#   "@type": "currentStatus",
#   "statementText": "CREATE STREAM USER_STOCK_PURCHASES WITH (KAFKA_TOPIC='USER_STOCK_PURCHASES', PARTITIONS=1, REPLICAS=1) AS SELECT\n  USERS_TABLE.ID USERID,\n  STOCK_DATA_STREAM.SIDE SIDE,\n  STOCK_DATA_STREAM.QUANTITY QUANTITY,\n  STOCK_DATA_STREAM.SYMBOL SYMBOL,\n  STOCK_DATA_STREAM.PRICE PRICE,\n  STOCK_DATA_STREAM.ACCOUNT ACCOUNT\nFROM STOCK_DATA_STREAM STOCK_DATA_STREAM\nLEFT OUTER JOIN USERS_TABLE USERS_TABLE ON ((STOCK_DATA_STREAM.USERID = USERS_TABLE.ID))\nEMIT CHANGES;",
#   "commandId": "stream/`USER_STOCK_PURCHASES`/create",
#   "commandStatus": {
#     "status": "SUCCESS",
#     "message": "Created query with ID CSAS_USER_STOCK_PURCHASES_7",
#     "queryId": "CSAS_USER_STOCK_PURCHASES_7"
#   },
#   "commandSequenceNumber": 8,
#   "warnings": [

#   ]
# }


SELECT * FROM user_stock_purchases EMIT CHANGES;

# If the messages are going very fast we can pause the stream and then
# We can click on the drop down of each of the messages to get a sense of
# it in the JSON format
# {
#   "USERID": "User_9",
#   "GENDER": "OTHER",
#   "REGIONID": "Region_9",
#   "SIDE": "SELL",
#   "SYMBOL": "ZXZZT",
#   "ACCOUNT": "LMN456",
#   "PRICE": 285,
#   "QUANTITY": 4813,
#   "TOTAL_COST": 1371705
# }


-------------------------------------------------------------------------



# https://docs.confluent.io/platform/current/streams/developer-guide/dsl-api.html#tumbling-time-windows


CREATE OR REPLACE TABLE symbol_1_min_aggregates 
WITH (KEY_FORMAT='JSON')
AS 
SELECT SYMBOL, AVG(PRICE) AS avg_price, AVG(QUANTITY) AS avg_quantity
FROM stock_data_stream
WINDOW TUMBLING (SIZE 60 SECOND)
GROUP BY SYMBOL
EMIT CHANGES;



# In the editor

SELECT * FROM symbol_1_min_aggregates EMIT CHANGES;

# Here we are creating a table called avg_value_symbol where the average price and average quantity 
# of each symbol will be calculated in a tumbling window of 60 seconds

# IMPORTANT: Click on the table format and show the table


-------------------------------------------------------------------------


list streams;
# This will list all the streams

list tables;
# This will list all the tables


# Now click on "Flow" and visualize the pipeline that we have created 
# We can observe here we are creating a stream called user_stock_purchases using data from both
# users_table and stock_data_stream
# Also we can see we have created a table called avg_value_symbol by filtering the stream called 
# stock_data_stream


# Now click on "Presistent queries" here we can observe all the persistant runnign queries
# here we can observe there are 2 queries running one is the window tumbling and another
# is CSAS_USER_STOCK_PURCHASES_7 we can observe more information on each queries 
# like the message per second and total messages processed we can also delete the 
# queries by clicking on the "Terminate" button

# Now go back to "Cluster overview" here we can see we have 2 running "connect" and 2 running
# "Persistant queries"











