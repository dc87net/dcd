#!/usr/bin/env python3

import sqlite3
import os
import sys
import csv
import subprocess
from datetime import datetime

import colors # custom colors for python

def getDefaultPath(defaultKey):
    try:
        result = subprocess.run(['defaults', 'read', 'net.dc87.gpt', defaultKey], capture_output=True, text=True)
        return result.stdout.strip()
    except Exception as e:
        print(f"Error reading default path for {defaultKey}: {e}")
        return ''

def reassembleConversation(dbPath, conversationId):
    if not os.path.exists(dbPath):
        print(f"Error: Database file '{dbPath}' does not exist.")
        return []

    conn = sqlite3.connect(dbPath)
    cur = conn.cursor()

    cur.execute('''
        SELECT create_time, metadata
        FROM Prompts
        WHERE conversation_id = ?
        UNION ALL
        SELECT create_time, metadata
        FROM Completions
        WHERE conversation_id = ?
        ORDER BY 
            CASE WHEN create_time IS NULL THEN 1 ELSE 0 END,
            create_time IS NULL, create_time
    ''', (conversationId, conversationId))

    rows = cur.fetchall()
    conn.close()

    return rows

def formatTimestamp(timestamp):
    if timestamp is None:
        return 'N/A'
    try:
        dt = datetime.fromtimestamp(float(timestamp))
        return dt.strftime('%Y-%m-%d %H:%M:%S')
    except ValueError:
        return 'N/A'

def outputAsTSV(rows, outputFile):
    with open(outputFile, 'w', newline='') as file:
        writer = csv.writer(file, delimiter='\t')
        writer.writerow(['Create Time', 'Metadata'])

        for createTime, metadata in rows:
            formattedTime = formatTimestamp(createTime)
            writer.writerow([formattedTime, metadata or 'N/A'])

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} conversationUUID [dbPath]")
        sys.exit(1)

    conversationId = sys.argv[1]
    dbPath = sys.argv[2] if len(sys.argv) > 2 else getDefaultPath('dbpath')

    outputFile = f"{conversationId}.tsv"

    rows = reassembleConversation(dbPath, conversationId)
    outputAsTSV(rows, outputFile)

    print(f"Conversation {colors.BCYAN}{conversationId}{colors.NC} has been reassembled @"
          f" {colors.BBLUE}{outputFile}{colors.NC}")

if __name__ == "__main__":
    main()