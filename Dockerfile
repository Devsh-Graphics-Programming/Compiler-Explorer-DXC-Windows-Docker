# escape=`

# Set a default values for build variables if not specified
ARG BASE_IMAGE=mcr.microsoft.com/windows/servercore:ltsc2022-amd64
ARG GIT_INSTALL_DIRECTORY=C:/docker/dependencies/git
ARG PYTHON_INSTALL_DIRECTORY=C:/docker/dependencies/Python
ARG VS_INSTALL_DIRECTORY=%ProgramFiles(x86)%/Microsoft Visual Studio/2022/BuildTools

FROM ${BASE_IMAGE}

ARG VS_DEV_CMD_PATH=$VS_INSTALL_DIRECTORY/Common7/Tools/VsDevCmd.bat

# Set the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

RUN setx VS_DEV_CMD_PATH "$VS_DEV_CMD_PATH" /M

RUN `
	# Download Git for Windows.
	curl -SL --output git.zip https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/MinGit-2.41.0.3-64-bit.zip `
	`
	# Create git directory.
	&& mkdir "$GIT_INSTALL_DIRECTORY" `
	`
	# Unzip Git.
	&& tar -xf git.zip -C "$GIT_INSTALL_DIRECTORY" `
	`
	# Add Git to the system PATH and cleanup
	&& setx PATH "%PATH%;$GIT_INSTALL_DIRECTORY/cmd" /M `
	&& del /q git.zip

RUN `
	# Download the Build Tools bootstrapper.
	curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe `
	`
	# Install Build Tools with the Microsoft.VisualStudio.Workload.VCTools recommended workload and ATL & ATLMFC, excluding some Windows SDKs.
	&& (start /w vs_buildtools.exe --quiet --wait --norestart --nocache `
	--installPath "$VS_INSTALL_DIRECTORY" `
	--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended `
	--add Microsoft.VisualStudio.Component.VC.ATL `
	--add Microsoft.VisualStudio.Component.VC.ATLMFC `
	--remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
	--remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
	--remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
	--remove Microsoft.VisualStudio.Component.Windows81SDK `
	|| IF "%ERRORLEVEL%"=="3010" EXIT 0) `
 	`
  	# add VS's CMake to the system PATH and cleanup
	&& setx PATH "%PATH%;$VS_INSTALL_DIRECTORY/Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/bin" /M `
	&& del /q vs_buildtools.exe
	
RUN `
	# Download and install Python 3.9
	curl -SL --output python-installer.exe https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe `
	&& start /w python-installer.exe /quiet TargetDir="$PYTHON_INSTALL_DIRECTORY" Include_launcher=0 AddToPath=1 InstallAllUsers=1 PrependPath=1 `
	&& del /q python-installer.exe
	
RUN `
	# Download node LTS
	curl -SL --output nodejs.msi https://nodejs.org/dist/v20.9.0/node-v20.9.0-x64.msi `
	&& msiexec /i nodejs.msi /qn `
	&& del /q nodejs.msi

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["$VS_DEV_CMD_PATH", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
