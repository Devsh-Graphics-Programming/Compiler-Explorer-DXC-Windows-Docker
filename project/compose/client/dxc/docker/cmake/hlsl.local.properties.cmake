if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
endif()

if(NOT DEFINED DXC_EXECUTABLE)
	message(FATAL_ERROR "DXC_EXECUTABLE must be defined!")
endif()

string(APPEND IMPL_CONTENT
[=[
compilers=&dxc

defaultCompiler=dxc_upstream
supportsBinary=false
compilerType=hlsl
instructionSet=llvm

group.dxc.compilers=dxc_upstream
group.dxc.includeFlag=-I
group.dxc.versionFlag=--version
group.dxc.groupName=DXC compilers

compiler.dxc_upstream.exe=@DXC_EXECUTABLE@
compiler.dxc_upstream.name=DXC
compiler.dxc_upstream.notification=The DXC has been compiled from following <a href="https://github.com/microsoft/DirectXShaderCompiler/commit/@DXC_SHA@" target="_blank" rel="noopener noreferrer">commit<sup><small class="fas fa-external-link-alt opens-new-window" title="Opens the commit in a new window"></small></sup></a>.

]=]
)

message(STATUS "DXC_EXECUTABLE = \"${DXC_EXECUTABLE}\"")

execute_process(COMMAND git -C "$ENV{GIT_DXC_REPOSITORY_PATH}" rev-parse HEAD
	RESULT_VARIABLE _RESULT
	OUTPUT_VARIABLE DXC_SHA
	OUTPUT_STRIP_TRAILING_WHITESPACE
)

if("${_RESULT}" STREQUAL "0")
	message(STATUS "DXC_SHA = \"${DXC_SHA}\"")
else()
	message(FATAL_ERROR "Could not parse local HEAD SHA of \"$ENV{GIT_DXC_REPOSITORY_PATH}\" repository!")
endif()

message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")