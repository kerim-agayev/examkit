# ADR-003: Flutter State Management için Riverpod 3.0

**Tarih:** Haziran 2026  
**Durum:** accepted

## Bağlam
Flutter uygulamasında state management çözümü seçilmesi gerekiyor.

## Karar
**Riverpod 3.0** (riverpod_generator + riverpod_annotation ile).

## Gerekçe
- **GetX yasak**: Nisan 2026'da GitHub reposu silinmeksizin önceden uyarı verilmeksizin kaldırıldı
- Riverpod 3.0 Dart compile-time hata yakalama sağlar — runtime hata riski düşük
- Code generation (riverpod_generator) boilerplate'i minimuma indirir
- Firebase streams ile doğal entegrasyon (StreamProvider)
- Sektörün fiili standardı haline geldi

## Sonuçlar
- Her provider `@riverpod` annotation ile tanımlanır
- `build_runner watch` geliştirme sırasında sürekli çalışır
- Test edilebilirlik yüksek (ProviderContainer ile izole test)

## Alternatifler
- GetX — SİLİNDİ, kullanılamaz
- BLoC — Çok fazla boilerplate, Riverpod kadar Firebase-friendly değil
- Provider (eski) — Riverpod'un selefi, daha az özellikli
- Zustand (Flutter port) — Olgun değil
