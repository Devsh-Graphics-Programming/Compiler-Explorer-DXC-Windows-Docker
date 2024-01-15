if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
endif()

if(DEFINED SERVER)
	string(APPEND IMPL_CONTENT
[=[
compilers=devsh.godbolt.client.dxc.windows.x86_64@443
]=]
)
	message(STATUS "SERVER = ON")
else()
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
]=]
)
	message(STATUS "DXC_EXECUTABLE = \"${DXC_EXECUTABLE}\"")
endif()

message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")