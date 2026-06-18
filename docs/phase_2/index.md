# Phase 2 — Büyüme Özellikleri (Planlama)

**Durum:** Planlamada  
**Başlangıç:** Phase 1 tamamlandıktan sonra  
**Tahmini Süre:** 3–6 ay

---

## 🎯 Phase 2 Hedefi

Phase 1 MVP'nin temel sınav akışı üzerine verimlilik, güvenlik ve analitik özellikleri eklemek.

---

## 📋 Planlanan Özellikler

### Soru Bankası
- Soruları sınav dışında ayrı bankada sakla ve tekrar kullan
- Konu/etiket ile filtreleme
- Soru bankasından sınava drag-drop

### AI Soru Üreteci
- Konu başlığı girerek otomatik sorular üret
- Belge yükle (PDF) → AI soru üretimi
- Anthropic Claude API — üretilen soruları düzenle, bankaya kaydet

### Görsel Desteği (Cloudinary Free Tier)
- Sorulara görsel ekle (Firebase Storage değil — ücretli)
- Cloudinary free: 25GB depolama

### Gelişmiş Soru Tipleri
- Çoklu doğru cevap MCQ
- Sıralama sorusu
- Eşleştirme sorusu

### Anti-Hile Paketi
- Sekme değiştirme tespiti
- Kamera doğrulama (isteğe bağlı)
- IP tekrar girişi engeli

### Gelişmiş Analitik
- Öğrenci başarı geçmişi (çoklu sınav karşılaştırma)
- PDF rapor çıktısı
- Konuya göre zayıf alan analizi

### Çevrimdışı Hazırlık (Flutter)
- Uçuşta, internetsiz ortamda soru yaz
- Bağlantı gelince otomatik sync

### Dil Genişletme
- İngilizce (en)
- Rusça (ru) — Azerbaycan için

### UI İyileştirmeleri
- Büyük yazı modu (erişilebilirlik)
- Koyu/Açık tema seçici
- Sınav şablon kütüphanesi

### Ödeme Altyapısı
- Stripe (global)
- iyzico (Türkiye)
- Pro plan kilit sistemi

---

## ⏭️ Phase 1'den Ertelenenler

| Özellik | Neden Ertelendi |
|---------|----------------|
| Firebase Cloud Storage | Şubat 2026'dan ücretli |
| SMS OTP girişi | Ücretli, Google Sign-In yeterli |
| PDF export | MVP kapsamı dışında |
| AI soru üreteci | MVP kapsamı dışında |
| Çoklu doğru MCQ | Temel MCQ Phase 1'de yeterli |
| Büyük yazı modu | Core UX Phase 1'de, erişilebilirlik Phase 2 |

---

## Phase 3 — Kurumsal (Gelecek)

- Okul/kurum paneli + çok öğretmenli hesap
- Beyaz etiket (white-label)
- Bakanlık API entegrasyonu
- Veli bildirimleri + öğrenci portfolyo
- LMS entegrasyonu (Moodle, Google Classroom)
