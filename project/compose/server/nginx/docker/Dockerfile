# escape=`

ARG BASE_IMAGE=artifactory.devsh.eu/godbolt/base:latest

ARG NGINX_INSTALL_DIRECTORY
ARG THIS_PROJECT_SCRIPTS_DIRECTORY
ARG SERVER_NAME

FROM ${BASE_IMAGE}

SHELL ["cmd", "/S", "/C"]

ARG THIS_PROJECT_SCRIPTS_DIRECTORY

COPY docker\cmake\nginx\nginx.conf.cmake ${THIS_PROJECT_SCRIPTS_DIRECTORY}\cmake\nginx\nginx.conf.cmake

ARG NGINX_INSTALL_DIRECTORY
ARG SERVER_NAME

RUN `
	cmake -DOUTPUT_HLP_PATH="%NGINX_INSTALL_DIRECTORY%\conf\nginx.conf" -DSERVER_NAME="%SERVER_NAME%" -P "%THIS_PROJECT_SCRIPTS_DIRECTORY%\cmake\nginx\nginx.conf.cmake"

ENTRYPOINT ["VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]