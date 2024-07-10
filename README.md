# moltenvk-build

build scripts for [moltenvk](https://github.com/KhronosGroup/MoltenVK)

## Installation

### Swift Package Manager

```
https://github.com/mpvkit/moltenvk-build.git
```

## How to build

```bash
swift run --package-path scripts
```

or 

```bash
# deployment platform: macos,ios,tvos,maccatalyst
swift run --package-path scripts build platforms=ios,macos
```