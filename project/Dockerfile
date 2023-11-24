# escape=`

# Set a default values for build variables if not specified
ARG BASE_IMAGE=godboltBase
ARG GIT_GODBOLT_REPOSITORY_PATH=C:/docker/git/godbolt
ARG GIT_DXC_REPOSITORY_PATH=C:/docker/git/dxc
ARG BUILD_SCRIPT_DIRECTORY=C:/docker
ARG ON_IMAGE_INIT_BUILD_DXC=True

FROM ${BASE_IMAGE}

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Add docker directory to the system PATH
RUN `
	setx GIT_GODBOLT_REPOSITORY_PATH "$GIT_GODBOLT_REPOSITORY_PATH" /M `
	&& setx GIT_DXC_REPOSITORY_PATH "$GIT_DXC_REPOSITORY_PATH" /M `
	&& setx PATH "%PATH%;$BUILD_SCRIPT_DIRECTORY" /M

RUN `
	# Clone compiler-explorer and its submodules
	mkdir "$GIT_GODBOLT_REPOSITORY_PATH" `
	&& git clone https://github.com/compiler-explorer/compiler-explorer.git "$GIT_GODBOLT_REPOSITORY_PATH"
	
RUN `
	# npm godbolt project install
	cd "$GIT_GODBOLT_REPOSITORY_PATH" `
	&& npm install `
	&& npm install webpack -g `
	&& npm install webpack-cli -g `
	&& npm update webpack

RUN `
	# Clone DirectXShaderCompiler and its submodules
	&& mkdir "$GIT_DXC_REPOSITORY_PATH" `
	&& git clone https://github.com/microsoft/DirectXShaderCompiler.git "$GIT_DXC_REPOSITORY_PATH" `
	&& git -C "$GIT_DXC_REPOSITORY_PATH" submodule update --init --recursive `
	&& git config --global --add safe.directory "$GIT_DXC_REPOSITORY_PATH"

# Make build scripts available to a docker container
COPY scripts/build.bat $BUILD_SCRIPT_DIRECTORY/build.bat
COPY scripts/build.py $BUILD_SCRIPT_DIRECTORY/build.py

# Build DXC only if ON_IMAGE_INIT_BUILD_DXC is True (yes by default)
RUN IF /I "%ON_IMAGE_INIT_BUILD_DXC%"=="True" build.bat --on-init

# Make dxc.local.properties available to a docker container
COPY scripts/hlsl.local.properties "$GIT_GODBOLT_REPOSITORY_PATH/etc/config/hlsl.local.properties"

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]