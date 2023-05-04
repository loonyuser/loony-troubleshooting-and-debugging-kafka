# Here lets create see how we can identify slow consumers
# We will be working on the previous examples

# In a new terminal on full screen

$ kafka-consumer-groups --describe \
--group UserSignupGroup \
--members --bootstrap-server localhost:9092

# GROUP           CONSUMER-ID                                             HOST            CLIENT-ID          #PARTITIONS
# UserSignUpGroup kafka-python-2.0.2-c4551137-b3eb-45d7-ae23-dcc35e8f6b38 /127.0.0.1      kafka-python-2.0.2 2
# UserSignUpGroup kafka-python-2.0.2-f90a1aaa-f7ac-43da-a86c-fbf26b9bc649 /127.0.0.1      kafka-python-2.0.2 1
# UserSignUpGroup kafka-python-2.0.2-3b672f2b-c14e-483e-a72e-5cd06dfec4b9 /127.0.0.1      kafka-python-2.0.2 2

# We can see we have 3 consumers in the consumergroup UserSignUpGroup

# Go back to control center under "consumers" -> "UserSignupGroup" observe the CONSUMER-ID

# In my case it seems the first consumer is in partition 3 and 4
# In my case it seems the second consumer is in partition 1
# In my case it seems the third consumer is in partition 0 and 2

----------------------------------------------------------------------

# In terminal
# Goto the terminal where fakeProfileConsumerA.py is running and stop it using command+c

# Now lets intentionally make a consumer a slow consumer

# Open fakeProfileConsumerA.py on Sublimetext


# Just under while True add this line 

        while True:

            time.sleep(10)


# Here we are purposfully making the fakeProfileConsumerA slower by making it sleep for 10 seconds

$ python fakeProfileConsumerA.py

# Now go back to the browser and go to "consumer" from the left pane -> "UserSignupGroup"
# Now observe the pins which are having more lag in my case there are 2 such pins which have high latency that is consumerA, due to this we can also observe the max lag/consumer has also increased

# Wait for 3-4 minutes on the page


# Hover over the pins that have fallen behind and they will all belong to the same consumer



# if we scroll down to look at each partitions we can see more information as to how much backlog the messages are in each partitions


# Stop the producer and all 3 consumers before we go to the next demo


















