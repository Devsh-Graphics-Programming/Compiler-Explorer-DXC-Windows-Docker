# escape=`

ARG BASE_IMAGE=mcr.microsoft.com/windows/servercore:ltsc2022-amd64

ARG THIS_PROJECT_DIRECTORY="C:\docker"
ARG THIS_PROJECT_CLIENT_BIND_DIRECTORY="${THIS_PROJECT_DIRECTORY}\bind"
ARG THIS_PROJECT_GIT_REPOSITORIES_DIRECTORY="${THIS_PROJECT_DIRECTORY}\git"
ARG THIS_PROJECT_SYSTEM_PROGRAM_DIRECTORY="${THIS_PROJECT_DIRECTORY}\system"
ARG THIS_PROJECT_SCRIPTS_DIRECTORY="${THIS_PROJECT_DIRECTORY}\scripts"
ARG THIS_PROJECT_TOP_BUILD_DIRECTORY="${THIS_PROJECT_DIRECTORY}\build"
ARG THIS_PROJECT_CLIENT_BUILD_DIRECTORY="${THIS_PROJECT_CLIENT_BIND_DIRECTORY}\bind\build\client"
ARG THIS_PROJECT_CLIENT_INSTALL_DIRECTORY="${THIS_PROJECT_CLIENT_BIND_DIRECTORY}\bind\build\install"
ARG THIS_PROJECT_DEPENDENCY_BUILD_DIRECTORY="${THIS_PROJECT_TOP_BUILD_DIRECTORY}\3rdparty"

# Program & dependency settings
ARG GIT_INSTALL_DIRECTORY="${THIS_PROJECT_SYSTEM_PROGRAM_DIRECTORY}\git"
ARG PYTHON_INSTALL_DIRECTORY="${THIS_PROJECT_SYSTEM_PROGRAM_DIRECTORY}\Python"
ARG VS_INSTALL_DIRECTORY="${THIS_PROJECT_SYSTEM_PROGRAM_DIRECTORY}\BuildTools"
ARG VS_DEV_CMD_DIRECTORY="${VS_INSTALL_DIRECTORY}\Common7\Tools"

# Global clients' cached 3rdparty
ARG GIT_CJSON="${THIS_PROJECT_GIT_REPOSITORIES_DIRECTORY}\c-json"
ARG GIT_CJSON_BUILD_DIRECTORY="${THIS_PROJECT_DEPENDENCY_BUILD_DIRECTORY}\c-json"
ARG CJSON_INSTALL_DIRECTORY="${GIT_CJSON_BUILD_DIRECTORY}\install"
ARG GIT_SPIRV_HEADERS="${THIS_PROJECT_GIT_REPOSITORIES_DIRECTORY}\SPIRV-Headers"
ARG GIT_SPIRV_BUILD_DIRECTORY="${THIS_PROJECT_DEPENDENCY_BUILD_DIRECTORY}\SPIRV-Headers"
ARG SPIRV_HEADERS_INSTALL_DIRECTORY="${GIT_SPIRV_BUILD_DIRECTORY}\install"

# Godbolt server
ARG GIT_GODBOLT_REPOSITORY_PATH="${THIS_PROJECT_GIT_REPOSITORIES_DIRECTORY}\godbolt"

# CMake scripts
ARG CMAKE_SCRIPTS_DIRECTORY="${THIS_PROJECT_SCRIPTS_DIRECTORY}\cmake"

FROM ${BASE_IMAGE}

SHELL ["cmd", "/S", "/C"]

RUN `
	# Download node LTS
	`
	curl -SL --output nodejs.msi https://nodejs.org/dist/v20.9.0/node-v20.9.0-x64.msi `
	`
	&& msiexec /i nodejs.msi /qn `
	`
	&& del /q nodejs.msi

ARG VS_INSTALL_DIRECTORY

RUN `
	# Download the Build Tools bootstrapper.
	`
	curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe `
	`
	# Install Build Tools with the Microsoft.VisualStudio.Workload.VCTools recommended workload and ATL & ATLMFC, excluding some Windows SDKs.
	`
	&& (start /w vs_buildtools.exe --quiet --wait --norestart --nocache `
	--installPath "%VS_INSTALL_DIRECTORY%" `
	--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended `
	--add Microsoft.VisualStudio.Component.VC.ATL `
	--add Microsoft.VisualStudio.Component.VC.ATLMFC `
	--add Microsoft.VisualStudio.Component.VC.Llvm.Clang `
	--add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset `
	--remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
	--remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
	--remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
	--remove Microsoft.VisualStudio.Component.Windows81SDK `
	|| IF "%ERRORLEVEL%"=="3010" EXIT 0) `
 	`
  	# add VS's CMake to the system PATH and cleanup
	`
	&& setx PATH "%PATH%;%VS_INSTALL_DIRECTORY%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin" /M `
	`
	&& del /q vs_buildtools.exe

ARG PYTHON_INSTALL_DIRECTORY
	
RUN `
	# Download and install Python 3.9
	`
	curl -SL --output python-installer.exe https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe `
	`
	&& start /w python-installer.exe /quiet TargetDir="%PYTHON_INSTALL_DIRECTORY%" Include_launcher=0 AddToPath=1 InstallAllUsers=1 PrependPath=1 `
	`
	&& del /q python-installer.exe

ARG GIT_INSTALL_DIRECTORY

RUN `
	# Git
	`
	curl -SL --output git.zip https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/MinGit-2.41.0.3-64-bit.zip `
	`
	# Create git directory
	`
	&& mkdir "%GIT_INSTALL_DIRECTORY%" `
	`
	# Unzip Git
	`
	&& tar -xf git.zip -C "%GIT_INSTALL_DIRECTORY%" `
	`
	# Add Git to the system PATH and cleanup
	`
	&& setx PATH "%PATH%;%GIT_INSTALL_DIRECTORY%\cmd" /M `
	`
	&& del /q git.zip
	
