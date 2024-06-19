#!/usr/bin/env python3
## Shows basic stats from OBD-II Serial reader

import obd
import time
import os

DELAY = 1.2;    # Delay in seconds between refreshing

def clearScreen():
    # Clear the terminal screen
    if os.uname().sysname == "Darwin":
        os.system('clear')
    elif os.name == 'posix':
        os.system('clear')
    elif os.name == 'nt':
        os.system('cls')


def readOBDdata(connection):
    data = []
    data.append(f"Engine RPM:   \t{connection.query(obd.commands.RPM).value}")          # Read engine RPM
    data.append(f"Vehicle Speed:\t{connection.query(obd.commands.SPEED).value}")        # Read vehicle speed
    data.append(f"Coolant Temp: \t{connection.query(obd.commands.COOLANT_TEMP).value}") # Read coolant temperature
    return data


def main():
    # Connect to the OBD-II adapter
    connection = obd.OBD()

    if connection.is_connected():
        while True:
            clearScreen()

            # Read OBD data
            data = readOBDdata(connection)

            # Print the OBD data
            for item in data:
                print(item)

            # Refresh periocally
            time.sleep(DELAY)
    else:
        print("Failed to connect to the OBD-II adapter.")


#- main()
if __name__ == "__main__":
    main()