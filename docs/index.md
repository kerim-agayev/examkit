# ExamKit — Proje Dokümantasyonu

> **Son güncelleme:** 19 Haziran 2026
> **Versiyon:** 1.0.0-beta
> **Durum:** Temel akış çalışıyor, puanlama ve sonuçlar test aşamasında

## Proje Özeti

**ExamKit**, öğretmenlerin sınav oluşturmasını ve öğrencilerin tarayıcıdan katılmasını sağlayan bir eğitim platformudur.

| Bileşen | Teknoloji | Açıklama |
|---|---|---|
| **Öğretmen Mobil** | Flutter 3.41 / Dart 3.11 | Android APK, Google Sign-In, sınav yönetimi |
| **Öğrenci Web** | Next.js 15 / React 19 | Tarayıcı tabanlı, uygulama gerektirmez |
| **Veritabanı** | Firebase RTDB | Realtime Database (WebSocket tabanlı) |
| **Auth** | Firebase Auth | Sadece öğretmen (Google Sign-In) |
| **Hosting** | Vercel (web), ADB (APK) | Otomatik GitHub → Vercel deploy |

## Hızlı Başlangıç

```bash
# Web (öğrenci tarafı)
cd student_web && npm install && npm run dev

# Mobile (öğretmen tarafı)
cd flutter_app && flutter pub get && flutter run

# Firebase deploy
firebase deploy --only database
```

**Canlı linkler:**
- Öğrenci: https://examkit-beta.vercel.app
- RTDB Console: https://console.firebase.google.com/u/1/project/examkit-5e691/database/data

## Doküman Haritası

| Dosya | İçerik |
|---|---|
| [architecture.md](./architecture.md) | Sistem mimarisi, RTDB veri yapısı |
| [decisions.md](./decisions.md) | Kritik teknik kararlar |
| [bugs.md](./bugs.md) | Bug listesi ve çözümleri |
| [phases.md](./phases.md) | Geliştirme aşamaları |
| [web/overview.md](./web/overview.md) | Web uygulama yapısı |
| [web/data-flow.md](./web/data-flow.md) | Öğrenci tarafı veri akışı |
| [mobile/overview.md](./mobile/overview.md) | Flutter uygulama yapısı |
| [mobile/data-flow.md](./mobile/data-flow.md) | Öğretmen tarafı veri akışı |
| [firebase/setup.md](./firebase/setup.md) | Firebase proje yapılandırması |
| [firebase/rules.md](./firebase/rules.md) | RTDB güvenlik kuralları |
