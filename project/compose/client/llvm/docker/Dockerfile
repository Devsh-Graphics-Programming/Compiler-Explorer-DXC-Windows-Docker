# escape=`

ARG BASE_IMAGE=artifactory.devsh.eu/godbolt/base:latest

ARG LLVM_REV_TARGET
ARG GIT_LLVM_DIRECTORY
ARG LLVM_BUILD_DIRECTORY
ARG LLVM_INSTALL_DIRECTORY

FROM ${BASE_IMAGE}

SHELL ["cmd", "/S", "/C"]

ARG LLVM_REV_TARGET
ARG GIT_LLVM_DIRECTORY

RUN `
	mkdir "%GIT_LLVM_DIRECTORY%" `
	`
	&& git -C "%GIT_LLVM_DIRECTORY%" init `
	`
	&& git -C "%GIT_LLVM_DIRECTORY%" remote add origin https://github.com/llvm/llvm-project.git `
	`
	&& git -C "%GIT_LLVM_DIRECTORY%" fetch --depth=1 -- origin "%LLVM_REV_TARGET%" `
	`
	&& git -C "%GIT_LLVM_DIRECTORY%" checkout "%LLVM_REV_TARGET%"

ARG LLVM_BUILD_DIRECTORY

RUN `
	cmake -S "%GIT_LLVM_DIRECTORY%\llvm" -B "%LLVM_BUILD_DIRECTORY%" -G "Visual Studio 17 2022" -T "ClangCL" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=lld;clang;clang-tools-extra -DLLVM_TARGETS_TO_BUILD=host -DLLVM_ENABLE_RUNTIMES=libcxx -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_INCLUDE_BENCHMARKS=ON -DLLVM_USE_SPLIT_DWARF=ON -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_ENABLE_ZLIB=OFF -DCMAKE_INSTALL_PREFIX="%LLVM_INSTALL_DIRECTORY%"

RUN `
	cmake --build "%LLVM_BUILD_DIRECTORY%" -j8 --config Release

ARG LLVM_INSTALL_DIRECTORY

RUN `
	cmake --install "%LLVM_BUILD_DIRECTORY%" --prefix "%LLVM_INSTALL_DIRECTORY%" --config Release `
	`
	&& setx PATH "%PATH%;%LLVM_INSTALL_DIRECTORY%\bin" /M

ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]