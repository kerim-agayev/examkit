# ExamKit — Google Stitch Prompt

> Bu dosyadaki her bölümü Google Stitch'e ayrı ayrı gir.
> Önce DESIGN.md'yi Stitch'e yükle, sonra aşağıdaki bölümleri sırayla gir.
> Her bölümün altında hangi ekranları oluşturacağı belirtilmiştir.

---

## ÖNCE: Stitch'e DESIGN.md'yi yükle

Google Stitch arayüzünde:
1. "Import design system" → DESIGN.md dosyasını yükle
2. Stitch tasarım sistemini tanıyacak
3. Ardından aşağıdaki prompt bölümlerini sırayla kullan

---

## BÖLÜM 1: Proje Bağlamı (Her prompttan önce sisteme ver)

```
You are designing ExamKit — a professional exam platform for teachers in Azerbaijan and Turkey.

Design system: Inter font, primary #2563EB, success #059669, error #DC2626, background #F1F5F9, cards white. Material Design 3 for Flutter mobile, clean minimal for student web.

Key principles:
- Teachers aged 25–65 use the mobile app, including 60+ year-olds → minimum 16sp body text, 48dp touch targets, clear visual hierarchy
- Students access the web version from their mobile browsers → mobile-first responsive design, no navigation complexity
- Every primary action button must be full-width, 56dp height, prominent
- Status colors: draft=amber, active=blue, live=green (animated dot), completed=gray
- Language: All labels in Turkish (primary) with Azerbaijani variant noted

App has 2 sides:
A) Flutter Teacher App (iOS/Android) — 19 screens
B) Next.js Student Web (mobile browser) — 7 screens, responsive
```

---

## BÖLÜM 2: Flutter Öğretmen Uygulaması — Auth Akışı

```
Design 4 Flutter mobile screens for the ExamKit teacher app. Material Design 3, Inter font, #2563EB primary.

SCREEN 1 — Splash Screen
Full screen. White background. Center: ExamKit logo (stylized "E" mark in #2563EB) + app name "ExamKit" in 32sp bold below. Subtle loading indicator at bottom (linear, primary color). Clean, professional, no distractions.

SCREEN 2 — Onboarding (3-page carousel)
Show page 2 of 3. White background. Top: large illustration area (abstract, geometric, education-themed in #2563EB shades). Below illustration: bold headline "WhatsApp ile tek tuşta paylaş" (22sp, 700, dark). Subtext: "Oluşturduğun sınavı tek dokunuşla WhatsApp grubuna gönder" (16sp, text-secondary, centered). Bottom area: 3 dot indicators (page 2 active = #2563EB, others = #E2E8F0). Full-width "Devam Et" button (56dp, primary fill). Bottom text button "Atla" in text-secondary.

SCREEN 3 — Login Screen
Clean white card centered on light #F1F5F9 background. Top: ExamKit logo + name. Large gap. Headline "Hesabınıza giriş yapın" (22sp bold). Subtext "Google hesabınızla devam edin" (16sp, text-secondary). Large "Google ile Giriş Yap" button (56dp height, white background, 1.5dp border #E2E8F0, Google G logo left-aligned, "Google ile Giriş Yap" text 18sp, centered). No email/password fields. No SMS. Footer: "Hesap oluşturmaya gerek yok" (small, text-secondary).

SCREEN 4 — Profile Setup (First Time)
AppBar: back arrow, title "Profil Bilgileri". Step indicator: "Adım 1/1" (right). White content area. Section: avatar circle (user initial, primary color fill, 80dp). Below: "Ad Soyad" text field (56dp, filled). "Okul Adı" text field (56dp, filled, optional label). Language selection: two large cards side by side (each full half-width, 80dp height, rounded-lg): left card "🇦🇿 Azərbaycan dili" / right card "🇹🇷 Türkçe" — selected card has primary border + primary-light background + checkmark. Bottom sticky: "Tamamla ve Başla" full-width primary button (56dp).
```

---

## BÖLÜM 3: Flutter Öğretmen Uygulaması — Ana Sayfa

