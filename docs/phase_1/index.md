# Phase 1 — MVP Geliştirme Durumu

**Başlangıç:** Haziran 2026  
**Hedef:** Flutter öğretmen uygulaması + Next.js öğrenci web + Firebase backend  
**Mevcut Durum:** 🟡 %35 — UI tamam, veri katmanı yapılıyor

---

## 📊 Genel İlerleme

| Kategori | Toplam | Tamamlanan | Yüzde |
|----------|--------|-----------|-------|
| Auth & Profil | 6 | 4 | %67 |
| Ana Sayfa | 5 | 5 | %100 |
| Grup Yönetimi | 6 | 4 | %67 |
| Sınav Oluşturma | 6 | 5 | %83 |
| Soru Editörü | 9 | 6 | %67 |
| Sınav Ayarları | 12 | 10 | %83 |
| Paylaşım | 5 | 4 | %80 |
| Canlı Kontrol | 8 | 5 | %63 |
| Sonuçlar | 6 | 5 | %83 |
| Öğrenci Web (Katılım) | 6 | 5 | %83 |
| Öğrenci Web (Sınav) | 13 | 10 | %77 |
| Öğrenci Web (Sonuç) | 6 | 5 | %83 |
| Edge Cases | 7 | 2 | %29 |
| Lokalizasyon | 4 | 2 | %50 |
| **TOPLAM** | **99** | **72** | **%73** |

---

## 🗓️ Son Aktivite

| Tarih | Yapılan | Log |
|-------|---------|-----|
| 2026-06-18 | Proje analizi + 6 risk çözüldü + student_web 7 sayfa + flutter_app 19 ekran + Firebase provider katmanı + ScoreCalculator + Question/Live exam provider + Exam code generator + Security rules | — |

---

## 🔗 Phase 1 Dökümanları

- [Mimari: Firebase Şeması](./architecture/firebase_schema.md)
- [Mimari: Flutter Yapısı](./architecture/flutter_structure.md)
- [Mimari: Next.js Yapısı](./architecture/nextjs_structure.md)
- [Mimari: API Tasarımı](./architecture/api_design.md)
- [Mimari: Test Stratejisi](./architecture/testing_strategy.md)
- [Kararlar (6 ADR)](./decisions/)
- [Secret Yönetimi](./secrets_management.md)
- [Loglar](./logs/)
- [Buglar](./bugs/)

---

## ⏭️ Geliştirme Sırası (Önerilen)

```
1. Firebase kurulum + Auth (Google Sign-In)
2. Profil + Onboarding akışı
3. Grup CRUD (oluştur, listele, düzenle, sil)
4. Sınav oluşturma akışı (5 adım)
5. Soru editörü (MCQ + T/F + Kısa Cevap)
6. Sınav ayarları (12 ayar)
7. Sınav kodu üretimi + Paylaşım sistemi
8. Öğrenci Next.js web (katılım + bekleme)
9. Canlı sınav (RTDB senkronu)
10. Öğrenci sınav ekranı (Scroll + Sequential)
11. Sonuçlar ekranı (öğretmen + öğrenci)
12. Lokalizasyon (AZ + TR)
13. Edge case'ler + hata yönetimi
14. Test + Düzeltme (bkz. architecture/testing_strategy.md)
    - ScoreCalculator %100 coverage (TDD)
    - Security rules (Firebase Emulator)
    - Sequential mode onay akışı testleri
    - Lighthouse mobile ≥ 90
    - GitHub Actions CI
```

---

*Her güncelleme için bu dosyadaki tabloyu güncelle.*
