# escape=`

ARG BASE_IMAGE=artifactory.devsh.eu/services/godbolt.base:latest

ARG BUILD_SCRIPT_DIRECTORY="C:\docker"
ARG BUILD_SCRIPT_ARGS="-- -j1"

FROM ${BASE_IMAGE}

SHELL ["cmd", "/S", "/C"]

ARG BUILD_SCRIPT_DIRECTORY

RUN `
	setx PATH "%PATH%;%BUILD_SCRIPT_DIRECTORY%" /M `
	&& setx BUILD_SCRIPT_DIRECTORY "%BUILD_SCRIPT_DIRECTORY%" /M

# Make build scripts available to a docker container
COPY scripts\build.bat "$BUILD_SCRIPT_DIRECTORY\build.bat"
COPY scripts\build.py "$BUILD_SCRIPT_DIRECTORY\build.py"

ARG BUILD_SCRIPT_ARGS

# Build DXC
RUN `
	build.bat %BUILD_SCRIPT_ARGS%

# Generate dxc.local.properties
RUN `
	cmake "-DOUTPUT_HLP_PATH=%GIT_GODBOLT_REPOSITORY_PATH%\etc\config\hlsl.local.properties" "-DBUILD_SCRIPT_DIRECTORY=%BUILD_SCRIPT_DIRECTORY%" -P "%CMAKE_SCRIPTS_DIRECTORY%\hlsl.local.properties.cmake"

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass", "-Command", "build.bat"]