```
Design 1 Flutter mobile screen — ExamKit Home Dashboard. Material Design 3.

SCREEN 5 — Home Dashboard
Status bar + AppBar: white, "Merhaba, Ayşə Müəllim 👋" (title, 20sp, truncated), right: avatar circle (user photo/initial, 36dp, tappable → settings).

Scrollable content on #F1F5F9 background:

SECTION — Stats Row (3 cards, horizontal scroll or equal-width row):
Each card: white, rounded-lg, padding 16dp.
Card 1: icon (people, #2563EB), "12" (28sp bold, dark), "Grup" (14sp, text-secondary)
Card 2: icon (assignment, #059669), "47" (28sp bold), "Sınav" (14sp)
Card 3: icon (person, #D97706), "128" (28sp bold), "Bugün" (14sp)

SECTION — Quick Actions (two full-width buttons, vertical stack, gap 12dp):
Button 1: 64dp height, primary fill, left icon (+people), "Yeni Grup Oluştur" (18sp bold, white)
Button 2: 64dp height, success fill, left icon (add-circle), "Yeni Sınav Oluştur" (18sp bold, white)

SECTION — "Son Sınavlar" title (18sp bold) + "Tümünü Gör" text link right.
List of 3 exam cards (white, rounded-lg, 80dp height each):
Card row: left=subject icon circle (colored by status), center=exam name (16sp bold) + group name (14sp muted) below, right=status badge + date.
Card 1: "Riyaziyyat Fənn Sınavı" / "9-A Sinifi" / orange "Taslak" badge
Card 2: "Türk Dili Yazılı" / "11-B Sinifi" / green "● Canlı" badge (animated dot)
Card 3: "Kimya Bölüm 2" / "10-A Sinifi" / gray "Tamamlandı" badge

Bottom: NavigationBar (72dp, white, slight top shadow). 4 tabs: Home (filled, active, primary), Groups, Exams, Settings.
```

---

## BÖLÜM 4: Flutter Öğretmen Uygulaması — Grup Yönetimi

```
Design 3 Flutter mobile screens for ExamKit group management.

SCREEN 6 — Group List
AppBar: "Gruplarım" title + "+" icon button (right, 48dp tap target). Search bar below AppBar: rounded input, search icon left, "Grup ara..." placeholder. #F1F5F9 background.

List of group cards (white, rounded-lg, 72dp min height, 12dp gap):
Each card: left=group icon circle (primary-light bg, primary icon, 48dp), center column=group name (17sp 600) + "8 sınav · Son: 2 gün önce" (13sp text-secondary), right=chevron-right icon.
Show 4 cards. Last card has red "3 Aktif" badge on right.
Empty state at bottom with soft illustration + "Henüz grup yok" + "İlk grubunu oluştur" primary button.

SCREEN 7 — Group Create / Edit
AppBar: "Yeni Grup" title, "İptal" left text button, "Kaydet" right text button (primary color, disabled if empty).
White form card (rounded-xl, margin 16dp):
"Grup Adı *" text field (56dp, filled, max 60 chars, char counter bottom-right "0/60")
"Açıklama" text field (88dp, multiline, optional, "İsteğe bağlı..." placeholder)
Helper text below: "Öğrenciler gruba önceden eklenmez — sınava katılırken otomatik eklenir" (13sp, info color, info icon left).

SCREEN 8 — Group Detail
AppBar: group name, back arrow, edit icon (right).
White stats bar (3 columns): "24 Sınav" / "312 Öğrenci" / "3 gün önce". Dividers between.
"Bu Grupla Sınav Oluştur" full-width button (success fill, 56dp).
Section title "Geçmiş Sınavlar".
List of exam result cards (white, rounded-lg):
Each: exam name (16sp 600), date (13sp muted), "28 öğrenci" icon+text, "Ort: 72%" badge (primary-light). Chevron right.
Show 3 cards then "Daha fazla göster" text button.
```

---

## BÖLÜM 5: Flutter Öğretmen Uygulaması — Sınav Oluşturma

