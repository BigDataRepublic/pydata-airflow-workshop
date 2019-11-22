from notebook.auth import passwd
import os

c.NotebookApp.token = ''
c.NotebookApp.password = passwd(os.getenv('WORKSHOP_PASSWORD', ''))
