import os, subprocess, sys

try:
    GIT_GODBOLT_REPOSITORY_PATH = os.environ.get('GIT_GODBOLT_REPOSITORY_PATH', '')
    DXC_INSTALL_DIRECTORY = os.environ.get('DXC_INSTALL_DIRECTORY', '')
    LLVM_INSTALL_DIRECTORY = os.environ.get('LLVM_INSTALL_DIRECTORY', '')
    SHADY_INSTALL_DIRECTORY = os.environ.get('SHADY_INSTALL_DIRECTORY', '')
    THIS_PROJECT_CLIENT_BIND_DIRECTORY = os.environ.get('THIS_PROJECT_CLIENT_BIND_DIRECTORY', '')

    CMAKE_SCRIPTS_DIRECTORY = os.path.normpath(os.path.join(THIS_PROJECT_CLIENT_BIND_DIRECTORY, "docker/cmake"))
    LLVM_BIN = os.path.normpath(os.path.join(LLVM_INSTALL_DIRECTORY, "bin"))

    if LLVM_BIN not in os.environ["PATH"]:
        os.environ["PATH"] += os.pathsep + LLVM_BIN

    # Godoblt's config direcotry
    GODBOLT_CONFIG_DIRECTORY = os.path.normpath(os.path.join(GIT_GODBOLT_REPOSITORY_PATH, "etc/config"))

    # Clients
    DXC_EXECUTABLE = os.path.normpath(os.path.join(DXC_INSTALL_DIRECTORY, "dxc.exe"))
    VCC_EXECUTABLE = os.path.normpath(os.path.join(SHADY_INSTALL_DIRECTORY, "bin/vcc.exe"))

    cmd = [
        "npm", "run", "dev", "--"
    ]

    lan = ""

    if os.path.exists(DXC_EXECUTABLE):
        HLSL_LOCAL_PROPERTIES = os.path.normpath(os.path.join(GODBOLT_CONFIG_DIRECTORY, "hlsl.local.properties"))
        HLSL_LOCAL_PROPERTIES_CMAKE = os.path.normpath(os.path.join(CMAKE_SCRIPTS_DIRECTORY, "hlsl.local.properties.cmake"))

        subprocess.run(["cmake", f"-DOUTPUT_HLP_PATH={HLSL_LOCAL_PROPERTIES}", f"-DDXC_EXECUTABLE={DXC_EXECUTABLE}", "-P", f"{HLSL_LOCAL_PROPERTIES_CMAKE}"], shell=True)
        lan += "hlsl"

    if os.path.exists(VCC_EXECUTABLE):
        CPP_LOCAL_PROPERTIES = os.path.normpath(os.path.join( GODBOLT_CONFIG_DIRECTORY, "c++.local.properties"))
        CPP_LOCAL_PROPERTIES_CMAKE = os.path.normpath(os.path.join(CMAKE_SCRIPTS_DIRECTORY, "c++.local.properties.cmake"))
        VCC_ISYSTEM = os.path.normpath(os.path.join(SHADY_INSTALL_DIRECTORY, "share/vcc/include/include")) # no idea why twice, issue with install target?

        subprocess.run(["cmake", f"-DOUTPUT_HLP_PATH={CPP_LOCAL_PROPERTIES}", f"-DVCC_ISYSTEM={VCC_ISYSTEM}", f"-DVCC_EXECUTABLE={VCC_EXECUTABLE}", "-P", f"{CPP_LOCAL_PROPERTIES_CMAKE}"], shell=True)
        lan += ",c++"

    if LLVM_BIN not in os.environ["PATH"]:
        os.environ["PATH"] += os.pathsep + LLVM_BIN

    if lan:
        cmd += ["--language", lan]

    os.chdir(GIT_GODBOLT_REPOSITORY_PATH)
    subprocess.run(cmd, shell=True)

except subprocess.CalledProcessError as e:
    print(f"Subprocess failed with exit code {e.returncode}")
    sys.exit(e.returncode)
    
except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(-1)