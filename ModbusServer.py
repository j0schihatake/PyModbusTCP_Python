#!/bin/python

from pyModbusTCP.server import ModbusServer, DataBank
from time import sleep
from random import uniform
import logging

debug: bool = False


def server_start():
    # init logging
    logging.basicConfig()

    if debug:
        logging.getLogger('pyModbusTCP.server').setLevel(logging.DEBUG)

    # Create an instance of ModbusServer
    server = ModbusServer("0.0.0.0", 502, no_block=True)

    print("Start server...")
    server.start()
    print("Server is online")

    try:
        state = [0]
        while True:
            #    DataBank.set_words(0, [int(uniform(0, 100))])
            #    if state != DataBank.get_words(1):
            #        state = DataBank.get_words(1)
            #        print("Value of Register 1 has changed to " + str(state))
            sleep(0.1)
    except:
        print("Shutdown server ...")
        server.stop()
        print("Server is offline")


# Entry point
if __name__ == '__main__':
    server_start()
