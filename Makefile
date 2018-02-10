all: build

.PHONY: debug
debug:
	flutter run --target-platform=android-arm64

.PHONY: build
build:
	flutter build apk --release

.PHONY: gen-json
gen-json:
	flutter packages pub global run owl_codegen:main -t json -p party -g \
		'lib/models/**/*.dart,lib/models/*.dart,lib/api/errors.dart'
