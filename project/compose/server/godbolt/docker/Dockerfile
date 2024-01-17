# escape=`

ARG BASE_IMAGE=artifactory.devsh.eu/godbolt/base:latest

ARG NGINX_PROXY_DXC_SERVER_NAME
ARG NGINX_PROXY_VCC_SERVER_NAME
ARG THIS_PROJECT_SCRIPTS_DIRECTORY
ARG GIT_GODBOLT_REPOSITORY_PATH

FROM ${BASE_IMAGE}

SHELL ["cmd", "/S", "/C"]

ARG THIS_PROJECT_SCRIPTS_DIRECTORY
ARG GIT_GODBOLT_REPOSITORY_PATH

COPY docker\cmake\hlsl.local.properties.cmake ${THIS_PROJECT_SCRIPTS_DIRECTORY}\cmake\hlsl.local.properties.cmake

ARG NGINX_PROXY_DXC_SERVER_NAME

RUN `
	cmake -DOUTPUT_HLP_PATH="%GIT_GODBOLT_REPOSITORY_PATH%\etc\config\hlsl.local.properties" -DSERVER=ON -DSERVER_NAME="%NGINX_PROXY_DXC_SERVER_NAME%" -P "%THIS_PROJECT_SCRIPTS_DIRECTORY%\cmake\hlsl.local.properties.cmake"

COPY docker\cmake\c++.local.properties.cmake ${THIS_PROJECT_SCRIPTS_DIRECTORY}\cmake\c++.local.properties.cmake

ARG NGINX_PROXY_VCC_SERVER_NAME

RUN `
	cmake -DOUTPUT_HLP_PATH="%GIT_GODBOLT_REPOSITORY_PATH%\etc\config\c++.local.properties" -DSERVER=ON -DSERVER_NAME="%NGINX_PROXY_VCC_SERVER_NAME%" -P "%THIS_PROJECT_SCRIPTS_DIRECTORY%\cmake\c++.local.properties.cmake"


ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]