ARG GIT_GODBOLT_REPOSITORY_PATH

RUN `
	# Compiler-Explorer
	`
	mkdir "%GIT_GODBOLT_REPOSITORY_PATH%" `
	`
	&& git clone https://github.com/compiler-explorer/compiler-explorer.git "%GIT_GODBOLT_REPOSITORY_PATH%" `
	`
	&& setx GIT_GODBOLT_REPOSITORY_PATH "%GIT_GODBOLT_REPOSITORY_PATH%" /M `
	`
	&& cd "%GIT_GODBOLT_REPOSITORY_PATH%" `
	`
	&& npm install `
	`
	&& npm install webpack -g `
	`
	&& npm install webpack-cli -g `
	`
	&& npm update webpack
	
ARG GIT_CJSON
ARG GIT_CJSON_BUILD_DIRECTORY
ARG CJSON_INSTALL_DIRECTORY

RUN `
	# c-json
	`
	mkdir "%GIT_CJSON%" `
	`
	&& git clone --depth=1 https://github.com/json-c/json-c.git "%GIT_CJSON%" `
	`
	&& cmake -S "%GIT_CJSON%" -B "%GIT_CJSON_BUILD_DIRECTORY%" -D "CMAKE_INSTALL_PREFIX=%CJSON_INSTALL_DIRECTORY%"` 
	`
	&& cmake --build "%GIT_CJSON_BUILD_DIRECTORY%" --config Release`
	`
	&& cmake --install "%GIT_CJSON_BUILD_DIRECTORY%" --prefix "%CJSON_INSTALL_DIRECTORY%" --config Release `
	`
	&& setx CJSON_INSTALL_DIRECTORY "%CJSON_INSTALL_DIRECTORY%" /M

ARG GIT_SPIRV_HEADERS
ARG GIT_SPIRV_BUILD_DIRECTORY
ARG SPIRV_HEADERS_INSTALL_DIRECTORY

RUN `
	# SPIRV-Headers
	`
	mkdir "%GIT_SPIRV_HEADERS%" `
	`
	&& git clone --depth=1 https://github.com/KhronosGroup/SPIRV-Headers "%GIT_SPIRV_HEADERS%" `
	`
	&& cmake -S "%GIT_SPIRV_HEADERS%" -B "%GIT_SPIRV_BUILD_DIRECTORY%" -DCMAKE_INSTALL_PREFIX="%SPIRV_HEADERS_INSTALL_DIRECTORY%" `
	`
	&& cmake --install "%GIT_SPIRV_BUILD_DIRECTORY%" --prefix "%SPIRV_HEADERS_INSTALL_DIRECTORY%" --config Release `
	`
	&& setx SPIRV_HEADERS_INSTALL_DIRECTORY "%SPIRV_HEADERS_INSTALL_DIRECTORY%" /M

RUN `
	git config --system --add safe.directory *

RUN `
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d 1 /f

ARG CMAKE_SCRIPTS_DIRECTORY	

RUN `
	setx CMAKE_SCRIPTS_DIRECTORY "%CMAKE_SCRIPTS_DIRECTORY%" /M

ARG VS_DEV_CMD_DIRECTORY
ARG THIS_PROJECT_CLIENT_BIND_DIRECTORY

RUN `
	setx PATH "%PATH%;%VS_DEV_CMD_DIRECTORY%;%THIS_PROJECT_CLIENT_BIND_DIRECTORY%" /M `
	`
	&& setx THIS_PROJECT_CLIENT_BIND_DIRECTORY "%THIS_PROJECT_CLIENT_BIND_DIRECTORY%" /M

ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]