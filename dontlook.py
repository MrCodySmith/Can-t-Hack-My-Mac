import os
import logging
import sys

def main():

    os.system('echo "Hello There!"')
    logging.basicConfig(filename='testlog.log', format='%(asctime)s:%(levelname)s:%(message)s', level=logging.DEBUG, filemode='w')
    logging.debug("Starting...")
    os.system('system_profiler SPHardwareDataType')
    logging.debug("Done!")


if __name__ == '__main__':
    main()
