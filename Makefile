all: build

.PHONY: debug
debug:
	flutter run --target-platform=android-arm64

.PHONY: build
build:
	flutter build apk -t lib/main.prod.dart --target-platform android-arm,android-arm64,android-x64 --split-per-abi

.PHONY: gen-json
gen-json:
	flutter packages pub run build_runner build
