if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
endif()

if(DEFINED SERVER)
	string(APPEND IMPL_CONTENT
[=[
compilers=devsh.godbolt.client.shady.windows.x86_64@10240
]=]
)
	message(STATUS "SERVER = ON")
else()
	if(NOT DEFINED VCC_EXECUTABLE)
		message(FATAL_ERROR "VCC_EXECUTABLE must be defined!")
	endif()

	if(NOT DEFINED VCC_ISYSTEM)
		message(FATAL_ERROR "VCC_ISYSTEM must be defined!")
	endif()

	string(APPEND IMPL_CONTENT
[=[
compilers=&vcc

defaultCompiler=vcc_upstream
supportsBinary=true
compilerType=clang

group.vcc.compilers=vcc_upstream
group.vcc.includeFlag=-I
group.vcc.versionFlag=--version
group.vcc.groupName=C++/C compilers

compiler.vcc_upstream.exe=@VCC_EXECUTABLE@
compiler.vcc_upstream.name=VCC
compiler.vcc_upstream.options="-isystem@VCC_ISYSTEM@"
]=]
)
	message(STATUS "VCC_EXECUTABLE = \"${VCC_EXECUTABLE}\"")
	message(STATUS "VCC_ISYSTEM = \"${VCC_ISYSTEM}\"")
endif()

message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")