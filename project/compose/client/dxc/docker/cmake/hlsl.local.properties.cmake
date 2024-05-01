if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
endif()

if(NOT DEFINED DXC_REV_TARGET)
	message(FATAL_ERROR "DXC_REV_TARGET must be defined!")
endif()

string(APPEND IMPL_CONTENT
[=[
compilers=&dxc

defaultCompiler=dxc_release_upstream
supportsBinary=false
compilerType=hlsl
instructionSet=llvm

group.dxc.compilers=dxc_release_upstream:dxc_debug_upstream
group.dxc.includeFlag=-I
group.dxc.versionFlag=--version
group.dxc.groupName=DXC compilers

compiler.dxc_release_upstream.exe=@DXC_RELEASE_EXECUTABLE@
compiler.dxc_release_upstream.name=DXC (Release)
compiler.dxc_release_upstream.notification=The DXC (Release) has been compiled from following <a href="https://github.com/Devsh-Graphics-Programming/Nabla/commit/@DXC_REV_TARGET@" target="_blank" rel="noopener noreferrer">commit<sup><small class="fas fa-external-link-alt opens-new-window" title="Opens the commit in a new window"></small></sup></a>.

compiler.dxc_debug_upstream.exe=@DXC_DEBUG_EXECUTABLE@
compiler.dxc_debug_upstream.name=DXC (Debug)
compiler.dxc_debug_upstream.notification=The DXC (Debug) has been compiled from following <a href="https://github.com/Devsh-Graphics-Programming/Nabla/commit/@DXC_REV_TARGET@" target="_blank" rel="noopener noreferrer">commit<sup><small class="fas fa-external-link-alt opens-new-window" title="Opens the commit in a new window"></small></sup></a>.
]=]
)

find_program(DXC_RELEASE_EXECUTABLE
	NAMES dxc
	HINTS "$ENV{GIT_DXC_REPOSITORY_PATH}/install/release/bin"
	REQUIRED
)

find_program(DXC_DEBUG_EXECUTABLE
	NAMES dxc
	HINTS "$ENV{GIT_DXC_REPOSITORY_PATH}/install/debug/bin"
	REQUIRED
)

message(STATUS "DXC_RELEASE_EXECUTABLE = \"${DXC_RELEASE_EXECUTABLE}\"")
message(STATUS "DXC_DEBUG_EXECUTABLE = \"${DXC_DEBUG_EXECUTABLE}\"")

message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")