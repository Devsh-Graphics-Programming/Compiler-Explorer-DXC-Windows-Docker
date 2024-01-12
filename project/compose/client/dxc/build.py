import os, subprocess, sys

try:
    GIT_DXC_REPOSITORY_PATH = os.environ.get('GIT_DXC_REPOSITORY_PATH', '')
    DXC_BUILD_DIRECTORY = os.environ.get('DXC_BUILD_DIRECTORY', '')
    DXC_INSTALL_DIRECTORY = os.environ.get('DXC_INSTALL_DIRECTORY', '')

    os.chdir(GIT_DXC_REPOSITORY_PATH)

    subprocess.run([
        "cmake",
        "-C", f"{GIT_DXC_REPOSITORY_PATH}/cmake/caches/PredefinedParams.cmake",
        "-S", GIT_DXC_REPOSITORY_PATH,
        "-B", DXC_BUILD_DIRECTORY,
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
    
    subprocess.run([
        "cmake",
        "--build", DXC_BUILD_DIRECTORY,
        "--config", "Release",
        "--target", "dxc"
    ], check=True)

    subprocess.run([
        "cmake",
        "-E", "copy_directory",
        f"{DXC_BUILD_DIRECTORY}/Release/bin", DXC_INSTALL_DIRECTORY
    ], check=True)
         
except subprocess.CalledProcessError as e:
    print(f"Subprocess failed with exit code {e.returncode}")
    sys.exit(e.returncode)
    
except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(-1)
