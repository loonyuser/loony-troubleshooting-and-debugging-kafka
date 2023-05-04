from confluent_kafka import Consumer

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