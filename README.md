# Compiler-Explorer-DXC-Windows-Docker

In hurry to compile your HLSL with latest DXC? Unfortunately [Godbolt](https://godbolt.org/) appears to be 3 months out of date again? Use this repository and host your own Compiler Explorer instance on your localhost with most recent DXC compiled from official https://github.com/microsoft/DirectXShaderCompiler!

## Requirements

- [Git]([Git - Downloading Package (git-scm.com)](https://git-scm.com/download/win))
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Enabled Hyper-V Windows feature](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-hyper-v-using-powershell)

## How to
Make sure you have switched to `Containers for Windows`

![Containers for Windows](https://user-images.githubusercontent.com/65064509/152947300-affca592-35a7-4e4c-a7fc-2055ce1ba528.png)

build a docker image given a [Dockerfile](https://github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker/blob/master/Dockerfile) from the repository (may take a while)

```bash
docker build github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker -t godbolt
```

run the docker container with proxied 10240 godbolt's port

```
docker run -p 10240:10240 -it godbolt 
```

and execute build script
```
build.bat --run-godbolt
```

once the script finishes open your browser with http://localhost:10240/ and enjoy compiling with most recent DXC

#### Build script arguments

The syntax is following

```bash
build.bat <BUILD_SCRIPT_OPTIONS> -- <CMAKE_BUILD_OPTIONS>
```

for example you may want update DXC & run godbolt but increase build jobs and verbosity, then you would execute

```
build.bat --run-godbolt -- -j8 -v
```