```
Design 4 Flutter mobile screens for ExamKit exam creation flow.

SCREEN 9 — Exam List
AppBar: "Sınavlarım". Tab bar below (4 tabs): Tümü / Taslak / Aktif / Tamamlandı. Active tab = primary underline.
FAB bottom-right: + icon, primary color.
List of exam cards (white, rounded-lg, 88dp height):
Card layout: top row = exam name (16sp 600) + status badge right. Bottom row = group name (13sp muted) + "·" + "12 soru" + "·" date.
Card 1: "Biologiya Final" / "11-A" / 15 soru / blue "Aktif" badge
Card 2: "Fizika Bölüm 3" / "10-B" / 8 soru / orange "Taslak" badge  
Card 3: "Tarix Yazılı" / "9-A" / 20 soru / gray "Tamamlandı" badge
Long-press indicator on Card 2 (showing context menu: Düzenle / Sil / Paylaş).

SCREEN 10 — Exam Create Step 1 (Title & Group)
AppBar: "Yeni Sınav" title. Progress stepper top: 5 steps, step 1 filled primary circle, others outlined gray. "1/5 Temel Bilgiler" label.
White card content (rounded-xl, margin):
"Sınav Başlığı *" text field (56dp, filled, "örn: Riyaziyyat Fənn İmtahanı", char counter "0/100").
Gap. "Grup Seç *" label. Group picker (tappable row, 64dp, white card, left=people icon, center="Grup seçin" placeholder text, right=chevron). Below picker: "+ Yeni Grup Oluştur" text button (primary color, small).
Bottom sticky: "Devam Et →" full-width primary button (56dp, disabled state shown — grayed).

SCREEN 11 — Exam Settings Step 2
AppBar: sınav başlığı truncated. Progress: step 2 active.
Scrollable settings form on #F1F5F9:

Section "Sınav Modu" (white card, rounded-xl):
Two selectable radio cards (vertical stack, 8dp gap):
Card A (selected): primary border 2dp, primary-light bg. Left: radio filled. Center: "Kaydırma Modu" (16sp 600) + "Tüm sorular görünür, serbestçe gezilebilir" (13sp muted). Right: layers icon.
Card B: gray border. "Sıralı Mod" + "Soru soru, geri dönülemez" + lock icon.

Section "Zamanlama" (white card):
"Genel Süre Sınırı" toggle row (right toggle, currently ON). Below toggle (visible when ON): "45 dakika" slider (1–180 dk, primary accent).
"Soru Başına Süre" toggle row (OFF).

Section "Anti-Hile" (white card):
"Soru Sırasını Karıştır" toggle (OFF).
"Şık Sırasını Karıştır" toggle (OFF). Divider between.

Section "Öğrenciye Göster" (white card, 3 toggles):
"Puanını göster" (ON) / "Doğru cevapları göster" (ON) / "Sıralamayı göster" (ON). Dividers.

Bottom: "Devam Et →" primary button.

SCREEN 14 — Exam Preview Step 4
AppBar: "Önizleme", back arrow. Progress: step 4.
Banner card (primary-light bg, rounded-xl, 16dp): "👁 Öğrencinin göreceği görünüm" (14sp info).
Simulated exam preview below (card with subtle border):
Exam title "Biologiya Final İmtahanı" (20sp bold, center).
"Kaydırma Modu · 20 soru · 45 dk · 65 puan" (13sp muted, center).
Divider. First 2 questions shown:
Q1: "Soru 1 / 20" label. Question text. 4 MCQ options (outlined pills, tappable look).
Q2: "Soru 2 / 20" label. T/F question. 2 big buttons "Doğru" "Yanlış".
Bottom: "← Düzenle" outlined button + "Yayınla ve Paylaş →" primary button (56dp each, side by side).
```

---

## BÖLÜM 6: Flutter Öğretmen Uygulaması — Soru Editörü

