# escape=`

# Use the latest Windows Server Core with ltsc2022-amd64 tag
FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

RUN `
	# Download Git for Windows.
	curl -SL --output git.zip https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/MinGit-2.41.0.3-64-bit.zip `
	`
	# Create git directory.
	&& mkdir "C:/docker/dependencies/git" `
	`
	# Unzip Git.
	&& tar -xf git.zip -C C:/docker/dependencies/git `
	`
	# Add Git to the system PATH and cleanup
	&& setx PATH "%PATH%;C:/docker/dependencies/git/cmd" /M `
	&& del /q git.zip
    
RUN `
	# Download the Build Tools bootstrapper.
	curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe `
	`
	# Install Build Tools with the Microsoft.VisualStudio.Workload.VCTools recommended workload and ATL & ATLMFC, excluding some Windows SDKs.
	&& (start /w vs_buildtools.exe --quiet --wait --norestart --nocache `
	--installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" `
	--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended `
	--add Microsoft.VisualStudio.Component.VC.ATL `
	--add Microsoft.VisualStudio.Component.VC.ATLMFC `
	--remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
	--remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
	--remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
	--remove Microsoft.VisualStudio.Component.Windows81SDK `
	|| IF "%ERRORLEVEL%"=="3010" EXIT 0) `
 	`
  	# add CMake to the system PATH and cleanup
	&& setx PATH "%PATH%;C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/bin" /M `
	&& del /q vs_buildtools.exe
	
RUN `
	# Download and install Python 3.9
	curl -SL --output python-installer.exe https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe `
	&& start /w python-installer.exe /quiet TargetDir=C:\docker\dependencies\Python39 Include_launcher=0 AddToPath=1 InstallAllUsers=1 PrependPath=1 `
	&& del /q python-installer.exe
	
RUN `
	# Download node LTS
	curl -SL --output nodejs.msi https://nodejs.org/dist/v20.9.0/node-v20.9.0-x64.msi `
	&& msiexec /i nodejs.msi /qn `
	&& del /q nodejs.msi
	
RUN `
	# Clone compiler-explorer and its submodules
	mkdir "C:/docker/git/godbolt" `
	&& git clone https://github.com/compiler-explorer/compiler-explorer.git ./docker/git/godbolt `
	`
	# Clone DirectXShaderCompiler and its submodules
	&& mkdir "C:/docker/git/dxc" `
	&& git clone https://github.com/microsoft/DirectXShaderCompiler.git ./docker/git/dxc `
	&& git -C ./docker/git/dxc submodule update --init --recursive `
	&& git config --global --add safe.directory C:/docker/git/dxc

RUN `
	# npm godbolt project install
	cd "C:/docker/git/godbolt" `
	&& npm install `
	&& npm install webpack -g `
	&& npm install webpack-cli -g `
	&& npm update webpack

# Make build scripts available to a docker container
COPY scripts/build.bat C:/docker/build.bat
COPY scripts/build.py C:/docker/build.py

# Add docker directory to the system PATH
RUN `
	setx PATH "%PATH%;C:/docker" /M 

# Build DXC
RUN `
	build.bat --on-init

# Make dxc.local.properties available to a docker container
COPY scripts/hlsl.local.properties C:/docker/git/godbolt/etc/config/hlsl.local.properties

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
