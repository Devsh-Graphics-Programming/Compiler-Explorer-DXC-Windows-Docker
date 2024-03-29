# escape=`

ARG BASE_IMAGE=artifactory.devsh.eu/godbolt/base:latest

ARG DXC_REV_TARGET
ARG GIT_DXC_REPOSITORY_PATH
ARG DXC_BUILD_DIRECTORY
ARG DXC_INSTALL_DIRECTORY
ARG THIS_PROJECT_SCRIPTS_DIRECTORY
ARG GIT_GODBOLT_REPOSITORY_PATH

FROM ${BASE_IMAGE}

SHELL ["cmd", "/S", "/C"]

ARG DXC_REV_TARGET
ARG GIT_DXC_REPOSITORY_PATH

RUN `
	mkdir "%GIT_DXC_REPOSITORY_PATH%" `
	`
	&& git -C "%GIT_DXC_REPOSITORY_PATH%" init `
	`
	&& git -C "%GIT_DXC_REPOSITORY_PATH%" remote add origin https://github.com/microsoft/DirectXShaderCompiler.git `
	`
	&& git -C "%GIT_DXC_REPOSITORY_PATH%" fetch --depth=1 -- origin "%DXC_REV_TARGET%" `
	`
	&& git -C "%GIT_DXC_REPOSITORY_PATH%" checkout "%DXC_REV_TARGET%" `
	`
	&& git -C "%GIT_DXC_REPOSITORY_PATH%" submodule update --init --recursive

ARG DXC_BUILD_DIRECTORY

RUN `
	cmake -C "%GIT_DXC_REPOSITORY_PATH%\cmake\caches\PredefinedParams.cmake" -S "%GIT_DXC_REPOSITORY_PATH%" -B "%DXC_BUILD_DIRECTORY%" -Ax64 -T v143 -DHLSL_OPTIONAL_PROJS_IN_DEFAULT:BOOL=OFF -DHLSL_ENABLE_ANALYZE:BOOL=OFF -DHLSL_OFFICIAL_BUILD:BOOL=OFF -DHLSL_ENABLE_FIXED_VER:BOOL=OFF -DHLSL_FIXED_VERSION_LOCATION:STRING="" -DHLSL_BUILD_DXILCONV:BOOL=ON -DCLANG_VENDOR:STRING="" -DENABLE_SPIRV_CODEGEN:BOOL=ON -DSPIRV_BUILD_TESTS:BOOL=OFF -DCLANG_ENABLE_ARCMT:BOOL=OFF -DCLANG_ENABLE_STATIC_ANALYZER:BOOL=OFF -DCLANG_INCLUDE_TESTS:BOOL=Off -DLLVM_INCLUDE_TESTS:BOOL=Off -DHLSL_INCLUDE_TESTS:BOOL=OFF -DLLVM_TARGETS_TO_BUILD:STRING=None -DLLVM_INCLUDE_DOCS:BOOL=OFF -DLLVM_INCLUDE_TESTS:BOOL=OFF -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF -DLIBCLANG_BUILD_STATIC:BOOL=ON -DLLVM_OPTIMIZED_TABLEGEN:BOOL=OFF -DLLVM_REQUIRES_EH:BOOL=ON -DLLVM_APPEND_VC_REV:BOOL=ON -DLLVM_ENABLE_RTTI:BOOL=ON -DLLVM_ENABLE_EH:BOOL=ON -DLLVM_DEFAULT_TARGET_TRIPLE:STRING=dxil-ms-dx -DCLANG_BUILD_EXAMPLES:BOOL=OFF -DLLVM_REQUIRES_RTTI:BOOL=ON -DCLANG_CL:BOOL=OFF -DLLVM_ENABLE_WERROR:BOOL=OFF -DSPIRV_WERROR:BOOL=OFF -DDXC_BUILD_ARCH:STRING=x64 -DSPIRV_HEADERS_SKIP_INSTALL:BOOL=ON -DSPIRV_HEADERS_SKIP_EXAMPLES:BOOL=ON -DSKIP_SPIRV_TOOLS_INSTALL:BOOL=ON -DSPIRV_SKIP_TESTS:BOOL=ON -DSPIRV_SKIP_EXECUTABLES:BOOL=ON -DHLSL_ENABLE_DEBUG_ITERATORS:BOOL=ON
	
RUN	`
	cmake --build "%DXC_BUILD_DIRECTORY%" --config Release --target dxc
	
ARG ARG DXC_INSTALL_DIRECTORY

RUN `
	cmake -E copy_directory "%DXC_BUILD_DIRECTORY%\Release\bin" "%DXC_INSTALL_DIRECTORY%"

ARG THIS_PROJECT_SCRIPTS_DIRECTORY

COPY client\dxc\docker\cmake\hlsl.local.properties.cmake ${THIS_PROJECT_SCRIPTS_DIRECTORY}\cmake\hlsl.local.properties.cmake

ARG GIT_GODBOLT_REPOSITORY_PATH

RUN `
	cmake -DOUTPUT_HLP_PATH="%GIT_GODBOLT_REPOSITORY_PATH%\etc\config\hlsl.local.properties" -DDXC_EXECUTABLE="%DXC_INSTALL_DIRECTORY%\dxc.exe" -P "%THIS_PROJECT_SCRIPTS_DIRECTORY%\cmake\hlsl.local.properties.cmake"

ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]