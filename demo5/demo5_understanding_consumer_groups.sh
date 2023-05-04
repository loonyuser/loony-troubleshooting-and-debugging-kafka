# Click on the topic subtopic in the control center
# Click on "Add a topic"

# Topic Name -> customer_payments
# Number of Partitions -> 1

# Click on "Customize settings"
# Look at all the default parameters
# Under availability click "custom available settings"
# and make replication_factor -> 1 and min_insync_replica -> 1

# At the bottom click "Manually configure other topic configuration options"
# Look at all the default parameters

# Untick "Manually configure other topic configuration options"

# Click "Save & create"

# Open a terminal
# Listing the topics within the server
$ kafka-topics --list \
--bootstrap-server localhost:9092
# Observe we can find customer_payments topic

# Describes the topic in this case the topic name is
# customer_payments
$ kafka-topics --describe \
--topic customer_payments \
--bootstrap-server localhost:9092


---------------------------------------------------------------------


# In terminal
$ pip install confluent-kafka

$ pip install Faker
# This is used for generating fake data


# Open up producer.py in Sublimetext


#### producer.py

from confluent_kafka import Producer
from faker import Faker

import json
import time

from random import randint


fake = Faker()

producer = Producer({'bootstrap.servers': 'localhost:9092'})

def on_delivery(err, msg):
    if err:
        print('Error: {}'.format(err))
    else:
        message = '{}'.format(msg.value().decode('utf-8'))
        print(message)

def get_payment_details():
    return {
        "customer_name": fake.name(),
        "bank_name": fake.credit_card_provider(),
        "credit_card_number": fake.credit_card_number(),
        "cc_expire_date": fake.credit_card_expire(),
        "price": fake.pricetag(),
        "country": fake.country()
    }      

if __name__ == '__main__':
    while True:
        
        payment_data = get_payment_details()
        msg = json.dumps(payment_data)
        
        producer.poll(1)
        producer.produce(
            'customer_payments', 
            msg.encode('utf-8'), 
            partition = 0, 
            callback = on_delivery
        )
        
        producer.flush()  

        time.sleep(randint(1, 4))

# In terminal
$ python producer.py


# Goto control center under topics click customer_payments
# Wait for 3-4 minutes


# Click on "Messages" we can see the messages are being produced if we want we can pause and
# inspect the messages as we did i the previous demos
# We can observe all the messages fields of that topic

# Now go back to "Overview" section
# Observe now we can see the throughtput in the producer section
# but nothing in the consumer section

# Scroll to the bottom on the Overview page and show that there is just one partition
# and it is being used

# Click on the producer throughtput section to get different insights
# on the producer. Click on the date and set "last 30 min"

# Goto terminal and stop the producer.py by clicking control+c


-------------------------------------------------------------

# We are increasing the partition to 12 from 1

$ kafka-topics --bootstrap-server localhost:9092 \
--alter --topic customer_payments \
--partitions 12

$ kafka-topics --describe \
--topic customer_payments \
--bootstrap-server localhost:9092

# in producer.py change this one line of code
partition=randint(0, 2)

# Run in terminal
$ python producer.py


# Go to the Control Center -> Topics -> customer_payments
# Scroll down top partions section we can get an indepth look
# into all the partitions we can observe here that only first 3 partitons
# are being used

# Goto terminal and stop the producer.py by clicking control+c


-------------------------------------------------------------

# Change this one line of code
#### producer.py

# Change the input parameter to the produce() nethod

partition=randint(0, 11)


# In terminal
$ python producer.py

# Wait for 2-3 minutes

# Go to the Control Center -> Topics -> customer_payments
# Scroll down and show that all partitions are being used


# Let the producer continue running and producing

-------------------------------------------------------------

# Open consumerA.py in Sublimetext


from confluent_kafka import Consumer

consumer = Consumer({
    'bootstrap.servers':'localhost:9092',
    'group.id':' PaymentGroup',
    'auto.offset.reset':'earliest'})

consumer.subscribe(['customer_payments'])

if __name__ == '__main__':

    while True:

        msg = consumer.poll(1)

        if msg is None:
            continue
        elif msg.error():
            print('Error: {}'.format(msg.error()))
            continue
        else:
            data = msg.value().decode('utf-8')
            print(data)

    consumer.close() 


# Close the file

# IMPORTANT: Make sure that you have 2 terminals open side-by-side

# Producer on the left hand side and consumer on the right hand side


# On the right-hand side run

$ python consumerA.py


# Show the consumer consuming messages

# Let it run for 2-3 minutes


-------------------------------------------------------------

# Now switch to the control center

