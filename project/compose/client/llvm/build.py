import os, subprocess, sys

try:
    GIT_LLVM_DIRECTORY = os.environ.get('GIT_LLVM_DIRECTORY', '')
    LLVM_BUILD_DIRECTORY = os.environ.get('LLVM_BUILD_DIRECTORY', '')
    LLVM_INSTALL_DIRECTORY = os.environ.get('LLVM_INSTALL_DIRECTORY', '')

    os.chdir(GIT_LLVM_DIRECTORY)

    subprocess.run([
        "cmake",
        "-S", f"{GIT_LLVM_DIRECTORY}",
        "-B", f"{LLVM_BUILD_DIRECTORY}",
        "-G", "Visual Studio 17 2022", # TODO: if more platform update then
        "-T", "ClangCL",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DLLVM_ENABLE_PROJECTS=lld;clang;clang-tools-extra",
        "-DLLVM_TARGETS_TO_BUILD=host",
        "-DLLVM_ENABLE_RUNTIMES=libcxx",
        "-DLLVM_ENABLE_EH=ON",
        "-DLLVM_ENABLE_RTTI=ON",
        "-DLLVM_INCLUDE_BENCHMARKS=ON",
        "-DLLVM_USE_SPLIT_DWARF=ON",
        "-DLLVM_INCLUDE_EXAMPLES=OFF",
        "-DLLVM_INCLUDE_TESTS=OFF",
        "-DLLVM_ENABLE_ZLIB=OFF",
        f"-DCMAKE_INSTALL_PREFIX={LLVM_INSTALL_DIRECTORY}"
    ], check=True)
    
    subprocess.run([
        "cmake",
        "--build", f"{LLVM_BUILD_DIRECTORY}", "-j8",
        "--config", "Release"
    ], check=True)
    
    subprocess.run([
        "cmake",
        "--install", f"{LLVM_BUILD_DIRECTORY}",
        "--prefix", f"{LLVM_INSTALL_DIRECTORY}",
        "--config", "Release"
    ], check=True)
         
except subprocess.CalledProcessError as e:
    print(f"Subprocess failed with exit code {e.returncode}")
    sys.exit(e.returncode)
    
except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(-1)