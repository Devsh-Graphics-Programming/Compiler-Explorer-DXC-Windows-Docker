if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
endif()

if(DEFINED SERVER)
	if(NOT DEFINED SERVER_NAME)
		message(FATAL_ERROR "SERVER_NAME must be defined!")
	endif()

	string(APPEND IMPL_CONTENT
[=[
compilers=@SERVER_NAME@@443
]=]
)
	message(STATUS "SERVER = ON")
	message(STATUS "SERVER_NAME = ${SERVER_NAME}")
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

compiler.vcc_upstream.notification=The VCC has been compiled from following <a href="https://github.com/Devsh-Graphics-Programming/shady/commit/@VCC_SHA@" target="_blank" rel="noopener noreferrer">commit<sup><small class="fas fa-external-link-alt opens-new-window" title="Opens the commit in a new window"></small></sup></a>.

compiler.vcc_upstream.exe=@VCC_EXECUTABLE@
compiler.vcc_upstream.name=VCC
compiler.vcc_upstream.options=--entry-point main -isystem@VCC_ISYSTEM@
]=]
)
	message(STATUS "VCC_EXECUTABLE = \"${VCC_EXECUTABLE}\"")
	message(STATUS "VCC_ISYSTEM = \"${VCC_ISYSTEM}\"")
	string(REPLACE "\\" "/" VCC_ISYSTEM "${VCC_ISYSTEM}")

	execute_process(COMMAND git -C "$ENV{GIT_SHADY_DIRECTORY}" rev-parse HEAD
		RESULT_VARIABLE _RESULT
		OUTPUT_VARIABLE VCC_SHA
		OUTPUT_STRIP_TRAILING_WHITESPACE
	)

	if("${_RESULT}" STREQUAL "0")
		message(STATUS "VCC_SHA = \"${VCC_SHA}\"")
	else()
		message(FATAL_ERROR "Could not parse local HEAD SHA of \"$ENV{GIT_SHADY_DIRECTORY}\" repository!")
	endif()

endif()

message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")