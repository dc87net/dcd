#!/usr/bin/env python3
## Installs the `dcd` script wrapper and associcated scripts.
## [Originally written in bash]

import os
import base64
import sqlite3
import shutil
import subprocess
import pwd

## Color constants
colors = {
    "BLACK"   : '\033[0;30m' , "BLUE" : '\033[0;34m' , "CYAN"  : '\033[0;36m' , "GREEN"  : '\033[0;32m',
    "MAGENTA" : '\033[0;35m' , "RED"  : '\033[0;31m' , "WHITE" : '\033[0;37m' , "YELLOW" : '\033[0;33m',
    "BBLACK"  : '\033[0;90m' , "BBLUE": '\033[0;94m' , "BCYAN" : '\033[0;96m' , "BGREEN" : '\033[0;92m',
    "BMAGENTA": '\033[0;95m' , "BRED" : '\033[0;91m' , "BWHITE": '\033[0;97m' , "BYELLOW": '\033[0;93m',
    "NC"      : '\033[0m'
}


def log(message, color="YELLOW"):
    print(f"{colors[color]}==>  {colors['NC']}{message}")


# Installation constants
base_path = '/opt/script'
db_path = os.path.join(base_path, 'scripts.db')
scripts_container = os.path.join(base_path, 'script')


## Helper Functions
def update_file(base64_string, out_file):
    append_line = base64.b64decode(base64_string).decode('utf-8')
    with open(out_file, 'r') as file:
        lines = file.readlines()

    if append_line not in lines:
        with open(out_file, 'a') as file:
            file.write(f"{append_line}\n")
        log(f"Append: {out_file}: {append_line}", "RED")


def enable_logging(log_file):
    if os.path.exists(log_file):
        log(f"Logging: ENABLED: {log_file}", "GREEN")
        return True
    else:
        log(f"Logging: DISABLED: {log_file}", "RED")
        return False


## Prepare & Install
log("══════ ***-> Hang On... <-*** ══════", "YELLOW")
shutil.rmtree(base_path, ignore_errors=True)
os.makedirs(base_path)

## Create SQLite database and table
conn = sqlite3.connect(db_path)
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS scripts (name TEXT PRIMARY KEY, content TEXT)''')
conn.commit()

## Get the true path
this_path = os.path.realpath(__file__)
log(f"SELF: {this_path}", "CYAN")
log(f"REAL: {this_path}", "RED")
log(f"basePath: {base_path}", "YELLOW")

shutil.copytree(os.path.dirname(this_path), base_path, dirs_exist_ok=True)
os.chdir(base_path)

# Get list of subdirectories
dirs = [d for d in os.listdir(scripts_container) if os.path.isdir(os.path.join(scripts_container, d))]
log(f"scriptsContainer: {scripts_container}", "GREEN")

log("********\t********\t********\t********", "YELLOW")
# Enumerate the utility subdirectories
for dir in dirs:
    subdir = os.path.join(scripts_container, dir)
    log(f"Elaborating: {subdir}", "MAGENTA")

    files = [f for f in os.listdir(subdir) if os.path.isfile(os.path.join(subdir, f))]
    for file in files:
        link_name = os.path.splitext(file)[0]
        with open(os.path.join(subdir, file), 'rb') as f:
            script_content = base64.b64encode(f.read()).decode('utf-8')

        log(f"inserting: {file} as {link_name} ({db_path})", "CYAN")
        c.execute('''INSERT OR REPLACE INTO scripts (name, content) VALUES (?, ?)''', (link_name, script_content))
        conn.commit()

log("COPY COMPLETE!", "GREEN")
./et
# Update ZSH profile
user = pwd.getpwuid(os.getuid()).pw_name
log(f"USER: {user}", "MAGENTA")
out_file = f"/Users/{user}/.zshrc"

update_file('UEFUSD0vb3B0L3NjcmlwdDokUEFUSAo=', out_file)
update_file('YWxpYXMgY2RycD0nZXZhbCBjZCBcIiQocmVhbHBhdGggLilcIic=', out_file)

# Clean-up & Staging
log(f"Writing dcd executable to {base_path}/dcd", "CYAN")
with open(os.path.join(base_path, 'dcd'), 'wb') as f:
    f.write(base64.b64decode('IyEvdXNyL2Jpbi9lbnYgenNoCgpldmFsIGJhc2ggLWMgL29wdC9zY3JpcHQvYmluLyRACg=='))
os.chmod(os.path.join(base_path, 'dcd'), 0o755)

# Fix permissions
log("Updating permissions...", "YELLOW")
shutil.chown(base_path, user)
os.chmod(base_path, 0o755)

# Notify: Install complete
log("Installation COMPLETE!", "GREEN")
log("TREE:", "CYAN")
subprocess.run(['tree', base_path])

# Switch to the specified user and start a new login shell
subprocess.run(['su', '-', user, '-c', 'exec zsh'])