import os, subprocess, sys, argparse, socket
    
def healthyCheck():
    try:
        NGINX_PROXY_SERVER_NAME = os.environ.get('NGINX_PROXY_SERVER_NAME', '')

        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(5)
            s.connect((NGINX_PROXY_SERVER_NAME, 443))
        
        print(f"Connected to {NGINX_PROXY_SERVER_NAME} godbolt client instance, healthy check passed")

        return True
    except (socket.error, socket.timeout):
        print(f"Excpetion caught while trying to connect to {NGINX_PROXY_SERVER_NAME} godbolt client instance, healthy check didnt pass: \"{socket.error}\"")
        return False

try:
    parser = argparse.ArgumentParser(description="server.godbolt.run Framework Module")
    
    parser.add_argument("--healthyCheck", help="Check if service is healthy and server is running", action="store_true")

    args = parser.parse_args()

    if args.healthyCheck:
        if healthyCheck():
            sys.exit(0)  # healthy
        else:
            sys.exit(-1)
    else:
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