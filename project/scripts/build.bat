@echo off
@setlocal

:: Get the directory where this script is located
set scriptDirectory=%~dp0

:: Change the current working directory to the script directory
cd /d %scriptDirectory%

:: Execute implementation of the build script in pyhon
python ./build.py %*