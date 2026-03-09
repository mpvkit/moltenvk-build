# moltenvk-build

[![GitHub Release](https://img.shields.io/github/v/release/mpvkit/moltenvk-build)](https://github.com/mpvkit/moltenvk-build/releases)
![license](https://img.shields.io/github/license/mpvkit/moltenvk-build)

build scripts for [moltenvk](https://github.com/KhronosGroup/MoltenVK)

> This is a component of the [MPVKit](https://github.com/mpvkit/MPVKit) project.
> Shared build logic and reusable GitHub Actions are provided by [mpvkit/BuildShared](https://github.com/mpvkit/BuildShared).


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

The Swift build entrypoint in `Sources/BuildScripts` depends on `BuildShared`, and the workflows in `.github/workflows` delegate to reusable workflows from the same repository.
