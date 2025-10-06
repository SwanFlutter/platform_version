# Changelog

All notable changes to this project will be documented in this file.

The format is based on "Keep a Changelog" and this project follows Semantic Versioning.

## [Unreleased]

- Prepare initial documentation and examples.

## 0.0.1 - 2025-10-05

- Initial public release.
	- Add platform version API: `getPlatformVersion()`.
	- Add device information API: `getDeviceInfo()`.
	- Implementations for Android, iOS, Web, Windows, macOS and Linux.
	- Example app demonstrating basic usage (`example/lib/main.dart`).
	- Add README and tests scaffolding.

--

For details and contribution guidelines, see the project's `README.md` and `CONTRIBUTING.md` (if present).


## 0.0.2

### Changed
* **Android**: Lowered minimum SDK from API 24 (Android 7.0) to API 21 (Android 5.0)
  - Now supports Android 5.0 (Lollipop) through Android 16+
  - Updated `android/build.gradle` minSdk configuration
* **iOS**: Lowered minimum deployment target from iOS 13.0 to iOS 9.0
  - Now supports iOS 9.0 through latest iOS versions
  - Updated `ios/platform_version.podspec` platform requirement
  - Updated example project deployment target

### Documentation
* Updated README with comprehensive platform configuration guide
* Added Android minSdk verification instructions
* Added iOS deployment target setup guide
* Added permissions and privacy considerations
* Updated supported platforms table with new minimum versions