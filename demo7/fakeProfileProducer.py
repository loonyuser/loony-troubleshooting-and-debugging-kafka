from confluent_kafka import Producer
from faker import Faker

import json
import time

from random import randint

fake = Faker()

producer = Producer({
    'bootstrap.servers': 'localhost:9092, localhost:9093'
})

def on_delivery(err, msg):
    if err:
        print('Error: {}'.format(err))
    else:
        message = '{}'.format(msg.value().decode('utf-8'))
        print(message)

def get_profile_details():
    return fake.simple_profile()     

if __name__ == '__main__':

    while True:
        profile_data = get_profile_details()

        msg = json.dumps(profile_data, default=str)
        
        producer.poll(1)
        
        producer.produce(
            'user_signups', 
            msg.encode('utf-8'), 
            partition=randint(0, 4), 
            callback=on_delivery
        )

        producer.flush()

        time.sleep(randint(0, 3))
