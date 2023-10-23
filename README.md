# tom_and_jerry

tom and jerry flutter app

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Depend

- dart SDK: '>=2.18.6 <3.0.0' // Null-Safety
- flutter SDK: '^3.0.0'
- jdk 11

## Build

### prebuild

```
flutter pub get
```

copy `.env.example` to `.env`
```
cp .env.example .env
```
change `.env` configuration and use `builld_runner` make env work

```shell
flutter pub run build_runner build
```

### build-app

```
# build android
flutter build apk

# build ios
flutter build ios
```
