# Compiler-Explorer-DXC-Windows-Docker

In hurry to compile your HLSL with latest DXC? Unfortunately [Godbolt](https://godbolt.org/) appears to be 3 months out of date again? Use this repository and host your own Compiler Explorer instance on your localhost with most recent DXC compiled from official https://github.com/microsoft/DirectXShaderCompiler!

## Requirements
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Enabled Hyper-V Windows feature](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-hyper-v-using-powershell)

## How to
Make sure you have switched to `Containers for Windows`

![Containers for Windows](https://user-images.githubusercontent.com/65064509/152947300-affca592-35a7-4e4c-a7fc-2055ce1ba528.png)

clone this repository

```bash
git clone https://github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker.git
```

build a docker image given a [Dockerfile](https://github.com/Devsh-Graphics-Programming/Compiler-Explorer-DXC-Windows-Docker/blob/master/Dockerfile) from the repository (may take a while)

```bash
cd Compiler-Explorer-DXC-Windows-Docker
docker build -t godbolt:latest -m 3GB .
```

run the docker container

```
docker run -it godbolt
```

and execute build script
```
./docker/build.bat
```

once the script finishes open your browser with http://localhost:10240/ and enjoy compiling with most recent DXC
