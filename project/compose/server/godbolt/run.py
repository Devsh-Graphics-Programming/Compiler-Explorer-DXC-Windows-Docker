import os, subprocess, sys

try:
    GIT_GODBOLT_REPOSITORY_PATH = os.environ.get('GIT_GODBOLT_REPOSITORY_PATH', '')
    
    cmd = [
        "npm", "run", "dev", "--", "--language", "c++,hlsl"
    ]

    os.chdir(GIT_GODBOLT_REPOSITORY_PATH)
    subprocess.run(cmd, shell=True)
         
except subprocess.CalledProcessError as e:
    print(f"Subprocess failed with exit code {e.returncode}")
    sys.exit(e.returncode)
    
except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(-1)