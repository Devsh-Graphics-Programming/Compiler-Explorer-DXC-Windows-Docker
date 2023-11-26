import os, subprocess, sys

def getGitRevisionHash(gitRepoPath, gitObject) -> str:
    return subprocess.check_output(f"git -C \"{gitRepoPath}\" rev-parse {gitObject}").decode('ascii').strip()

def logSHAs(local, remote):
    print(f"Local SHA: \"${local}\", url: https://github.com/microsoft/DirectXShaderCompiler/commit/${local}")
    print(f"Remote latest SHA: \"${remote}\", url: https://github.com/microsoft/DirectXShaderCompiler/commit/${remote}")

runGodbolt = False
configureOnly = False
hashCheckOnly = False
extraBuildVariables = ""

try:
    # Parse command line arguments
    for arg in sys.argv:
        if arg == "--run-godbolt":
            runGodbolt = True
        elif arg == "--configure-only":
            configureOnly = True
        elif arg == "--hash-check-only":
            hashCheckOnly = True
        elif arg == "--":
            # Capture everything after "--" considered as extra CMake build variables
            extraBuildVariables = " ".join(sys.argv[sys.argv.index(arg) + 1:])
            break

    # Get the directory where this script is located
    scriptDirectory = os.path.dirname(os.path.abspath(__file__))

    # Change the current working directory to the script directory
    os.chdir(scriptDirectory)

    GIT_GODBOLT_REPOSITORY_PATH = os.environ.get('GIT_GODBOLT_REPOSITORY_PATH', '')
    GIT_DXC_REPOSITORY_PATH = os.environ.get('GIT_DXC_REPOSITORY_PATH', '')

    # Request update with DXC's upstream
    subprocess.run(f"git -C \"{GIT_DXC_REPOSITORY_PATH}\" fetch origin main", check=True)
    print("Comparing local & remote DXC SHAs...")

    localSHA = getGitRevisionHash(GIT_DXC_REPOSITORY_PATH, "HEAD")
    remoteSHA = getGitRevisionHash(GIT_DXC_REPOSITORY_PATH, "origin/main")

    areHashesDifferent = localSHA != remoteSHA
    
    logSHAs(localSHA, remoteSHA)

    if hashCheckOnly:
        if areHashesDifferent:
            sys.exit(1)
        else:
            sys.exit()

    if areHashesDifferent:
        print("SHA hashes are different, fetching remote repository and updating local...")
        subprocess.run(f"git -C \"{GIT_DXC_REPOSITORY_PATH}\" checkout origin/main", check=True)
        subprocess.run(f"git -C \"{GIT_DXC_REPOSITORY_PATH}\" submodule update --init --recursive", check=True)
    else:
        print("SHA hashes are identical, local repository won't get updated from remote!")

    if areHashesDifferent or not os.path.exists("./build"):
        # Configure LLVM project
        subprocess.run([
            "cmake",
            "-C", f"{GIT_DXC_REPOSITORY_PATH}/cmake/caches/PredefinedParams.cmake",
            "-S", f"{GIT_DXC_REPOSITORY_PATH}",
            "-B", "./build",
            "-Ax64",
            "-T", "v143",
            "-DHLSL_OPTIONAL_PROJS_IN_DEFAULT:BOOL=OFF",
            "-DHLSL_ENABLE_ANALYZE:BOOL=OFF",
            "-DHLSL_OFFICIAL_BUILD:BOOL=OFF",
            "-DHLSL_ENABLE_FIXED_VER:BOOL=OFF",
            "-DHLSL_FIXED_VERSION_LOCATION:STRING=",
            "-DHLSL_BUILD_DXILCONV:BOOL=ON",
            "-DCLANG_VENDOR:STRING=",
            "-DENABLE_SPIRV_CODEGEN:BOOL=ON",
            "-DSPIRV_BUILD_TESTS:BOOL=OFF",
            "-DCLANG_ENABLE_ARCMT:BOOL=OFF",
            "-DCLANG_ENABLE_STATIC_ANALYZER:BOOL=OFF",
            "-DCLANG_INCLUDE_TESTS:BOOL=Off",
            "-DLLVM_INCLUDE_TESTS:BOOL=Off",
            "-DHLSL_INCLUDE_TESTS:BOOL=OFF",
            "-DLLVM_TARGETS_TO_BUILD:STRING=None",
            "-DLLVM_INCLUDE_DOCS:BOOL=OFF",
            "-DLLVM_INCLUDE_TESTS:BOOL=OFF",
            "-DLLVM_INCLUDE_EXAMPLES:BOOL=OFF",
            "-DLIBCLANG_BUILD_STATIC:BOOL=ON",
            "-DLLVM_OPTIMIZED_TABLEGEN:BOOL=OFF",
            "-DLLVM_REQUIRES_EH:BOOL=ON",
            "-DLLVM_APPEND_VC_REV:BOOL=ON",
            "-DLLVM_ENABLE_RTTI:BOOL=ON",
            "-DLLVM_ENABLE_EH:BOOL=ON",
            "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING=dxil-ms-dx",
            "-DCLANG_BUILD_EXAMPLES:BOOL=OFF",
            "-DLLVM_REQUIRES_RTTI:BOOL=ON",
            "-DCLANG_CL:BOOL=OFF",
            "-DLLVM_ENABLE_WERROR:BOOL=OFF",
            "-DSPIRV_WERROR:BOOL=OFF",
            "-DDXC_BUILD_ARCH:STRING=x64",
            "-DSPIRV_HEADERS_SKIP_INSTALL:BOOL=ON",
            "-DSPIRV_HEADERS_SKIP_EXAMPLES:BOOL=ON",
            "-DSKIP_SPIRV_TOOLS_INSTALL:BOOL=ON",
            "-DSPIRV_SKIP_TESTS:BOOL=ON",
            "-DSPIRV_SKIP_EXECUTABLES:BOOL=ON",
            "-DHLSL_ENABLE_DEBUG_ITERATORS:BOOL=ON"
        ], check=True)
        
    # Build dxc executable
    if configureOnly:
        print("--configure-only mode enabled, skipping the build...")
    else:
        subprocess.run(f"cmake --build ./build --config Release --target dxc {extraBuildVariables}".strip(), check=True)
            
    # Run Compiler Explorer instance with DXC compiler
    if runGodbolt:
        os.chdir(GIT_GODBOLT_REPOSITORY_PATH)
        subprocess.run("npm run dev -- --language \"hlsl\"", shell=True)
        
except subprocess.CalledProcessError as e:
    print(f"Subprocess failed with exit code {e.returncode}")
    sys.exit(e.returncode)
    
except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(-1)