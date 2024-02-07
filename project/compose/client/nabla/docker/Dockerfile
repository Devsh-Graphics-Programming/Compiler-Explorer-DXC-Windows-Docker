# escape=`

ARG BASE_IMAGE=artifactory.devsh.eu/godbolt/base:latest

ARG _NBL_JOBS_AMOUNT_
ARG NABLA_REV_TARGET
ARG GIT_NABLA_DIRECTORY
ARG NABLA_BUILD_DIRECTORY
ARG NABLA_INSTALL_DIRECTORY
ARG THIS_PROJECT_SCRIPTS_DIRECTORY
ARG GIT_GODBOLT_REPOSITORY_PATH

FROM ${BASE_IMAGE}

SHELL ["cmd", "/S", "/C"]

RUN `
	powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))	

RUN `
	choco install -y strawberryperl --version 5.28.2.1

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

ARG NABLA_BUILD_DIRECTORY
ARG NABLA_INSTALL_DIRECTORY
ARG _NBL_JOBS_AMOUNT_

RUN	`
	cmake -S "%GIT_NABLA_DIRECTORY%" --preset ci-configure-static-msvc -DNBL_BUILD_EXAMPLES=OFF -D_NBL_JOBS_AMOUNT_=%_NBL_JOBS_AMOUNT_% `
	`
	&& cmake --build "%GIT_NABLA_DIRECTORY%\build\static\tools\nsc" --target nsc --config Release `
	`
	&& cmake --build "%GIT_NABLA_DIRECTORY%\build\static\tools\nsc" --target nsc --config Debug `
 	`
  	&& cmake -E rm -Rf -- "%GIT_NABLA_DIRECTORY%\build"


ARG GIT_GODBOLT_REPOSITORY_PATH

RUN `
	# Compiler-Explorer update (TMP!!!!)
	`
	cd "%GIT_GODBOLT_REPOSITORY_PATH%" `
	`
	&& git fetch --depth=1 -- origin main `
	`
	&& git checkout -f origin/main ` 
	`
 	&& npm install

ARG THIS_PROJECT_SCRIPTS_DIRECTORY

COPY client\nabla\docker\cmake\hlsl.local.properties.cmake ${THIS_PROJECT_SCRIPTS_DIRECTORY}\cmake\hlsl.local.properties.cmake

RUN `
	cmake -DOUTPUT_HLP_PATH="%GIT_GODBOLT_REPOSITORY_PATH%\etc\config\hlsl.local.properties" -P "%THIS_PROJECT_SCRIPTS_DIRECTORY%\cmake\hlsl.local.properties.cmake"

ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
