# escape=`

# Use the latest Windows Server Core 20H2-amd64 image.
FROM mcr.microsoft.com/windows/servercore:20H2-amd64

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Install programs and dependencies
RUN `
	# Download Git for Windows.
    curl -SL --output git.zip https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/MinGit-2.41.0.3-64-bit.zip `
    `
	# Create C:/git directory.
    && mkdir "C:/git" `
	`
	# Unzip Git.
    && tar -xf git.zip -C C:/git `
    `
	# Add Git to the system PATH.
    && setx PATH "%PATH%;C:/git/cmd" /M `
    `
    # Cleanup - remove the downloaded zip file.
    && del /q git.zip `
    `
    # Download the Build Tools bootstrapper.
    && curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe `
    `
    # Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
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
    # Cleanup
    && del /q vs_buildtools.exe `
	`
	# Download and install Python 3.9
    && curl -SL --output python-installer.exe https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe `
    && start /w python-installer.exe /quiet TargetDir=C:\Python39 Include_launcher=0 AddToPath=1 InstallAllUsers=1 PrependPath=1 `
    && del /q python-installer.exe `
	`
	# Download node LTS
	`
	&& curl -SL --output nodejs.msi https://nodejs.org/dist/v20.9.0/node-v20.9.0-x64.msi `
    && msiexec /i nodejs.msi /qn `
    && del /q nodejs.msi
	
# Clone git repositories
RUN `
	# Clone compiler-explorer and its submodules
	mkdir "C:/godbolt" `
	&& "C:/git/cmd/git" clone https://github.com/compiler-explorer/compiler-explorer.git ./godbolt `
	`
	# Clone DirectXShaderCompiler and its submodules
	&& mkdir "C:/dxc" `
	&& "C:/git/cmd/git" clone https://github.com/microsoft/DirectXShaderCompiler.git ./dxc `
	&& "C:/git/cmd/git" -C ./dxc submodule update --init --recursive `
	&& "C:/git/cmd/git" config --global --add safe.directory C:/dxc
	
# Make build.bat available to a docker container
COPY build.bat.docker C:/build.bat

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