# Go to Topics -> customer_payments

# Go to Overview 

# Scroll down and show that all partitions are still getting messages

# Scroll back up and click on Consumption and show the graph


# Go to Consumers on the left hand pane -> Click on PaymentGroup

# Show the "Consumer Lag" page

# Stay on this page for some time till you can see the little dots moving around as the single consumer catches up with all partitions


# Hover over the dots (hover over lagging dots and caught up dots) and show tooltip

# Show that for the most part the consumer is keeping up with the producer


-------------------------------------------------------------

# Back to the Consumer terminal window

# Kill the consumer 

# Back to the control center and wait

# Show that the consumer starts falling behind on messages

# Wait till the dots are scattered a fair 

# Hover over the the dots at different locations and show that we are several messages behind on the different partitions and this is getting worse

# Scroll to the table below and show that for each partition we can see how many messages we are behind

# Back to the terminal and restart the Consumer

# Quickly switch back to the Control center and show that we are caught up on messages soon


# Click on the "Consumption" tab and show that we do not have any data here (Pythno client needs to be rebuilt from source to include Kerberos support to get additional interceptors to work - beyond the scope of this course)


-------------------------------------------------------------
Increasing consumers in a group from 1 to 3

# Kill the consumerA.py running earlier (behind the scenes)
# Kill the producer (behind the scenes)

# In sublimetext make sure all 3 files are open on the left pane

consumerA.py

consumerB.py

consumerC.py


# Show the code in all 3 files - they are exactly the same (as below)

rom confluent_kafka import Consumer

consumer = Consumer({
    'bootstrap.servers':'localhost:9092',
    'group.id':' PaymentGroup',
    'auto.offset.reset':'earliest'})

consumer.subscribe(['customer_payments'])

if __name__ == '__main__':

    msg_count = 0

    try:
        while True:

            msg = consumer.poll(1)

            if msg is None:
                continue
            elif msg.error():
                print('Error: {}'.format(msg.error()))
                continue
            else:
                data = msg.value().decode('utf-8')
                print(data)

                msg_count += 1
                if msg_count % 10 == 0:
                    consumer.commit(asynchronous=True)
    finally:           
        consumer.close() 


# Have the producer running on the left hand side

$ python producer.py


# Have 3 terminals on the right hand side, run the consumers there

# First run 2 consumers

$ python consumerA.py

$ python consumerB.py


# Switch to the Control Center

# Click on Consumers on the left-hand pane

# Observe that payment group has 2 consumers and 1 topic

# Click through to the PaymentGroup

# Now here if you however over the pins you will see that there are two different consumers


# IMPORTANT: In the table showing the partitions expand the "Consumer ID" column

# Show that each consumer has 6 partitions

-------------------------------------------------------------

# Back to the terminals start the 3rd consumer

$ python consumerC.py


# Switch to the Control Center -> PaymentGroup


# IMPORTANT: In the table showing the partitions expand the "Consumer ID" column

# Show that each consumer now has 4 partitions


# Back to a new terminal on full screen

$ kafka-consumer-groups --describe \
--group PaymentGroup \
--members --bootstrap-server localhost:9092


# GROUP           CONSUMER-ID                                             HOST            CLIENT-ID          #PARTITIONS
# PaymentGroup    kafka-python-2.0.2-6590998e-62c6-467b-92de-4e01085f9787 /192.168.0.162  kafka-python-2.0.2 4
# PaymentGroup    kafka-python-2.0.2-cb80fc57-7f3f-457b-a2f1-583d11ce82d2 /192.168.0.162  kafka-python-2.0.2 4
# PaymentGroup    kafka-python-2.0.2-1ad1e59e-412c-4983-b98b-9f8ad00adee6 /192.168.0.162  kafka-python-2.0.2 4

# Observe here each of the 3 consumer in the consumergroup is given 4 partitions each


# Now goto anyone of the consumer in terminal lets say consumerC.py and stop it using control+c
# wait a few seconds
# and run the below command

$ kafka-consumer-groups --describe \
--group PaymentGroup \
--members --bootstrap-server localhost:9092


# GROUP           CONSUMER-ID                                             HOST            CLIENT-ID          #PARTITIONS
# PaymentGroup    kafka-python-2.0.2-6590998e-62c6-467b-92de-4e01085f9787 /192.168.0.162  kafka-python-2.0.2 6
# PaymentGroup    kafka-python-2.0.2-cb80fc57-7f3f-457b-a2f1-583d11ce82d2 /192.168.0.162  kafka-python-2.0.2 6

# Observe here each of the 2 consumer in the consumergroup is given 6 partitions each



