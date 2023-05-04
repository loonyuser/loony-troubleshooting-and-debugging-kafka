# * The setup is same as demo7 and demo6 - 4 broker cluster *

# Make sure everything is healthy and no producers or consumers are running

----------------------------------------------------------------


# Click on the bell icon on the top right to configure alerts

#
# In the history we can see any actions that have been triggered
# and in the trigger section we can setup the trigger
# and in the action tab we can setup appropriate actions when
# the trigger is set off

Lets go to the trigger tab and click "Add trigger"

trigger name -> zookeeper_down
component type -> cluster
cluster id -> controlcenter.cluster

metric -> ZK Disconnected
condition -> yes

Click "Save"

# You will be prompted to create an action 

Click "Create an action"

action name -> ZKDown_admin_alert
triggers -> zookeeper_down

action -> send email # Show the drop down
subject -> URGENT ATTENTION NEEDED: Zookeeper is down
max send rate -> 1 per hour
recipient email address -> alice@loonycorn.com

Click "Save"

----------------------------------------------------------------

# Lets go to the terminal where zookeeper is running 

# Stop it using control+c now wait a few seconds

# Go to Alerts -> Overview -> History

#
# In another browser tab goto "http://localhost:9021/2.0/alerts/history"
# this will give an rest API representation of all the alert history we can implement this
# on to your own website or app

# [
# {
#   "guid": "843f44b3-df42-4940-995e-5a96166f8a56",
#   "timestamp": 1681745182474,
#   "monitoringTrigger": {
#     "guid": "b9b3bf81-e310-42c5-9fde-d96662d409ff",
#     "name": "zookeeper_down",
#     "clusterId": "default",
#     "condition": "EQUAL",
#     "lagMs": 60000,
#     "brokerClusters": {
#       "brokerClusters": [
#         "DWkPZS82RUqHbKrtzeU3Xw",
#         ...
#       ]
#     },
#     "brokerMetric": "ZK_STATUS",
#     "statusValue": "OFFLINE",
#     "longValue": null
#   },
#   "triggers": [
#     {
#       "longValue": null,
#       "window": 1681745100000,
#       "component": {
#         "brokerCluster": {
#           "clusterId": "DWkPZS82RUqHbKrtzeU3Xw",
#           "brokerId...
#         }
#       }
#     },
#     ...
#   ],
#   "actions": [
#     {
#       "guid": "0a5324ae-af6b-49f6-86b8-dd8b22576103",
#       "name": "ZKDown_admin_alert",
#       "email": {
#         "address": "cloud.user@loonycorn.com",
#         "subject": "Need Attention!!! Zookeeper is Down!"
#       }
#     },
#     ...
#   ]
# } 
# ...
# ]



# Make sure you restart zookeeper

-----------------------------------------------------------------------
STEPS FOR UNDER REPLICATION PARTITION

# Lets go to the trigger tab and click "Add trigger"

trigger name -> under_replication
component type -> cluster
cluster id -> controlcenter.cluster

metric -> under partition topic partition
condition -> greater than
value -> 0

Click "Save"

Click "Create an action"

action name -> under_replication_alert
triggers -> under_replication

action -> send email
subject -> ATTENTION NEEDED: One of your partitions is under replicating!
max send rate -> 1 per day
recipient email address -> alice@loonycorn.com

Click "Save"

# Goto the terminal 
# ctrl+c server 2 and 3. Wait a few minutes.
# go back to "localhost:9021"
# Observe "under partition topic partition 0 & 1"

> Goto "alert" > "history"
Observe it was triggered

> # In another browser tab goto "http://localhost:9021/2.0/alerts/history"

# {
# "guid": "a25e97a2-56b1-4e00-8fcd-e01edd28e316",
# "timestamp": "1681793804263",
# "monitoringTrigger": {
# "guid": "5b9e90ef-3cee-4e0b-add3-62dea199c341",
# "name": "under_replication",
# "clusterId": "default",
# "condition": "GREATER_THAN",
# "longValue": "0",
# "lagMs": "60000",
# "brokerClusters": {
# "brokerClusters": [
# "DWkPZS82RUqHbKrtzeU3Xw"
# ]
# },
# "brokerMetric": "UNDER_REPLICATED_TOPIC_PARTITIONS"
# },
# "triggers": [
# {
# "window": "1681793520000",
# "hasError": false,
# "component": {
# "brokerCluster": {
# "clusterId": "DWkPZS82RUqHbKrtzeU3Xw",
# "brokerId": ""
# }
# },
# "longValue": "9"
# },
# {
# "window": "1681793400000",
# "hasError": false,
# "component": {
# "brokerCluster": {
# "clusterId": "DWkPZS82RUqHbKrtzeU3Xw",
# "brokerId": ""
# }
# },
# "longValue": "4"
# },
# {
# "window": "1681793460000",
# "hasError": false,
# "component": {
# "brokerCluster": {
# "clusterId": "DWkPZS82RUqHbKrtzeU3Xw",
# "brokerId": ""
# }
# },
# "longValue": "8"
# }
# ],
# "actions": [
# {
# "guid": "70d04fc0-dacf-44aa-8ca7-3fe3b3eb0cc7",
# "name": "under_replication_alert",
# "email": {
# "address": "nishanloonycorn@gmail.com",
# "subject": "Need Attention!!!One of your partition is under replicating!"
# }
# }
# ]
# }


# > restart server 2 and 3. Wait a few minutes.

-----------------------------------------------------------

# https://docs.confluent.io/platform/current/control-center/alerts/configure.html#configure-smtp-email

# Now lets go to our email and check of the email we see that the email is not sent yet we have to set some configuration in the control-center.properties


# To setup SMTP server in gmail
# https://www.gmass.co/blog/gmail-smtp/

# (note: for this to work we should make sure that 2FA is enabled in that google account)
# Go to your google account and click "security" and click "app password"
# Click "select app" -> "mail"
# select device -> mac
# click "generate"

# Open a terminal
$ cd $CONFLUENT_HOME/etc/confluent-control-center/

# Open control-center.properties in sublime text

# Add the below lines of code
confluent.controlcenter.mail.enabled=true
confluent.controlcenter.mail.host.name=smtp.gmail.com
confluent.controlcenter.mail.port=587
confluent.controlcenter.mail.ssl.port=465
confluent.controlcenter.mail.from=cloud.user@loonycorn.com
confluent.controlcenter.mail.username=cloud.user@loonycorn.com
confluent.controlcenter.mail.password=16_DIGIT_PASSWORD
confluent.controlcenter.mail.starttls.required=true

# Now goto the terminal running the control center and stop and restart it


------------------------------------------------
Kill zookeeper

# Now stop the zookeeper and wait a few seconds 

# we can now see the email is been sent to our email (if not found see in spam)


------------------------------------------------
Kill brokers for under replication

# Goto the terminal 
# ctrl+c server 2 and 3. Wait a few minutes.
# go back to "localhost:9021"
# Observe "under partition topic partition 0 & 1"

# we can now see the email is been sent to our email (if not found see in spam)
