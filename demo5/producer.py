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
            partition=randint(0, 11), 
            callback = on_delivery
        )
        
        producer.flush()  

        time.sleep(randint(1, 4))
