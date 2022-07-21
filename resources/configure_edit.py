#!/usr/bin/env python3
"""This script updates the jupyter_notebook_config file so that we
can run jupyter notebooks from the linux sandbox server if we want.
"""

EDITS = """
c = get_config()
c.NotebookApp.certfile= u'/home/ubuntu/certs/mycert.pem'
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
"""

CONFIG_PATH='/home/ubuntu/.jupyter/jupyter_notebook_config.py'

with open(CONFIG_PATH, mode='r',encoding='utf-8') as file:
    CONTENTS = file.readlines()
CONTENTS.insert(1,EDITS)


with open(CONFIG_PATH, mode='w',encoding='utf-8') as file:
    #convert to string
    CONTENTS = "".join(CONTENTS)
    file.write(CONTENTS)

print(f"Modified {CONFIG_PATH}")
