import os
import subprocess
import sys

def getGitRevisionHash(gitRepoPath, gitObject) -> str:
    return subprocess.check_output(f"git -C {gitRepoPath} rev-parse {gitObject}").decode('ascii').strip()

onInit = False
runGodbolt = False
extraBuildVariables = ""

# Parse command line arguments
for arg in sys.argv:
    if arg == "--on-init":
        onInit = True
    elif arg == "--run-godbolt":
        runGodbolt = True
    elif arg == "--":
        # Capture everything after "--" considered as extra CMake build variables
        extraBuildVariables = " ".join(sys.argv[sys.argv.index(arg) + 1:])
        break

# Get the directory where this script is located
scriptDirectory = os.path.dirname(os.path.abspath(__file__))

# Change the current working directory to the script directory
os.chdir(scriptDirectory)

# Update with DXC's upstream
subprocess.run("git -C ./git/dxc fetch origin main")
print("Comparing local and remote DXC hashes...")

if getGitRevisionHash("./git/dxc", "HEAD") == getGitRevisionHash("./git/dxc", "origin/main") and not onInit:
	print("Hashes identical, skipping build")
else:
	subprocess.run("git -C ./git/dxc checkout origin/main")
	subprocess.run("git -C ./git/dxc submodule update --init --recursive")

	# Configure LLVM project
	subprocess.run([
		"cmake",
		"-C", "./git/dxc/cmake/caches/PredefinedParams.cmake",
		"-S", "./git/dxc",
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
		"-DLLVM_DEFAULT_TARGET_TRIPLE:STING=dxil-ms-dx",
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
	])

	# Build dxc executable
	subprocess.run(f"cmake --build ./build --config Release --target dxc {extraBuildVariables}".strip())

# Run Compiler Explorer instance with DXC compiler (only if --run-godbolt was present)
if runGodbolt:
    os.chdir("./git/godbolt")
    subprocess.run("npm run dev -- --language \"hlsl\"", shell=True)