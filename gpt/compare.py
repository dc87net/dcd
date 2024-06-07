#!/usr/bin/env python3

import sqlite3
import os

def getConversations(dbPath):
    conn = sqlite3.connect(dbPath)
    cur = conn.cursor()

    cur.execute('SELECT conversation_id, create_time FROM Conversations')
    conversations = cur.fetchall()

    conn.close()
    return {convo_id: create_time for convo_id, create_time in conversations}

def compareDatabases(dbPathA, dbPathB):
    if not os.path.exists(dbPathA):
        print(f"Error: Database file '{dbPathA}' does not exist.")
        return

    if not os.path.exists(dbPathB):
        print(f"Error: Database file '{dbPathB}' does not exist.")
        return

    conversationsA = getConversations(dbPathA)
    conversationsB = getConversations(dbPathB)

    setA = set(conversationsA.keys())
    setB = set(conversationsB.keys())

    intersection = setA & setB
    onlyInA = setA - setB
    onlyInB = setB - setA

    print(f"Conversations in both A and B (Intersection): {len(intersection)}")
    for convo_id in intersection:
        print(f"- {convo_id}")

    print(f"\nConversations only in A: {len(onlyInA)}")
    for convo_id in onlyInA:
        print(f"- {convo_id} (Created on: {conversationsA[convo_id]})")

    print(f"\nConversations only in B: {len(onlyInB)}")
    for convo_id in onlyInB:
        print(f"- {convo_id} (Created on: {conversationsB[convo_id]})")

def main():
    dbPathA = input("Path to database file A: ").strip()
    dbPathB = input("Path to database file B: ").strip()

    compareDatabases(dbPathA, dbPathB)

if __name__ == "__main__":
    main()
