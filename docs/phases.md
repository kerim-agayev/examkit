# Geliştirme Aşamaları

## Phase 1: Proje Kurulumu (18 Haziran 2026)
- Firebase projesi oluşturma (examkit-c39fc → examkit-5e691)
- Flutter projesi yapılandırması
- Next.js projesi yapılandırması
- Google Sign-In entegrasyonu
- GitHub repo + Vercel bağlantısı

## Phase 2: Temel Özellikler (18 Haziran 2026)
- Grup CRUD (oluşturma, listeleme, silme)
- Sınav 5 adımlı oluşturma akışı (başlık → ayarlar → sorular → önizleme → paylaş)
- Soru editörü (ÇSM, D/Y, Kısa Cevap)
- Öğrenci web: kod girişi, isim, bekleme odası

## Phase 3: Firestore Krizi (18-19 Haziran 2026)
- Firestore gRPC bağlantı sorunu tespit edildi
- 10+ saat debugging (REST API, gRPC, Admin API, billing, rules, bölgeler)
- Sonuç: Firestore bu projede çalışmıyor

## Phase 4: RTDB Geçişi (19 Haziran 2026)
- Tüm Firestore işlemleri → RTDB'ye taşındı (20+ dosya)
- RTDB kuralları yeniden yazıldı
- Provider'lar (group, exam, question) yeniden yazıldı
- Web sayfaları (join, waiting, exam, results) yeniden yazıldı
- ScoreCalculator RTDB'ye uyarlandı

## Phase 5: Bug Fixing (19 Haziran 2026)
- Stream hatası (BUG-003)
- UI overflow (BUG-004)
- Firebase init hatası (BUG-005)
- Permission denied (BUG-005)
- Live control sahte veri (BUG-006)
- Öğrenci tamamlama senkronizasyonu (BUG-007)
- Sonuç sayfası realtime listener (BUG-008)
- Grup sınav sayacı (BUG-009)

## Phase 6: Stabilizasyon (Devam Ediyor)
- Tam uçtan uca test (öğretmen başlat → öğrenci katıl → tamamla → puanla → sonuçlar)
- Öğretmen sınavı bitirince öğrenciye sonuçların gitmesi
- Web responsive testleri
- Dokümantasyon

## Phase 7: 10 Maddelik Çözüm (19 Haziran 2026 - Final)

### Faz 1: Kritik ✅
1. **Stream Hatası** — broadcast StreamController, tek provider ✅
2. **Taslak Sistemi** — "Taslak Olarak Kaydet" butonu, statüye göre yönlendirme ✅
3. **Delete** — silme ikonu + onay dialog'u + examCount decrement ✅
4. **Stream Fix** — watchQuestionsProvider broadcast ✅

### Faz 2: Özellikler ✅
5. **Shuffle** — join'de settings okuma, questionOrder + optionOrders ✅
6. **Timer** — live_control settings'ten süre, öğrenci UI sayaç ✅
7. **Settings Saygı** — results'te showScore/showLeaderboard kontrol ✅
8. **Sequential Mode** — RTDB'den mode okuma, URL parametresi ✅

### Faz 3: UI + Dil ✅
9. **Home Bugün** — bugün oluşturulan sınav sayısı (client-side filter) ✅
10. **Dil Seçimi** — appLanguageProvider → app.dart locale dinamik ✅
