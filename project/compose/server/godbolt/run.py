import os, subprocess, sys, argparse, socket

def getLocalIPV4():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(('8.8.8.8', 80))
        ipv4 = s.getsockname()[0] # Get the local IPv4 address
        s.close()
        
        return ipv4
    except socket.error:
        return None
    
def healthyCheck():
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(5)
            s.connect((getLocalIPV4(), 10240))
        
        print(f"Connected to localhost godbolt client instance, healthy check passed")

        return True
    except (socket.error, socket.timeout):
        print(f"Excpetion caught while trying to connect to localhost godbolt client instance, healthy check didnt pass: \"{socket.error}\"")
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