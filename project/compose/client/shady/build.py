import os, subprocess, sys

try:
    GIT_SHADY_DIRECTORY = os.environ.get('GIT_SHADY_DIRECTORY', '')
    SHADY_BUILD_DIRECTORY = os.environ.get('SHADY_BUILD_DIRECTORY', '')
    SHADY_INSTALL_DIRECTORY = os.environ.get('SHADY_INSTALL_DIRECTORY', '')
    CJSON_INSTALL_DIRECTORY = os.environ.get('CJSON_INSTALL_DIRECTORY', '')
    SPIRV_HEADERS_INSTALL_DIRECTORY = os.environ.get('SPIRV_HEADERS_INSTALL_DIRECTORY', '')
    LLVM_INSTALL_DIRECTORY = os.environ.get('LLVM_INSTALL_DIRECTORY', '')

    os.chdir(GIT_SHADY_DIRECTORY)

    subprocess.run([
        "cmake",
        "-S", GIT_SHADY_DIRECTORY,
        "-B", SHADY_BUILD_DIRECTORY,
        "-G", "Visual Studio 17 2022", # TODO: if more platform update then
        "-DCMAKE_BUILD_TYPE=Release",
        f"-DLLVM_DIR={LLVM_INSTALL_DIRECTORY}/lib/cmake/llvm",
        f"-DSPIRV-Headers_DIR={SPIRV_HEADERS_INSTALL_DIRECTORY}/share/cmake/SPIRV-Headers",
        f"-Djson-c_DIR={CJSON_INSTALL_DIRECTORY}/lib/cmake/json-c",
        f"-DCMAKE_INSTALL_PREFIX={SHADY_INSTALL_DIRECTORY}"
    ], check=True)
    
    subprocess.run([
        "cmake",
        "--build", SHADY_BUILD_DIRECTORY,
        "--config", "Release"
    ], check=True)

    subprocess.run([
        "cmake",
        "--install", f"{SHADY_BUILD_DIRECTORY}",
        "--prefix", f"{SHADY_INSTALL_DIRECTORY}",
        "--config", "Release"
    ], check=True)


    IN_SHADY_BIN = os.path.normpath(os.path.join(SHADY_BUILD_DIRECTORY, "bin/Release"))
    TO_SHADY_BIN = os.path.normpath(os.path.join(SHADY_INSTALL_DIRECTORY, "bin"))

    subprocess.run([
        "cmake",
        "-E", "copy_directory",
        IN_SHADY_BIN, TO_SHADY_BIN
    ], check=True)

    # NOTE: install target is missing a bit some files including main shady.dll

    

    
             
except subprocess.CalledProcessError as e:
    print(f"Subprocess failed with exit code {e.returncode}")
    sys.exit(e.returncode)
    
except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(-1)