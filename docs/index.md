# ExamKit — Dokümantasyon Ana İndeksi

> Bu klasör projenin **hafıza sistemidir**. Her geliştirme adımı burada kayıt altına alınır.

---

## 📁 Yapı

```
docs/
├── index.md             ← BU DOSYA
├── phase_1/             ← MVP geliştirme
│   ├── index.md         ← Faz 1 durum + ilerleme
│   ├── architecture/    ← Mimari kararlar ve şemalar
│   ├── decisions/       ← ADR (Architecture Decision Records)
│   ├── logs/            ← Oturum bazlı geliştirme notları
│   ├── bugs/            ← Bug takip sistemi
│   └── secrets_management.md  ← Secret yönetimi (Firebase)
└── phase_2/             ← Büyüme özellikleri (planlama)
    └── index.md
```

---

## 🔗 Hızlı Erişim

| Doküman | Açıklama |
|---------|----------|
| [Phase 1 Durumu](./phase_1/index.md) | Mevcut ilerleme ve checklist |
| [Firebase Şeması](./phase_1/architecture/firebase_schema.md) | Tam veritabanı şeması |
| [API & Servis Tasarımı](./phase_1/architecture/api_design.md) | Repository/service arayüzleri |
| [Flutter Mimarisi](./phase_1/architecture/flutter_structure.md) | Flutter app yapısı |
| [Next.js Mimarisi](./phase_1/architecture/nextjs_structure.md) | Öğrenci web yapısı |
| [Test Stratejisi](./phase_1/architecture/testing_strategy.md) | Framework, coverage, CI |
| [ADR'ler](./phase_1/decisions/) | 6 mimari karar kaydı (ADR-001..006) |
| [Secret Yönetimi](./phase_1/secrets_management.md) | Firebase key rotation, sızıntı planı |
| [Loglar](./phase_1/logs/) | Geliştirme günlüğü |
| [Buglar](./phase_1/bugs/) | Açık ve kapalı sorunlar |
| [Phase 2 Planı](./phase_2/index.md) | Gelecek özellikler |

---

## 📌 Kurallar

1. **Her oturum sonrası** `phase_1/logs/` dosyasına kayıt ekle
2. **Bug keşfedilince** anında `phase_1/bugs/` dosyasına ekle — unutmadan
3. **Mimari değişince** `phase_1/architecture/` ve `decisions/` güncelle
4. **Phase 2'ye özellik erteliyorsan** `phase_2/index.md`'ye ekle

---

*Proje Başlangıcı: Haziran 2026*  
*Stack: Flutter 3.44 + Next.js 15.5 + Firebase Spark + Cloudflare Pages*
