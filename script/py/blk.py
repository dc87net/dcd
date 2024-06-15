#!/usr/bin/env python3
##TODO: Laying the foundation for something cool!

import os
import subprocess, struct
import time

from colors import log
import colors


SECTOR_SIZE = 512
FAT_ENTRY_SIZE = 4  # Assuming FAT32-like entries
DIR_ENTRY_SIZE = 32  # Simplified directory entry size

class DirectoryEntry:
    def __init__(self, name, startCluster, size):
        self.name = name
        self.startCluster = startCluster
        self.size = size

    def serialize(self):
        name = self.name.ljust(11, '\0').encode('utf-8')
        startCluster = struct.pack('<I', self.startCluster)
        size = struct.pack('<I', self.size)
        return name + startCluster + size

    @staticmethod
    def deserialize(data):
        name = data[:11].rstrip(b'\0').decode('utf-8')
        startCluster = struct.unpack('<I', data[11:15])[0]
        size = struct.unpack('<I', data[15:19])[0]
        return DirectoryEntry(name, startCluster, size)


""""""
class RawBlockDevice:
    def __init__(self, sizeInMb, storagePath):
        self.devicePath = self.createRamDisk(sizeInMb)
        self.storagePath = storagePath
        self.initializeDevice(sizeInMb)
        self.fat = [0xFFFFFFF8] * (sizeInMb * 1024 * 1024 // SECTOR_SIZE)
        self.rootDirectory = []

    def __del__(self):
        self.destroyRamDisk()

    def createRamDisk(self, sizeInMb):
        sizeInSectors = sizeInMb * 2048  # 1 sector = 512 bytes
        command = f"hdiutil attach -nomount ram://{sizeInSectors}"
        result = subprocess.run(command, shell=True, capture_output=True, text=True)

        if result.returncode != 0:
            raise Exception("Failed to create RAM disk")

        devicePath = result.stdout.strip()
        return devicePath

    def initializeDevice(self, sizeInMb):
        totalSize = sizeInMb * 1024 * 1024
        with open(self.devicePath, 'wb') as device:
            device.write(bytearray([0xFF] * totalSize))
        os.makedirs(self.storagePath, exist_ok=True)

    def destroyRamDisk(self):
        if self.devicePath:
            command = f"hdiutil detach {self.devicePath}"
            subprocess.run(command, shell=True)

    def readBlock(self, blockAddress):
        return self.read(blockAddress, SECTOR_SIZE)  # Assuming block size is 512 bytes

    def read(self, baseAddress, length):
        with open(self.devicePath, 'rb') as device:
            device.seek(baseAddress)
            data = device.read(length)
            if not data or all(b == 0xFF for b in data):
                return ""  # Uninitialized memory
            data = data.split(b'\0', 1)[0]  # Keep data before the first null byte
        return data.decode('utf-8', errors='ignore')

    def write(self, data, baseAddress):
        with open(self.devicePath, 'wb') as device:
            device.seek(baseAddress)
            bytesWritten = device.write(data.encode('utf-8') + b'\0')
        return bytesWritten

    def createFile(self, name, data):
        startCluster = self.findFreeCluster()
        if startCluster is None:
            raise Exception("No free cluster available")

        filePath = os.path.join(self.storagePath, f"{startCluster}.dat")
        with open(filePath, 'wb') as file:
            file.write(data.encode('utf-8'))

        size = len(data)
        self.rootDirectory.append(DirectoryEntry(name, startCluster, size))
        self.updateFat(startCluster, size)

    def findFreeCluster(self):
        for i, entry in enumerate(self.fat):
            if entry == 0xFFFFFFF8:
                return i
        return None

    def updateFat(self, startCluster, size):
        clustersNeeded = (size + SECTOR_SIZE - 1) // SECTOR_SIZE
        for i in range(clustersNeeded):
            self.fat[startCluster + i] = startCluster + i + 1
        self.fat[startCluster + clustersNeeded - 1] = 0xFFFFFFFF  # End of file

    def readFile(self, name):
        for entry in self.rootDirectory:
            if entry.name == name:
                filePath = os.path.join(self.storagePath, f"{entry.startCluster}.dat")
                with open(filePath, 'rb') as file:
                    return file.read().decode('utf-8')
        raise Exception("File not found")

    def listFiles(self):
        return [entry.name for entry in self.rootDirectory]


def main():
    try:
        log("BEGIN")
        storagePath = "/opt/pub/scratch"
        rbd = RawBlockDevice(100, storagePath)  # 100MB RAM disk
        # Example usage
        rbd.createFile("hello.txt", "Hello, World!")
        print("Files:", rbd.listFiles())
        print("File content:", rbd.readFile("hello.txt"))
        # time.sleep(20)
    except Exception as e:
        print("An error occurred:", str(e))
    finally:
        del rbd


if __name__ == "__main__":
    main()
