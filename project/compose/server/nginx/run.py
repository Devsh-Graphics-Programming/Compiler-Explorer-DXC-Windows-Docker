import os, subprocess, sys

sys.path.append(os.path.abspath(os.environ.get('THIS_PROJECT_CLIENT_BIND_DIRECTORY', '')))

from py.git import *

try:
    NGINX_INSTALL_DIRECTORY = os.environ.get('NGINX_INSTALL_DIRECTORY', '')

    os.chdir(NGINX_INSTALL_DIRECTORY)
    subprocess.run(["nginx.exe", "-t"], shell=True, check=True)
    subprocess.run(["nginx.exe"], shell=True, check=True)

except subprocess.CalledProcessError as e:
    print(f"Subprocess failed with exit code {e.returncode}")
    sys.exit(e.returncode)
    
except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(-1)