# escape=`

ARG BASE_IMAGE=artifactory.devsh.eu/godbolt/llvm:latest

ARG GIT_CJSON
ARG GIT_CJSON_BUILD_DIRECTORY
ARG CJSON_INSTALL_DIRECTORY
ARG GIT_SPIRV_HEADERS
ARG GIT_SPIRV_BUILD_DIRECTORY
ARG SPIRV_HEADERS_INSTALL_DIRECTORY
ARG GIT_SHADY_DIRECTORY
ARG SHADY_BUILD_DIRECTORY
ARG SHADY_INSTALL_DIRECTORY
ARG SHADY_REV_TARGET
ARG THIS_PROJECT_SCRIPTS_DIRECTORY
ARG GIT_GODBOLT_REPOSITORY_PATH

FROM ${BASE_IMAGE}

SHELL ["cmd", "/S", "/C"]

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

ARG GIT_SHADY_DIRECTORY
ARG SHADY_REV_TARGET

RUN `
	mkdir "%GIT_SHADY_DIRECTORY%" `
	`
	&& git -C "%GIT_SHADY_DIRECTORY%" init `
	`
	&& git -C "%GIT_SHADY_DIRECTORY%" remote add origin https://github.com/Devsh-Graphics-Programming/shady.git `
	`
	&& git -C "%GIT_SHADY_DIRECTORY%" fetch --depth=1 -- origin %SHADY_REV_TARGET% `
	`
	&& git -C "%GIT_SHADY_DIRECTORY%" checkout %SHADY_REV_TARGET% `
	`
	&& git -C "%GIT_SHADY_DIRECTORY%" submodule update --init --recursive

ARG SHADY_BUILD_DIRECTORY
ARG SHADY_INSTALL_DIRECTORY

RUN	`
	cmake -S "%GIT_SHADY_DIRECTORY%" -B "%SHADY_BUILD_DIRECTORY%" -G "Visual Studio 17 2022" -DCMAKE_BUILD_TYPE=Release -DLLVM_DIR="%LLVM_INSTALL_DIRECTORY%\lib\cmake\llvm" -DSPIRV-Headers_DIR="%SPIRV_HEADERS_INSTALL_DIRECTORY%\share\cmake\SPIRV-Headers" -Djson-c_DIR="%CJSON_INSTALL_DIRECTORY%\lib\cmake\json-c" -DCMAKE_INSTALL_PREFIX="%SHADY_INSTALL_DIRECTORY%"
	
RUN	`
	cmake --build "%SHADY_BUILD_DIRECTORY%" --config Release
	
RUN	`
	cmake --install "%SHADY_BUILD_DIRECTORY%" --prefix "%SHADY_INSTALL_DIRECTORY%" --config Release `
	` 
	&& cmake -E copy_directory "%SHADY_BUILD_DIRECTORY%\bin\Release" "%SHADY_INSTALL_DIRECTORY%\bin"

ARG THIS_PROJECT_SCRIPTS_DIRECTORY

COPY client\shady\docker\cmake\c++.local.properties.cmake ${THIS_PROJECT_SCRIPTS_DIRECTORY}\cmake\c++.local.properties.cmake

ARG GIT_GODBOLT_REPOSITORY_PATH

RUN `
	cmake -DOUTPUT_HLP_PATH="%GIT_GODBOLT_REPOSITORY_PATH%\etc\config\c++.local.properties" -DVCC_EXECUTABLE="%SHADY_INSTALL_DIRECTORY%\bin\vcc.exe" -P "%THIS_PROJECT_SCRIPTS_DIRECTORY%\cmake\c++.local.properties.cmake" `
	`
	&& cmake -E rm -Rf -- "%GIT_GODBOLT_REPOSITORY_PATH%\examples\c++"

COPY client\shady\docker\examples\default.cpp ${GIT_GODBOLT_REPOSITORY_PATH}\examples\c++\default.cpp

ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]