```
Design 1 Flutter screen (with 3 tab states) for ExamKit question editor.

SCREEN 12 — Question List (Step 3)
AppBar: "Sorular" + progress step 3. Right: "Toplam: 65 puan" chip (primary-light).
Drag-reorder list (white cards, 80dp, 8dp gap, drag handle left side ≡):
Card format: handle | type badge | question text truncated | points chip | edit+delete icons.
Card 1: "ÇSM" (blue badge) | "Mitoz bölünmənin əsas mərhələ..." | "3 puan" chip | ✏️🗑️
Card 2: "D/Y" (green badge) | "DNA replikasiyası S fazasında..." | "1 puan" | ✏️🗑️
Card 3: "KA" (purple badge) | "Fotosintezin əsas məhsulu..." | "2 puan" | ✏️🗑️
"+ Soru Ekle" FAB (extended, center bottom): tapped state shows BottomSheet with 3 options (MCQ / D-Y / Kısa Cevap cards).

SCREEN 13A — Question Editor: MCQ Mode
AppBar: "Çoktan Seçmeli Soru" + "Kaydet" right button (primary).
White form (rounded-xl, margin):
"Soru Metni *" multiline TextField (4 satır, "Soruyu buraya yazın...", char counter "0/500").
Puan row: "Puan:" label + "-" circle button + "3" (22sp bold center) + "+" circle button.
Soru Timer: "Soru Süresi" toggle + "60 sn" (when ON, slider visible).
Divider. "Seçenekler" title.
4 option rows (A, B, C, D):
Each: letter circle (gray/green when correct) | TextField "Seçenek A..." | radio button right (tap = mark correct).
Correct option (B): green circle letter, green-tinted input background, green radio filled.
"Doğru cevap: B" confirmation chip (success-light, bottom of options).

SCREEN 13B — Question Editor: True/False Mode
AppBar: "Doğru / Yanlış Soru".
Soru metni TextField (4 satır).
Puan + Timer same as above.
"Doğru Cevap:" label. Two large selection cards (side by side, 80dp height):
Left "✓ Doğru" (selected: success fill, white text) | Right "✗ Yanlış" (outlined, gray text).

SCREEN 13C — Question Editor: Short Answer Mode
AppBar: "Kısa Cevap Soru".
Soru metni TextField.
Puan + Timer.
"Kabul Edilen Cevaplar" section:
Row 1: "Cevap 1 *" TextField (56dp) + trash icon right.
Row 2: "Alternatif cevap" TextField (outlined style, optional) + trash.
"+ Alternatif ekle" text button (primary, left-aligned, small).
Info chip: "Büyük/küçük harf fark etmez" (13sp, info-light).
```

---

## BÖLÜM 7: Flutter Öğretmen Uygulaması — Paylaşım & Canlı Kontrol

```
Design 2 Flutter mobile screens for ExamKit sharing and live exam control.

SCREEN 15 — Share Screen (Step 5)
AppBar: "Sınavı Paylaş", close X icon. "5/5" progress.
Center hero card (white, rounded-2xl, padding 24dp):
"Sınav Kodu" label (13sp muted, center).
"M A T 7 K 2" (monospace, 40sp bold, letter-spacing wide, #2563EB, center). Each letter in light-bordered box.
"stitch.examkit.app/join/MAT7K2" (13sp muted url, center, copyable).

2×2 grid of action cards below (white, rounded-xl, 96dp height each, 12dp gap):
Card 1 (WhatsApp): green icon (#25D366) + "WhatsApp'ta Paylaş" (16sp 600, dark) + "Mesaj hazır, gönder!" (13sp muted)
Card 2 (QR): blue icon + "QR Kod" + "Yansıt veya paylaş"
Card 3 (Copy): gray icon + "Linki Kopyala" + "Panoya kopyala"
Card 4 (Share): purple icon + "Diğer Uygulamalar" + "Telegram, Mail..."

Bottom: "Canlı Kontrole Geç →" full-width success button (56dp). Badge "3 öğrenci bekleniyor" animasyonlu (green dot + count).

SCREEN 16 — Live Exam Control
AppBar: "Canlı Kontrol", exam name truncated subtitle. Right: wifi-good green icon.

STATE A — Waiting (shown):
Top info bar (white card): "⏳ Sınav Başlamadı" (status) | "Biologiya Final" | "Kaydırma Modu · 20 dk".
"Bekleme Odasında" section:
Large counter: "8" (48sp bold, primary) + "öğrenci hazır" (18sp, text-secondary). Center.
Animated: green pulsing circle around counter.
Student list (white card, rounded-xl):
Each row: avatar initial circle (primary-light, 40dp) + name (16sp) + "2 dk önce katıldı" (13sp muted) + green dot (connected).
Show 5 names: Aynur, Kamran, Leyla, Murad, Nigar. Scroll indicator for more.
Bottom: "Sınavı Başlat" LARGE full-width primary button (64dp, 20sp bold). Sub-text below: "Başlatınca tüm öğrencilere aynı anda açılır".

STATE B — Active (small inset overlay to show):
Replace counter with: "Tamamlayan: 5 / 8" progress bar (success color fill). Timer "18:42" countdown (red, bold).
Student list updates: Aynur=green check ✓ / Kamran=blue progress bar 15/20 / others ongoing.
Bottom becomes: "Sınavı Erken Bitir" outlined danger button.
```

