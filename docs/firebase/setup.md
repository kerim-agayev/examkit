# Firebase Proje Yapılandırması

## Proje Bilgileri

| Alan | Değer |
|---|---|
| **Project ID** | `examkit-5e691` |
| **Project Number** | `25418653005` |
| **RTDB URL** | `https://examkit-5e691-default-rtdb.europe-west1.firebasedatabase.app` |
| **Billing** | Aktif (Spark plan — ücretsiz) |
| **Owner** | `bahrikonak454@gmail.com` |

## Android App

| Alan | Değer |
|---|---|
| **App ID** | `1:25418653005:android:b3e8355c8e9b0ee08eeb04` |
| **Package** | `com.examkit.app` |
| **SHA-1** | `1A:B3:A6:ED:5C:3F:B9:28:55:E3:C3:1D:E6:48:E8:55:42:E4:9F:25` |
| **Config** | `flutter_app/android/app/google-services.json` |

## Web App

| Alan | Değer |
|---|---|
| **App ID** | `1:25418653005:web:63048242ac3e4cef8eeb04` |
| **Domain** | `examkit-beta.vercel.app` |
| **Config** | `student_web/.env.local` |

## Deploy Komutları

```bash
# RTDB kuralları
firebase deploy --only database

# Flutter APK build
cd flutter_app && flutter build apk --debug

# ADB install (A12: 192.168.100.36, A71: 192.168.100.3)
adb connect <IP>:<PORT>
adb -s <IP>:<PORT> install -r build/app/outputs/flutter-apk/app-debug.apk
```
