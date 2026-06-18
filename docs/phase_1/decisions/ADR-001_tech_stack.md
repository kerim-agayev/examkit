# ADR-001: Flutter + Next.js 15.5 + Firebase Spark

**Tarih:** Haziran 2026  
**Durum:** accepted

## Bağlam
Öğretmenler için native mobil uygulama, öğrenciler için uygulama indirmeden erişilebilir web arayüzü ve tüm bunları bağlayan gerçek zamanlı backend gerekiyor. MVP'nin tamamen ücretsiz olması zorunlu.

## Karar
- Öğretmen uygulaması: **Flutter 3.44.0** (iOS + Android, tek codebase)
- Öğrenci arayüzü: **Next.js 15.5** (tarayıcı, uygulama indirme yok)
- Backend: **Firebase Spark** (ücretsiz, ödeme bilgisi gerekmez)

## Gerekçe
- Flutter: iOS ve Android'i tek codebase ile kapsar, hot reload hızı, Dart güvenli tip sistemi
- Next.js 15.5: Kullanıcı tercihi, App Router olgunluğu, React 19 ile iyi entegrasyon
- Firebase Spark: Gerçek zamanlı sınav için Realtime DB, kalıcı veri için Firestore, kredi kartı gerekmez

## Sonuçlar
- Tek geliştirici aynı anda 2 platform yazabilir
- MVP maliyeti: $0
- Firebase Spark limitleri (100 RTDB bağlantı, 50K Firestore okuma/gün) MVP için yeterli

### ⚠️ Bilinen Kısıt — Puanlama Cihaz Bağımlılığı (bkz. ADR-006)
Spark planı **Cloud Functions'ı pratik olarak kullanılamaz** yapar → puanlama
(`ScoreCalculator`) öğretmen Flutter cihazında çalışır. Bu, "öğretmen cihazı
kapalıysa sonuç hesaplanamaz" riskini doğurur. ADR-006 üç katmanlı bir kurtarma
stratejisi (otomatik tarama + manuel tetik + net bekleme UI) tanımlar.

### 📈 Blaze Planına Geçiş Eşikleri (Phase 2'ye not)
Aşağıdaki eşiklerden herhangi biri tetiklenirse Cloud Functions + Blaze planına
geçiş yeniden değerlendirilmeli:
- Aylık aktif öğretmen > 500 (recovery provider'ın quota yükü belirgin hale gelir)
- "Hesaplanmamış sınav" support talepleri > ayda 5 (manuel kurtarma sıkışıyor)
- Ortalama `scoreCalculatedAt == null` kalma süresi > 2 dk (öğrenci bekleme UI sıkışıyor)
- Gerçek zamanlı leaderboard talebi (şu an yok — Phase 2 analitik ile gelebilir)

Bu eşikler kesin kurallar değil, **değerlendirme tetikleyicileridir**. MVP'de
her durumda Spark + ADR-006 recovery geçerlidir.

## Alternatifler
- React Native (Expo) — Dart yerine JS, ancak Flutter olgunluk ve performans açısından daha iyi
- Supabase — Açık kaynak, ancak Flutter entegrasyonu Firebase kadar olgun değil
- Vercel — Ücretsiz planda ticari kullanım yasak → Cloudflare Pages seçildi