---

## BÖLÜM 8: Flutter Öğretmen Uygulaması — Sonuçlar & Ayarlar

```
Design 3 Flutter mobile screens for results and settings.

SCREEN 17 — Exam Results
AppBar: "Sınav Sonuçları", back arrow. Subtitle: "Biologiya Final · 8 öğrenci".

Stats card (white, rounded-xl, padding 16dp):
4-column stat row: "8" katılımcı | "72%" ortalama | "94%" en yüksek | "%75" geçme oranı.
Below: mini bar chart (5 bars: 0-20%, 21-40%, 41-60%, 61-80%, 81-100%). Primary color bars. Y-axis: öğrenci sayısı.

"Sıralama" section title. Leaderboard cards (white, rounded-lg):
Rank 1: 🥇 "Aynur Məmmədova" (bold) | "94% · 48 puan / 50" | "18:32" (time) | primary chip.
Rank 2: 🥈 "Kamran Hüseynov" | "88% · 44 puan" | "21:15".
Rank 3: 🥉 "Leyla Əsgərova" | "82% · 41 puan" | "19:44".
Rank 4–8: plain rows, smaller, tappable.

"Soru Analizi" section: mini colored row per question.
Q1: 90% doğru → green bar | Q7: 45% doğru → red bar.

SCREEN 18 — Student Result Detail
AppBar: "Aynur Məmmədova" + back. Top: "🥇 1. Sırada" gold badge.
Score card (white, rounded-xl): "48 / 50 puan" (32sp bold) | "96%" (24sp success) | "18 dk 32 sn" | "1. Sıra / 8 öğrenci".
Correct/Wrong/Empty row: "46 ✓" green | "3 ✗" red | "1 –" gray.
Question-by-question list:
Q1: ✅ "Doğru" green row | question truncated | "+3 puan".
Q2: ✅ "Doğru" green.
Q7: ❌ "Yanlış" red row | "Seçilen: B" muted | "Doğru: D" small chip.
Q15: ⭕ "Boş" gray | "0 puan".

SCREEN 19 — Settings
AppBar: "Ayarlar".
Profile card (white, rounded-xl, 96dp): avatar circle (64dp, photo/initial) | name (18sp bold) | school name (14sp muted). "Düzenle" text button right.
Edit fields below (when editing): name TextField + school TextField + "Kaydet" button.
Language section (white card): "Uygulama Dili" title. Two language cards (same as setup screen): AZ selected.
About section (white card): "ExamKit v1.0.0" row + "Hakkında" row.
Danger section: "Çıkış Yap" row (red text, logout icon, chevron). Full separator above.
```

---

## BÖLÜM 9: Next.js Öğrenci Web — Tüm Ekranlar (Mobil Responsive)

