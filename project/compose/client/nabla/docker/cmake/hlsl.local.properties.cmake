if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
endif()

if(NOT DEFINED NABLA_REV_TARGET)
	message(FATAL_ERROR "NABLA_REV_TARGET must be defined!")
endif()

string(APPEND IMPL_CONTENT
[=[
compilers=&dxc

defaultCompiler=nsc_release_upstream
supportsBinary=true
supportsBinaryObject=true
compilerType=nsc-spirv
needsMulti=false
supportsLibraryCodeFilter=true
disassemblerPath=@SPIRV_DIS_EXE@
demangler=

group.dxc.compilers=nsc_release_upstream:nsc_debug_upstream
group.dxc.includeFlag=-I
group.dxc.versionFlag=--version
group.dxc.groupName=NSC compilers

compiler.nsc_release_upstream.exe=@NSC_RELEASE_EXECUTABLE@
compiler.nsc_release_upstream.name=NSC (Release)
compiler.nsc_release_upstream.notification=The NSC (Release) has been compiled from following <a href="https://github.com/Devsh-Graphics-Programming/Nabla/commit/@NABLA_REV_TARGET@" target="_blank" rel="noopener noreferrer">commit<sup><small class="fas fa-external-link-alt opens-new-window" title="Opens the commit in a new window"></small></sup></a>.
compiler.nsc_release_upstream.supportsExecute=false
compiler.nsc_release_upstream.options=
compiler.nsc_release_upstream.disassemblerPath=@SPIRV_DIS_EXE@
compiler.nsc_release_upstream.demangler=

compiler.nsc_debug_upstream.exe=@NSC_DEBUG_EXECUTABLE@
compiler.nsc_debug_upstream.name=NSC (Debug)
compiler.nsc_debug_upstream.notification=The NSC (Debug) has been compiled from following <a href="https://github.com/Devsh-Graphics-Programming/Nabla/commit/@NABLA_REV_TARGET@" target="_blank" rel="noopener noreferrer">commit<sup><small class="fas fa-external-link-alt opens-new-window" title="Opens the commit in a new window"></small></sup></a>.
compiler.nsc_debug_upstream.supportsExecute=false
compiler.nsc_debug_upstream.options=
compiler.nsc_debug_upstream.disassemblerPath=@SPIRV_DIS_EXE@
compiler.nsc_debug_upstream.demangler=
]=]
)

find_program(NSC_RELEASE_EXECUTABLE
	NAMES nsc
	HINTS "$ENV{GIT_NABLA_DIRECTORY}/install/exe/tools/nsc/bin"
	REQUIRED
)

find_program(NSC_DEBUG_EXECUTABLE
	NAMES nsc_d
	HINTS "$ENV{GIT_NABLA_DIRECTORY}/install/debug/exe/tools/nsc/bin"
	REQUIRED
)

message(STATUS "NSC_RELEASE_EXECUTABLE = \"${NSC_RELEASE_EXECUTABLE}\"")
message(STATUS "NSC_DEBUG_EXECUTABLE = \"${NSC_DEBUG_EXECUTABLE}\"")

find_program(SPIRV_DIS_EXE
	NAMES spirv-dis
	HINTS "$ENV{VULKAN_SDK_INSTALL_DIRECTORY}/Bin"
	REQUIRED
)
message(STATUS "SPIRV_DIS_EXE = \"${SPIRV_DIS_EXE}\"")

message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")
