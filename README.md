# Compiler-Explorer-DXC-Windows-Docker

> ⚠️ **Archived Repository Notice**
>
> This repository is **archived** and no longer maintained. 
> It has been replaced by [Devsh-Graphics-Programming/Compiler-Explorer-Docker](https://github.com/Devsh-Graphics-Programming/Compiler-Explorer-Docker).  

In hurry to compile your HLSL with latest DXC? Unfortunately [Godbolt](https://godbolt.org/) appears to be 3 months out of date again? Use this repository and host your own Compiler Explorer instance on your localhost with most recent DXC compiled from official https://github.com/microsoft/DirectXShaderCompiler!

## Requirements

- [Git](https://git-scm.com/download/win)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Enabled Hyper-V Windows feature](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-hyper-v-using-powershell)

## How to
### Build and run

Make sure you have switched to `Containers for Windows`

![Containers for Windows](https://user-images.githubusercontent.com/65064509/152947300-affca592-35a7-4e4c-a7fc-2055ce1ba528.png)

clone the repository 

```powershell
git clone git@github.com:Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker.git
```

enter the cloned directory and execute

```powershell
docker compose up --build
```

once everything is built and run - open your browser with **http://localhost:10240** and enjoy.

### Build script options

Instance image and a container use proxy batch script executing [***build***](https://github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker/blob/master/project/scripts/build.py) python script with following syntax

```powershell
<BUILD_SCRIPT_OPTIONS> -- <CMAKE_BUILD_OPTIONS>
```

you may wish to increase parallel build jobs and verbosity to build latest DXC while composing the application & running the container hence you would

```powershell
set BUILD_SCRIPT_ARGS="--run-godbolt -- -j12 -v"
```

first and then execute the compose command.
