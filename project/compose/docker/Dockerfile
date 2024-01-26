# escape=`

ARG BASE_IMAGE=mcr.microsoft.com/windows/servercore:ltsc2022-amd64

# Globals
ARG THIS_PROJECT_PLATFORM
ARG THIS_PROJECT_ARCH
ARG THIS_PROJECT_DIRECTORY
ARG THIS_PROJECT_CLIENT_BIND_DIRECTORY
ARG THIS_PROJECT_GIT_REPOSITORIES_DIRECTORY
ARG THIS_PROJECT_SYSTEM_PROGRAM_DIRECTORY
ARG THIS_PROJECT_SCRIPTS_DIRECTORY
ARG THIS_PROJECT_TOP_BUILD_DIRECTORY
ARG THIS_PROJECT_CLIENT_BUILD_DIRECTORY
ARG THIS_PROJECT_CLIENT_INSTALL_DIRECTORY
ARG THIS_PROJECT_DEPENDENCY_BUILD_DIRECTORY

# Program & dependency settings
ARG GIT_INSTALL_DIRECTORY
ARG PYTHON_INSTALL_DIRECTORY
ARG VS_INSTALL_DIRECTORY
ARG VULKAN_SDK_INSTALL_DIRECTORY
ARG VS_DEV_CMD_DIRECTORY
ARG NGINX_INSTALL_DIRECTORY

# Godbolt server
ARG GIT_GODBOLT_REPOSITORY_PATH

FROM ${BASE_IMAGE}

SHELL ["cmd", "/S", "/C"]

RUN `
	# Node LTS
	`
	curl -SL --output nodejs.msi https://nodejs.org/dist/v20.9.0/node-v20.9.0-x64.msi `
	`
	&& msiexec /i nodejs.msi /qn `
	`
	&& del /q nodejs.msi

ARG VS_INSTALL_DIRECTORY

RUN `
	# Build Tools bootstrapper.
	`
	curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe `
	`
	# Build Tools with the Microsoft.VisualStudio.Workload.VCTools recommended workload and ATL & ATLMFC, excluding some Windows SDKs.
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
	&& setx PATH "%PATH%;%VS_INSTALL_DIRECTORY%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin" /M `
	`
	&& del /q vs_buildtools.exe

ARG VULKAN_SDK_INSTALL_DIRECTORY

RUN `
	# VulkanSDK
	`
	curl -SL --output VulkanSDK-Installer.exe https://sdk.lunarg.com/sdk/download/1.3.268.0/windows/VulkanSDK-1.3.268.0-Installer.exe `
	`
	&& VulkanSDK-Installer.exe install --root "%VULKAN_SDK_INSTALL_DIRECTORY%" --default-answer --accept-licenses --confirm-command `
	`
	&& del /q VulkanSDK-Installer.exe

ARG PYTHON_INSTALL_DIRECTORY
	
RUN `
	# Python
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
	&& mkdir "%GIT_INSTALL_DIRECTORY%" `
	`
	&& tar -xf git.zip -C "%GIT_INSTALL_DIRECTORY%" `
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
	&& git clone https://github.com/Devsh-Graphics-Programming/compiler-explorer.git "%GIT_GODBOLT_REPOSITORY_PATH%" `
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

ARG NGINX_INSTALL_DIRECTORY

RUN `
	# Nginx
	`
	curl -SL --output nginx.zip https://nginx.org/download/nginx-1.25.3.zip `
	`
	&& mkdir "%NGINX_INSTALL_DIRECTORY%" `
	`
	&& tar -xf nginx.zip -C "%NGINX_INSTALL_DIRECTORY%" `
	`
	&& cmake -E copy_directory "%NGINX_INSTALL_DIRECTORY%\nginx-1.25.3" "%NGINX_INSTALL_DIRECTORY%" `
	`
	&& cmake -E rm -Rf -- "%NGINX_INSTALL_DIRECTORY%\nginx-1.25.3" `
	`
	&& setx PATH "%PATH%;%NGINX_INSTALL_DIRECTORY%" /M `
	`
	&& setx NGINX_INSTALL_DIRECTORY "%NGINX_INSTALL_DIRECTORY%" /M `
	`
	&& del /q nginx.zip

RUN `
	git config --system --add safe.directory *

RUN `
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d 1 /f

ARG VS_DEV_CMD_DIRECTORY
ARG THIS_PROJECT_CLIENT_BIND_DIRECTORY

RUN `
	setx PATH "%PATH%;%VS_DEV_CMD_DIRECTORY%;%THIS_PROJECT_CLIENT_BIND_DIRECTORY%" /M

ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]