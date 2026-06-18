# ADR-005: Çift Sınav Modu — Scroll + Sequential

**Tarih:** Haziran 2026  
**Durum:** accepted

## Bağlam
Farklı sınav senaryoları farklı soru gösterim biçimleri gerektirir. Öğretmenin ihtiyacına göre esneklik sağlanmalı.

## Karar
İki mod birlikte desteklenecek, öğretmen sınav oluştururken seçer:

### Scroll Modu
Tüm sorular tek sayfa halinde listelenir, öğrenci kaydırarak istediği sıradan cevaplar.

### Sequential Modu  
Bir soru, bir cevap, sonraki. Geri gidemez. Cevap zorunlu (boş geçiş yok).

## Gerekçe
- Pazar araştırması: rakiplerin hiçbirinde bu esneklik yok
- Scroll: alıştırma, ödev, gözden geçirme sınavları için
- Sequential: resmi sınav, kopya önleme, sınav güvenliği için
- Aynı soru bankasını her iki modda kullanabilmek verimliliği artırır

## Sequential Mode UX — Onay Akışı (Eklenen: 2026-06-18)

Kazara ilerleme riskine karşı iki aşamalı onay mekanizması:

### 1. Cevap Seçme → İlerleme Kilidi
1. Öğrenci bir seçeneğe dokunur → seçenek **highlight** olur (primary border + primary-light bg)
2. "İlerle →" butonu **aktifleşir** (disabled → enabled, opacity 40 → 100)
3. Öğrenci **5 saniye içinde** seçimi değiştirebilir (farklı bir seçeneğe dokunabilir)
4. "İlerle" butonuna basınca → cevap **kilitlenir**, Firestore'a yazılır, sonraki soruya geçilir

### 2. Son Soru → Çift Onay
Son soruda (currentIndex == total-1): "Sınavı Tamamla ✓" butonu.
Bu butona basılınca **confirm dialog** çıkar:
```
🎯 Sınavı tamamlamak istediğinize emin misiniz?
   Cevaplarınız gönderilecek ve geri alınamaz.
   [Geri Dön]  [Evet, Tamamla]
```

### 3. Soru Timer Auto-Advance → 5 Saniye Geri Sayım
Soru başına timer dolarken (örn. "60 sn"), 5 saniye kala:
- Geri sayım animasyonu: "5 → 4 → 3 → 2 → 1" (warning color, büyüyen)
- Öğrenci bu sırada manuel "İlerle" ile geçebilir
- 0'da: cevap verildiyse → kaydet ve geç; verilmediyse → boş kaydet ve otomatik geç

### 4. Lock-in Animasyonu
Cevap seçildikten sonra seçeneğe `scale(1.03)` bounce animasyonu (300ms → geri).
Çift dokunuşu engeller (aynı anda iki seçenek seçilemez).

---

## Sonuçlar
- QuestionCard bileşeni her iki modda aynı (tek bileşen)
- Sequential'da "İlerle" butonu cevap olmadan disable
- Sequential'da son soruda confirm dialog (yeniden onay)
- Sequential'da soru timer 5 sn kala geri sayım + auto-advance
- Timer davranışı modlara göre farklı (detay: api_design.md)
- Sınav önizlemesi seçilen moda göre render edilir

## Alternatifler
- Sadece Sequential — sınırlandırıcı, ödev kullanımını engellerdi
- Sadece Scroll — kopya önleme gücü düşük
- Hybrid (bazı sorular sequential, bazıları scroll) — Faz 2'de değerlendirilebilir
