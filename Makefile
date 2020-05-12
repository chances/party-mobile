all: build

.PHONY: debug
debug:
	flutter run --target-platform=android-arm64

AUTH_ZERO_DOMAIN := $(AUTH_ZERO_DOMAIN)
AUTH_ZERO_CLIENT_ID := $(AUTH_ZERO_CLIENT_ID)
AUTH_ZERO_AUDIENCE := $(AUTH_ZERO_AUDIENCE)

.PHONY: run
run:
	@flutter run \
		--dart-define=AUTH_ZERO_DOMAIN=$(AUTH_ZERO_DOMAIN) \
		--dart-define=AUTH_ZERO_CLIENT_ID=$(AUTH_ZERO_CLIENT_ID) \
		--dart-define=AUTH_ZERO_AUDIENCE=$(AUTH_ZERO_AUDIENCE)

.PHONY: build
build:
	flutter build apk -t lib/main.prod.dart \
		--dart-define=AUTH_ZERO_DOMAIN=$(AUTH_ZERO_DOMAIN) \
		--dart-define=AUTH_ZERO_CLIENT_ID=$(AUTH_ZERO_CLIENT_ID) \
		--dart-define=AUTH_ZERO_AUDIENCE=$(AUTH_ZERO_AUDIENCE) \
		--target-platform android-arm,android-arm64,android-x64 \
		--split-per-abi

.PHONY: gen-json
gen-json:
	flutter packages pub run build_runner build --delete-conflicting-outputs
