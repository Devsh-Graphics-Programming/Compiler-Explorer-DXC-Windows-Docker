import os, subprocess, sys

sys.path.append(os.path.abspath(os.environ.get('THIS_PROJECT_CLIENT_BIND_DIRECTORY', '')))

from py.git import *

try:
    GIT_DXC_REPOSITORY_PATH = os.environ.get('GIT_DXC_REPOSITORY_PATH', '')
    GIT_GODBOLT_REPOSITORY_PATH = os.environ.get('GIT_GODBOLT_REPOSITORY_PATH', '')

    # sha = getGitRevisionHash(GIT_DXC_REPOSITORY_PATH, "HEAD")
    # logSHA(sha, "https://github.com/microsoft/DirectXShaderCompiler.git")

    cmd = [
        "npm", "run", "dev", "--", "--language", "hlsl"
    ]

    os.chdir(GIT_GODBOLT_REPOSITORY_PATH)
    subprocess.run(cmd, shell=True)
         
except subprocess.CalledProcessError as e:
    print(f"Subprocess failed with exit code {e.returncode}")
    sys.exit(e.returncode)
    
except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(-1)
