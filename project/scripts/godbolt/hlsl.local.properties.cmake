if(NOT DEFINED BUILD_SCRIPT_DIRECTORY)
	message(FATAL_ERROR "BUILD_SCRIPT_DIRECTORY must be defined!")
endif()

if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
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

compiler.dxc_upstream.exe=@BUILD_SCRIPT_DIRECTORY@\build\Release\bin\dxc.exe
compiler.dxc_upstream.name=DXC from upstream
]=]
)

message(STATUS "BUILD_SCRIPT_DIRECTORY = \"${BUILD_SCRIPT_DIRECTORY}\"")
message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")