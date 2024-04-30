# escape=`

ARG BASE_IMAGE=artifactory.devsh.eu/godbolt/base:latest

ARG VS_VCVARSALL_DIRECTORY
ARG _NBL_JOBS_AMOUNT_
ARG NABLA_REV_TARGET
ARG GIT_NABLA_DIRECTORY
ARG NABLA_BUILD_DIRECTORY
ARG NABLA_INSTALL_DIRECTORY
ARG THIS_PROJECT_SCRIPTS_DIRECTORY
ARG GIT_GODBOLT_REPOSITORY_PATH

FROM ${BASE_IMAGE} as NBL_I_CMAKE_IMAGE
SHELL ["cmd", "/S", "/C"]

RUN `
	# CMake override
	`
	curl -SL --output cmake.zip https://github.com/Kitware/CMake/releases/download/v3.29.2/cmake-3.29.2-windows-x86_64.zip `
	`
	&& mkdir "./cmake" `
	`
	&& tar -xf cmake.zip -C "./cmake" `
	`
	&& del /q cmake.zip

FROM NBL_I_CMAKE_IMAGE as NBL_I_BUILD_IMAGE
SHELL ["cmd", "/S", "/C"]

ARG GIT_NABLA_DIRECTORY
ARG NABLA_REV_TARGET

RUN `
	git config --system protocol.*.allow always`
    `
    && git config --system url."https://github.com/".insteadOf "git@github.com:"

RUN `
	mkdir "%GIT_NABLA_DIRECTORY%" `
	`
	&& git -C "%GIT_NABLA_DIRECTORY%" init `
	`
	&& git -C "%GIT_NABLA_DIRECTORY%" remote add origin https://github.com/Devsh-Graphics-Programming/Nabla.git `
	`
	&& git -C "%GIT_NABLA_DIRECTORY%" fetch --depth=1 -- origin %NABLA_REV_TARGET% `
	`
	&& git -C "%GIT_NABLA_DIRECTORY%" checkout %NABLA_REV_TARGET% `
	`
	&& cmake -DNBL_BUILD_EXAMPLES=OFF -P "%GIT_NABLA_DIRECTORY%\cmake\submodules\update.cmake"

ARG VS_VCVARSALL_DIRECTORY
ARG NABLA_BUILD_DIRECTORY
ARG NABLA_INSTALL_DIRECTORY
ARG _NBL_JOBS_AMOUNT_

ENV NBL_CI_MODE=ON
ENV NBL_CI_BUILD_DIRECTORY=build/static

RUN	`
	cd cmake/cmake-3.29.2-windows-x86_64/bin `
	`
	&& cmake --version `
	`
	&& "%VS_VCVARSALL_DIRECTORY%\vcvarsall.bat" x64 `
	`
	&& cmake -S "%GIT_NABLA_DIRECTORY%" --preset ci-configure-static-msvc -DNBL_BUILD_EXAMPLES=OFF -D_NBL_JOBS_AMOUNT_=%_NBL_JOBS_AMOUNT_% `
	`
	&& cmake --build "%GIT_NABLA_DIRECTORY%\build\static\tools\nsc" --target nsc --config Release `
	`
	&& cmake --build "%GIT_NABLA_DIRECTORY%\build\static\tools\nsc" --target nsc --config Debug `
	`
	&& cmake --install "%GIT_NABLA_DIRECTORY%\build\static" --prefix "%GIT_NABLA_DIRECTORY%/install" --config Release --component Runtimes `
	`
	&& cmake --install "%GIT_NABLA_DIRECTORY%\build\static" --prefix "%GIT_NABLA_DIRECTORY%/install" --config Release --component Executables `
	`
	&& cmake --install "%GIT_NABLA_DIRECTORY%\build\static" --prefix "%GIT_NABLA_DIRECTORY%/install" --config Debug --component Runtimes `
	`
	&& cmake --install "%GIT_NABLA_DIRECTORY%\build\static" --prefix "%GIT_NABLA_DIRECTORY%/install" --config Debug --component Executables `
	`
  	&& cmake -E rm -Rf -- "%GIT_NABLA_DIRECTORY%\build"

FROM ${BASE_IMAGE}
SHELL ["cmd", "/S", "/C"]

ARG GIT_NABLA_DIRECTORY
ARG NABLA_REV_TARGET

COPY --from=NBL_I_BUILD_IMAGE ${GIT_NABLA_DIRECTORY}\install\ ${GIT_NABLA_DIRECTORY}\install\

ARG THIS_PROJECT_SCRIPTS_DIRECTORY

COPY client\nabla\docker\cmake\hlsl.local.properties.cmake ${THIS_PROJECT_SCRIPTS_DIRECTORY}\cmake\hlsl.local.properties.cmake

ARG GIT_GODBOLT_REPOSITORY_PATH

RUN `
	cd "%GIT_NABLA_DIRECTORY%/install" `
	`
	&& dir `
	`
	&& cmake -DNABLA_REV_TARGET="%NABLA_REV_TARGET%" -DOUTPUT_HLP_PATH="%GIT_GODBOLT_REPOSITORY_PATH%\etc\config\hlsl.local.properties" -P "%THIS_PROJECT_SCRIPTS_DIRECTORY%\cmake\hlsl.local.properties.cmake"

ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
