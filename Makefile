all: build

.PHONY: debug
debug:
	flutter run --target-platform=android-arm64

.PHONY: build
build:
	flutter build apk --release

.PHONY: gen-json
gen-json:
	flutter packages pub run build_runner build
