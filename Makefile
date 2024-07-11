SPLIT_PLATFORM_ARGS :=

# Convert to swift run agruments.
ifeq ($(split-platform),true)
    SPLIT_PLATFORM_ARGS = enable-split-platform
endif

.PHONY: help build clean

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build [arguments]     Build the project for iOS and macOS"
	@echo "                        Arguments:"
	@echo "                            platforms=ios,macos      Only build specified platforms (ios,macos,tvos,tvsimulator,isimulator,maccatalyst)"
	@echo "                            split-platform=true      Enable split platform build (default: disabled)"
	@echo "  clean                 Clean the build artifacts"
	@echo "  help                  Display this help message"

build:
	swift run --build-path ./.build --package-path scripts build $(MAKEFLAGS) $(SPLIT_PLATFORM_ARGS)

clean:
	swift package --package-path scripts clean