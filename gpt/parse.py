#!/usr/bin/env python3

import json
import sqlite3
import os
import sys
import subprocess
from datetime import datetime

"""
--------------------
## Default Values ##
--------------------
defaults write /opt/net.dc87.gpt jsonpath '/opt/gptdb/json/conversations.json'
defaults write net.dc87.gpt dbpath   '/opt/gptdb/gpt.db'

defaults read net.dc87.gpt jsonpath
defaults read net.dc87.gpt dbpath

cp conversations.json "$(dirname "$(defaults read net.dc87.gpt jsonpath)")"
"""

def getDefaultPath(defaultKey):
    try:
        result = subprocess.run(['defaults', 'read', '/opt/script/config.plist', defaultKey], capture_output=True, text=True)
        return result.stdout.strip()
    except Exception as e:
        print(f"Error reading default path for {defaultKey}: {e}")
        return ''

def createDatabase(dbPath):
    today = datetime.now().strftime("%Y-%m-%d")
    dbPath = os.path.expanduser(dbPath)
    os.makedirs(os.path.dirname(dbPath), exist_ok=True)

    conn = sqlite3.connect(dbPath)
    cur = conn.cursor()

    cur.execute('''
        CREATE TABLE IF NOT EXISTS Conversations (
            conversation_id TEXT PRIMARY KEY,
            title TEXT,
            create_time TEXT,
            update_time TEXT,
            current_node TEXT,
            conversation_template_id TEXT,
            gizmo_id TEXT,
            is_archived BOOLEAN,
            moderation_results TEXT
        )
    ''')

    cur.execute('''
        CREATE TABLE IF NOT EXISTS Prompts (
            id TEXT PRIMARY KEY,
            conversation_id TEXT,
            create_time TEXT,
            content TEXT,
            metadata TEXT,
            FOREIGN KEY (conversation_id) REFERENCES Conversations (conversation_id)
        )
    ''')

    cur.execute('''
        CREATE TABLE IF NOT EXISTS Completions (
            id TEXT PRIMARY KEY,
            conversation_id TEXT,
            create_time TEXT,
            content TEXT,
            metadata TEXT,
            FOREIGN KEY (conversation_id) REFERENCES Conversations (conversation_id)
        )
    ''')

    conn.commit()
    return conn

def processJson(jsonFile, conn):
    print(f'Processing {jsonFile} ...')

    with open(jsonFile, 'r') as file:
        data = json.load(file)

    totalConversations = len(data)
    for convoIndex, conversation in enumerate(data, start=1):
        convoProgress = (convoIndex / totalConversations) * 100
        print(f'\rProcessing conversation {convoIndex} of {totalConversations} ({convoProgress:.2f}%)', end='', flush=True)

        conn.execute('''
            INSERT INTO Conversations (conversation_id, title, create_time, update_time, current_node, conversation_template_id, gizmo_id, is_archived, moderation_results)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            conversation.get('conversation_id'),
            conversation.get('title'),
            conversation.get('create_time'),
            conversation.get('update_time'),
            conversation.get('current_node'),
            conversation.get('conversation_template_id'),
            conversation.get('gizmo_id'),
            conversation.get('is_archived'),
            json.dumps(conversation.get('moderation_results'))
        ))

        messages = conversation.get('mapping', {})
        totalMessages = len(messages)
        for msgIndex, (messageId, messageDetails) in enumerate(messages.items(), start=1):
            msgProgress = (msgIndex / totalMessages) * 100
            print(f'\r\tProcessing message {msgIndex} of {totalMessages} in conversation {convoIndex} ({msgProgress:.2f}%)', end='', flush=True)

            message = messageDetails.get('message')
            if message is not None:
                authorRole = message.get('author', {}).get('role')
                contentParts = message.get('content', {}).get('parts', [])
                content = ' '.join(part if isinstance(part, str) else part.get('text', '') for part in contentParts)

                if authorRole == 'user':
                    conn.execute('''
                        INSERT OR IGNORE INTO Prompts (id, conversation_id, create_time, content, metadata)
                        VALUES (?, ?, ?, ?, ?)
                    ''', (
                        messageId,
                        conversation.get('conversation_id'),
                        message.get('create_time'),
                        content,
                        json.dumps(message.get('metadata'))
                    ))
                elif authorRole in ['assistant', 'system']:
                    conn.execute('''
                        INSERT OR IGNORE INTO Completions (id, conversation_id, create_time, content, metadata)
                        VALUES (?, ?, ?, ?, ?)
                    ''', (
                        messageId,
                        conversation.get('conversation_id'),
                        message.get('create_time'),
                        content,
                        json.dumps(message.get('metadata'))
                    ))

    print('\nProcessing complete.')
    conn.commit()

def main():
    defaultDbPath = getDefaultPath('dbpath')
    dbPath = input(f"Path to database file? [{defaultDbPath}]: ").strip() or defaultDbPath

    defaultJsonPath = getDefaultPath('jsonpath')
    jsonFile = input(f"Path to JSON file? [{defaultJsonPath}]: ").strip() or defaultJsonPath

    if not os.path.exists(jsonFile):
        print(f"Error: JSON file '{jsonFile}' does not exist.")
        sys.exit(1)

    conn = createDatabase(dbPath)
    processJson(jsonFile, conn)
    conn.close()

if __name__ == "__main__":
    main()
