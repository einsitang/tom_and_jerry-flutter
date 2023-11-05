# tom_and_jerry

tom and jerry flutter app

this is opensource flutter project just for fun's, not an official Disney app

## Depend

- dart SDK: '>=2.18.6 <3.0.0' // Null-Safety
- flutter SDK: '^3.0.0'
- jdk 11
- NIM SDK (网易即时通讯SDK) - https://doc.yunxin.163.com/messaging/docs/home-page?platform=flutter
- AMAP SDK (高德地图SDK) - https://lbs.amap.com/api/flutter/gettingstarted

## Build

### prebuild

```
flutter pub get
```

copy `.env.example` to `.env`
```
cp .env.example .env
```
configuration `.env` with cloud appkey

and use `builld_runner` make env work

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
