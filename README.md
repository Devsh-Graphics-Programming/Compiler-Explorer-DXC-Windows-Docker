# Compiler-Explorer-DXC-Windows-Docker

In hurry to compile your HLSL with latest DXC? Unfortunately [Godbolt](https://godbolt.org/) appears to be 3 months out of date again? Use this repository and host your own Compiler Explorer instance on your localhost with most recent DXC compiled from official https://github.com/microsoft/DirectXShaderCompiler!

## Requirements

- [Git](https://git-scm.com/download/win)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Enabled Hyper-V Windows feature](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-hyper-v-using-powershell)

## How to
### Build and run

Make sure you have switched to `Containers for Windows`

![Containers for Windows](https://user-images.githubusercontent.com/65064509/152947300-affca592-35a7-4e4c-a7fc-2055ce1ba528.png)

build [***base***](https://github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker/blob/master/Dockerfile) docker image

```powershell
docker build github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker -t godbolt.base
```

build [***instance***](https://github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker/blob/master/project/Dockerfile) docker image

```powershell
docker build github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker#master:project -t godbolt.instace --build-arg BASE_IMAGE=godbolt.base --build-arg BUILD_SCRIPT_ARGS="-- -j4"
```

run your instance docker container with proxied 10240 port CE listens on

```powershell
docker run -p 10240:10240 -it godbolt.instance --run-godbolt
```

open your browser with **http://localhost:10240** and enjoy.

### Image creation arguments

There are a few OS-wide variables you can override for building images, you can also override `BUILD_SCRIPT_ARGS` to execute initial [***build***](https://github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker/blob/master/project/scripts/build.py) script with different set of arguments - refer to base & instance docker files and build script syntax bellow for more details.

### Container creation arguments

Containers created from the instance image have `ENTRYPOINT` set to application proxy batch script executing [***build***](https://github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker/blob/master/project/scripts/build.py) python script, the syntax is following

```powershell
<BUILD_SCRIPT_OPTIONS> -- <CMAKE_BUILD_OPTIONS>
```

for example you may wish to run container with increased parallel build jobs and verbosity to build latest DXC but don't want to run compiler explorer with it hence you would execute

```powershell
docker run -p 10240:10240 -it godbolt.instance -- -j12 -v
```

