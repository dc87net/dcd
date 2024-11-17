#!/usr/bin/env bash

cat << 'EOF'
  CREATE TABLE directories (
      id INTEGER PRIMARY KEY,
      path TEXT UNIQUE NOT NULL,
      size INTEGER,
      file_count INTEGER,
      last_scanned TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE files (
      id INTEGER PRIMARY KEY,
      path TEXT UNIQUE NOT NULL,
      directory_id INTEGER,
      size INTEGER,
      last_modified TIMESTAMP,
      FOREIGN KEY (directory_id) REFERENCES directories(id)
  );

  CREATE INDEX idx_file_directory ON files(directory_id);
EOF
#cat <5;
