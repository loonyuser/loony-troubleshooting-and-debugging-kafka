# Here we are using kafka 3.3.1 

# Since we have already installed confluent platform in before video if not
# follow the below step


----------------------------------------------------------------------------

# Show the prerequisites to work with Confluent (scroll and show the whole page)

https://docs.confluent.io/platform/current/installation/versions-interoperability.html

# Go to 

https://www.confluent.io/get-started/

# Click on the Software tab (ignore the Cloud tab)
# Give your mail details and navigate to the Local editions of Confluent
# Download one of the versions (assuming it's the zip version below)
# Once it is downloaded unzip it and move it to home/tools folder

# Make sure we are running java-11 in the system

# In terminal
$ java -version

# openjdk version "11.0.16.1" 2022-08-12
# OpenJDK Runtime Environment Homebrew (build 11.0.16.1+0)
# OpenJDK 64-Bit Server VM Homebrew (build 11.0.16.1+0, mixed mode)



# Open bash profile
$ nano ~/.bash_profile


# Add the below code
export CONFLUENT_HOME="$HOME/tools/confluent-7.3.3"
export PATH="$CONFLUENT_HOME/bin:$PATH"


# Save and exit
$ source ~/.bash_profile



# Let's install the kafka connect datagen
# kafka connect datagen connector generates mock data


# Run the command on the terminal
$CONFLUENT_HOME/bin/confluent-hub install \
--no-prompt confluentinc/kafka-connect-datagen:latest



# It shows Completed
# Run confluent local to get the commands

$ confluent version

$ confluent local

$ confluent local current

$ confluent local services

$ confluent local services start

# Starting ZooKeeper
# ZooKeeper is [UP]
# Starting Kafka
# Kafka is [UP]
# Starting Schema Registry
# Schema Registry is [UP]
# Starting Kafka REST
# Kafka REST is [UP]
# Starting Connect
# Connect is [UP]
# Starting ksqlDB Server
# ksqlDB Server is [UP]
# Starting Control Center
# Control Center is [UP]



$ confluent local services control-center top
# Here we can get all the resource used by control center
# Press q to exit of the logs


$ confluent local services control-center log
# We can get all the logs from the control-center
# Press ctrl+c to exit of the logs


## From the shell navigate to the directory containing the Confluent Control Center configs
cd $CONFLUENT_HOME/etc/confluent-control-center


## Take a look at the control-center.properties file
nano control-center.properties


# Press Ctrl + X to exit