```
Design 7 Next.js student web screens. Mobile-first (375px), responsive up to 640px. All screens: Inter font, #2563EB primary, #F1F5F9 background, white content cards (rounded-2xl, 24px padding). No complex navigation. Large touch targets (44px minimum).

SCREEN W1 — Code Entry (Homepage)
Full viewport height (#F1F5F9 background). Content card centered vertically.
Top: ExamKit logo (small, #2563EB) + "ExamKit" wordmark.
Large gap.
"Sınava Katıl" headline (28px bold, dark, center).
"Öğretmenin paylaştığı kodu gir" (16px muted, center).
Large code input (56px height, text-xl, uppercase transform, center aligned text, letter-spacing wide, rounded-xl, 1.5px border, focus=primary border). Placeholder "MAT7K2".
"Devam →" full-width primary button (56px height, 18px bold, rounded-xl, margin-top 12px).
Error state (below input): red text "Geçersiz kod, tekrar deneyin" + shake animation on input.
Loading state: spinner inside button, disabled.
Bottom footnote: "Uygulama indirmeye gerek yok" (13px, muted, center).

SCREEN W2 — Name Entry (/join/MAT7K2)
Top: back arrow (←) + "Sınava Katıl" (18px 600).
Exam info banner (primary-light rounded-xl, padding 16px): 📚 "Biologiya Final İmtahanı" (16px bold) + "Kamran müəllim · 9-A sinifi" (14px muted).
Content card:
"Adınızı girin" headline (24px bold).
"Ad" input (56px, "Adınız...", rounded-xl).
"Soyad" input (56px, "Soyadınız...", rounded-xl).
"Sınava Katıl" primary button full-width (56px, disabled=opacity-40 when empty).
Privacy note: "📋 Adınız öğretmeninizde görünecek" (13px muted, center).

SCREEN W3 — Waiting Room (/waiting/sessionId)
Center-vertically on full viewport.
Animated pulse circle (primary color, 120px, CSS pulse animation).
Inside circle: clock or hourglass icon (48px, white).
"Müəllimi gözləyin..." headline (24px bold, center, margin-top 24px).
"Biologiya Final İmtahanı" (18px, primary, center).
"Bekleme odasında: 8 öğrenci" pill badge (success-light, green text, animated count).
Helper: "Öğretmen başlatınca otomatik açılacak" (14px muted, center).
Bottom: student's name shown: "Katılan: Aynur Məmmədova ✓" (14px, success, center).

SCREEN W4 — Scroll Mode Exam (/exam/sessionId, scroll)
Sticky top bar (white, shadow-sm):
Left: "Biologiya Final" (16px 600, truncated). Right: "18:42 ⏱" timer (16px bold, red when <5min).
Progress bar full-width below bar: "12 / 20 soru cevaplandı" text + colored progress fill (primary).

Scrollable question list:
Question card (white, rounded-2xl, padding 20px, margin-bottom 12px):
"Soru 1" label (12px muted). Question text (18px, dark, margin-bottom 16px).
MCQ options (vertical stack, 8px gap): each option = full-width button (56px min, rounded-xl, 1.5px border, left-aligned text 16px, radio circle left). Selected = primary fill white text. Default = white outlined.
Question card with T/F: two horizontal buttons side by side "✓ Doğru" (success fill when selected) / "✗ Yanlış" (error fill when selected).
Question card with short answer: textarea (3 lines, rounded-xl, 16px font, "Cevabınızı buraya yazın...").

Sticky bottom: "Sınavı Gönder" full-width success button (56px). Shows "3 soru boş" badge above button when unanswered questions exist.

SCREEN W5 — Sequential Mode Exam (/exam/sessionId, sequential)
Sticky top: "Soru 7 / 20" (18px bold, center) + global timer right.
Question timer bar (below top, primary fill animating left, countdown "28 sn").
Large question card (white, rounded-2xl, full width, padding 24px, min-height 200px):
Question text (20px, dark, 700, center or left).
MCQ options (vertical, 12px gap, larger touch targets 64px each, rounded-xl).
Selected option: primary fill, white text, scale(1.02) effect.
No back button visible. No other questions visible.
Bottom sticky: "İlerle →" primary button (56px). Disabled (opacity-40, "önce cevap verin" sub-text) when no answer selected. Last question: "Sınavı Tamamla ✓" success button.

SCREEN W6 — Exam Completed (transition)
Full screen white center.
Large animated checkmark (success green, circular, draw animation: 80px circle).
"Sınav Tamamlandı! 🎉" (26px bold, center, dark).
"Sonuçlar hesaplanıyor..." (16px muted, center, dots animation).
Primary colored loading bar (thin, bottom of card, animated).
Auto-navigates to results in 2 seconds.

SCREEN W7 — Results (/results/sessionId)
Top: back-home icon (↩) + "Sonuçlar" (18px 600).
Score hero card (white, rounded-2xl, padding 28px, text-center):
"48 / 50" (36px bold, dark). "puan" (18px muted).
"%" + "96" (56px bold, success green). Below: progress ring (success, 96% fill, 80px).
"🥇 Sınıfta 1. sıradasınız" (16px, gold/amber, bold).
"18 dakika 32 saniyede tamamladınız" (14px muted).

Summary row (white card, 3 columns with dividers):
"46 ✓" green | "3 ✗" red | "1 –" gray.
Column labels: "Doğru" / "Yanlış" / "Boş".

Leaderboard section (if enabled):
Title "Sınıf Sıralaması". List: rank + name + score. Own row highlighted (primary-light bg, bold name).

Answer review section (if enabled):
Each question row: question short text + "✅ Doğru" or "❌ Yanlış · Doğru: D" below.
```

