@echo off
@setlocal

:: Get the directory where this platform proxy build script is located
set scriptDirectory=%~dp0

:: Change the current working directory to the build script
cd /d "%scriptDirectory%"

:: Execute implementation of the build script in Python
python -m %*