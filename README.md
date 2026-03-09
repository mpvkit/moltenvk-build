# moltenvk-build

[![GitHub Release](https://img.shields.io/github/v/release/mpvkit/moltenvk-build)](https://github.com/mpvkit/moltenvk-build/releases)
![license](https://img.shields.io/github/license/mpvkit/moltenvk-build)

build scripts for [moltenvk](https://github.com/KhronosGroup/MoltenVK)

> This is a component of the [MPVKit](https://github.com/mpvkit/MPVKit) project.
> Build automation is shared via [mpvkit/BuildShared](https://github.com/mpvkit/BuildShared).


## Installation

### Swift Package Manager

```
https://github.com/mpvkit/moltenvk-build.git
```

## How to build

```bash
make build
# specified platforms (ios,macos,tvos,tvsimulator,isimulator,maccatalyst,xros,xrsimulator)
make build platform=ios,macos
# build GPL version
make build enable-gpl
# clean all build temp files and cache
make clean
# see help
make help
```
