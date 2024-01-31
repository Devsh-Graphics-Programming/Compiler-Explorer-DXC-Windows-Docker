if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
endif()

string(APPEND IMPL_CONTENT
[=[
compilers=&dxc

defaultCompiler=nsc_release_upstream
supportsBinary=false
compilerType=hlsl
instructionSet=llvm

group.dxc.compilers=nsc_release_upstream:nsc_debug_upstream
group.dxc.includeFlag=-I
group.dxc.versionFlag=--version
group.dxc.groupName=NSC compilers

compiler.nsc_release_upstream.exe=@NSC_RELEASE_EXECUTABLE@
compiler.nsc_release_upstream.name=NSC (Release)
compiler.nsc_release_upstream.notification=The NSC (Release) has been compiled from following <a href="https://github.com/Devsh-Graphics-Programming/Nabla/commit/@NABLA_SHA@" target="_blank" rel="noopener noreferrer">commit<sup><small class="fas fa-external-link-alt opens-new-window" title="Opens the commit in a new window"></small></sup></a>.

compiler.nsc_debug_upstream.exe=@NSC_DEBUG_EXECUTABLE@
compiler.nsc_debug_upstream.name=NSC (Debug)
compiler.nsc_debug_upstream.notification=The NSC (Debug) has been compiled from following <a href="https://github.com/Devsh-Graphics-Programming/Nabla/commit/@NABLA_SHA@" target="_blank" rel="noopener noreferrer">commit<sup><small class="fas fa-external-link-alt opens-new-window" title="Opens the commit in a new window"></small></sup></a>.
]=]
)

set(NSC_BIN_DIRECTORY "$ENV{GIT_NABLA_DIRECTORY}/tools/nsc/bin")

find_program(NSC_RELEASE_EXECUTABLE
	NAMES nsc
	HINTS "${NSC_BIN_DIRECTORY}"
	REQUIRED
)

find_program(NSC_DEBUG_EXECUTABLE
	NAMES nsc_d
	HINTS "${NSC_BIN_DIRECTORY}"
	REQUIRED
)

message(STATUS "NSC_RELEASE_EXECUTABLE = \"${NSC_RELEASE_EXECUTABLE}\"")
message(STATUS "NSC_DEBUG_EXECUTABLE = \"${NSC_DEBUG_EXECUTABLE}\"")

execute_process(COMMAND git -C "$ENV{GIT_NABLA_DIRECTORY}" rev-parse HEAD
	RESULT_VARIABLE _RESULT
	OUTPUT_VARIABLE NABLA_SHA
	OUTPUT_STRIP_TRAILING_WHITESPACE
)

if("${_RESULT}" STREQUAL "0")
	message(STATUS "NABLA_SHA = \"${NABLA_SHA}\"")
else()
	message(FATAL_ERROR "Could not parse local HEAD SHA of \"$ENV{GIT_NABLA_DIRECTORY}\" repository!")
endif()

message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")