---

## BÖLÜM 10: Son Notlar için Stitch'e Ver

```
Additional design notes for all screens:

ANIMATIONS:
- Live status dot: CSS pulse animation, green, 1.5s infinite
- Waiting room pulse: scale 1.0–1.08, opacity 0.7–1, 1.5s infinite
- Timer warning <1min: subtle shake every 5 seconds
- Correct answer selection: scale 1.02 bounce, 150ms
- Button press: scale 0.97, 100ms
- Screen transitions: slide-right (push) / slide-left (pop)
- Checkmark on completion: SVG draw animation, 600ms

LOADING STATES:
- Skeleton screens (gray shimmer) for lists
- Spinner inside buttons (white, small) when loading
- Overlay blur for full-screen loading

EMPTY STATES:
- Soft geometric illustration (simple SVG)
- 20sp title text
- 16sp description muted
- Primary outlined button "Oluştur"

ERROR STATES:
- Red border on inputs
- Error icon + message below input
- Toast/snackbar: dark background, white text, bottom position
- Retry button for network errors

ACCESSIBILITY:
- Minimum contrast ratio 4.5:1 for all text
- Focus rings visible (2dp primary)
- Large tap targets everywhere
- Screen reader labels on all icons

Generate all screens with consistent design system. Export each screen as Figma layers with proper naming: [platform]_[screen-number]_[screen-name].
```

---

## Stitch'e Giriş Sırası

1. Google Stitch'i aç: `stitch.withgoogle.com`
2. "New Project" → proje adı: "ExamKit"
3. "Import Design System" → DESIGN.md yükle
4. **Bölüm 1** (Proje Bağlamı) → her seferinde context olarak ekle
5. **Bölüm 2** → 4 ekran üret, beğen/düzenle
6. **Bölüm 3** → 1 ekran
7. **Bölüm 4** → 3 ekran
8. **Bölüm 5** → 4 ekran
9. **Bölüm 6** → 3 ekran (MCQ + T/F + KA tabları)
10. **Bölüm 7** → 2 ekran
11. **Bölüm 8** → 3 ekran
12. **Bölüm 9** → 7 web ekranı
13. **Bölüm 10** → animasyon ve son notlar
14. Tüm ekranları "Stitch Together" ile prototype yap
15. Figma'ya export ET
16. Claude Code'da Google Stitch MCP ile tasarımı çek

## Claude Code'a Stitch MCP ile Tasarımı Çekme

```
Claude Code'da:
"Google Stitch MCP üzerinden ExamKit projesinin tüm 26 ekranını çek.
Flutter ekranları için Material Design 3 bileşenlerine dönüştür.
Next.js ekranları için Tailwind CSS ile responsive kodla.
CLAUDE.md'deki renk tokenlarını ve spacing sistemini kullan."
```
