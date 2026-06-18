# ExamKit — Test Stratejisi

> **Durum:** Phase 1 planı. Test henüz uygulanmadı (uygulama kodu yazılmadı).
> **Son güncelleme:** 2026-06-18 (initial — risk çözüm planından)

---

## 1. Test Framework Seçimi

| Platform | Framework | Unit/Widget | Integration | Mock |
|----------|-----------|-------------|-------------|------|
| Flutter | `flutter_test` (built-in) + `integration_test` (built-in) | ✅ | ✅ | `mocktail` |
| Next.js | `vitest` + `playwright` | ✅ | ✅ | `vitest` (built-in mock) |
| Firebase Rules | `@firebase/rules-unit-testing` | — | ✅ (Emulator) | — |

> **Neden vitest değil jest?** Vitest — Next.js 15 + TypeScript ile daha iyi **ESM native** desteği, hızlı başlatma, **playwright** ile kolay entegrasyon. Jest'in CJS/ESM transform sorunları dokümante edilmiş.

---

## 2. Test Piramidi (60/30/10)

```
       ╱ 10% E2E (playwright) ╲
      ╱   30% Integration     ╲
     ╱   (firestore emu)      ╲
    ╱      60% Unit            ╲
   ╱   (flutter_test / vitest)  ╲
```

---

## 3. Coverage Hedefleri

| Katman | Hedef | Kritik |
|--------|-------|--------|
| ScoreCalculator (Flutter) | **%100** | 🔴 Puanlama hatası = geri dönülemez |
| AuthService | %85 | 🟡 Login akışı edge case'leri |
| GroupRepository | %80 | 🟡 Duplicate name, silme kısıtları |
| ExamRepository | %80 | 🟡 Transaction + unique code |
| SessionRepository | %80 | 🟡 Shuffle + race condition |
| LiveExamRepository (RTDB) | %75 | 🟡 Bağlantı kopması, 0 öğrenci |
| QuestionRepository | %75 | 🟡 ExamAnswer ayrımı |
| lib/firestore.ts (Next.js) | %80 | 🟡 Offline persistence |
| lib/realtime.ts (Next.js) | %75 | 🟡 `getRemainingMs` accuracy |
| UI Components | Smoke test yeterli | 🟢 UI değişken, mantık basit |

---

## 4. Kritik Test Senaryoları (ZORUNLU — red/green öncesi test kodu hazır olmalı)

### 4.1 ScoreCalculator (En Kritik)
| ID | Senaryo | Beklenen |
|----|---------|----------|
| SC-01 | Tüm MCQ doğru, tek tip soru, 3 puanlık | `score = 3`, `percentage = 100`, `rank = 1` |
| SC-02 | Karışık tip (MCQ + T/F + KA), yanlış cevaplar | Kısmi puan, `percentage < 100` |
| SC-03 | 0 soru (edge) | `score = 0`, `divide by zero kontrolü` — crash YOK |
| SC-04 | Aynı sınavı 3 kez `calculateAllScores` çağır | Her seferinde **aynı** sonuç (idempotent) |
| SC-05 | Tie-break (2 öğrenci aynı score, farklı süre) | Daha hızlı yapan > daha yavaş (rank üstünlüğü) |
| SC-06 | Boş cevap (`answers(Map)`'ta key eksik) | 0 puan, crash YOK |
| SC-07 | Kısa cevap — case insensitive | `"Ankara" == "ankara"` `acceptedAnswers` içindeyse doğru |
| SC-08 | Kısa cevap — whitespace trim | `"  cevap  " == "cevap"` |
| SC-09 | `totalPoints = 0` (hiç soru yok) | `percentage = 0`, division by zero YOK |

### 4.2 Sınav Kodu Üretimi
| ID | Senaryo | Beklenen |
|----|---------|----------|
| EC-01 | Unique code — firestore transaction retry | 3 retry içinde unique kod bulunur |
| EC-02 | Harf seti: I, O, Q, 0, 1 YOKTUR | `generateCode` regex: `^[A-HJ-NP-Z2-9]{6}$` |

### 4.3 Global Timer
| ID | Senaryo | Beklenen |
|----|---------|----------|
| GT-01 | Late joiner: normal süre 20 dk, 5 dk geç katılır | `getRemainingMs` → ~15 dk |
| GT-02 | `globalTimerEndsAt` geçmişte | `Math.max(0, ...)` → 0, crash YOK |
| GT-03 | Client clock skew ±5 dk | RTDB `/.info/serverTimeOffset` düzeltir → sapma < 2 sn |

### 4.4 Security Rules (Firebase Emulator)
| ID | Senaryo | Beklenen |
|----|---------|----------|
| SR-01 | Öğrenci `exams/{id}/exam_answers/` okumaya çalışır | `PERMISSION_DENIED` |
| SR-02 | Öğretmen `exam_answers/` okuyabilir | Data döner |
| SR-03 | Öğrenci `live_exams/{id}/students` yazabilir | Allow (öğrenci own session) |
| SR-04 | Kimliksiz öğrenci draft sınav okuyamaz | `PERMISSION_DENIED` |

### 4.5 Sequential Mode
| ID | Senaryo | Beklenen |
|----|---------|----------|
| SQ-01 | Cevap yok → "İlerle" butonu disabled | `opacity = 0.4`, tıklanamaz |
| SQ-02 | Cevap seç → "İlerle" enabled | 5 sn içinde seçim değiştirilebilir |
| SQ-03 | Son soru → "Sınavı Tamamla" → confirm dialog | Dialog OK/Cancel, Cancel = kapanmaz |
| SQ-04 | Soru timer 5 sn kala | Geri sayım animasyonu, 0'da otomatik geçiş |
| SQ-05 | Geri dönüş yok (sequential constraint) | Sayfa yenilese bile `currentIndex` ilerlemez (shuffle server'da) |

---

## 5. CI/CD Entegrasyonu

### GitHub Actions — Test Matrix (önerilen `.github/workflows/test.yml`)

```yaml
name: Test Suite

on: [push, pull_request]

jobs:
  flutter-test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        test-type: [unit, widget]
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.44.0' }
      - run: flutter pub get
        working-directory: flutter_app
      - name: Run ${{ matrix.test-type }} tests
        run: flutter test
        working-directory: flutter_app

  nextjs-test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        test-type: [vitest, playwright]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '22' }
      - run: npm ci
        working-directory: student_web
      - name: Run vitest
        if: matrix.test-type == 'vitest'
        run: npm test -- --coverage
        working-directory: student_web
      - name: Run Playwright E2E
        if: matrix.test-type == 'playwright'
        run: npm run test:e2e
        working-directory: student_web

  firebase-emulator:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '22' }
      - run: npm install -g firebase-tools
      - run: firebase emulators:exec 'npm run test:rules'
```

---

## 6. Lokal Test Komutları

```bash
# Flutter
cd flutter_app && flutter test                          # Unit
cd flutter_app && flutter test integration_test         # Integration
cd flutter_app && flutter test --coverage               # + coverage

# Next.js
cd student_web && npm test                     # vitest (unit)
cd student_web && npm test -- --coverage       # vitest + coverage
cd student_web && npm run test:e2e             # playwright (headless)
cd student_web && npm run test:e2e -- --ui     # playwright UI debug

# Firebase rules
firebase emulators:exec --only firestore 'npm run test:rules'
```

---

## 7. Phase 1 Implementasyon Sırası ve Test Placement

`docs/phase_1/index.md`'deki iş sırasına **her Step'te** test eklenir:

| Step | Adım | Test Placement |
|------|------|---------------|
| 1 | Proje scaffold | `.github/workflows/test.yml`, test config kurulumu |
| 3 | Auth (Flutter) | `flutter_app/test/auth/` |
| 4 | Grup Yönetimi | `flutter_app/test/groups/` |
| 5-6 | Sınav + Soru | `flutter_app/test/exams/` + `flutter_app/test/questions/` |
| 7 | ScoreCalculator | `flutter_app/test/features/results/` — **ÖNCE test, SONRA kod** |
| 8-9 | Student Web | `student_web/test/` → unit + E2E |
| 10 | Firebase Rules | `firestore.rules` test (emulator) |
| 14 | Final test + polish | Tüm coverageler toplanır, Lighthouse 90+ |

---

## 8. Lighthouse & Erişilebilirlik (Next.js Student Web)

- **Mobile Lighthouse hedefi:** ≥ 90 (Performance, Accessibility, Best Practices, SEO)
- **Kontrol noktaları:**
  - 375px, 390px, 768px responsive (playwright `viewport` testleri)
  - Next.js Image optimization (`next/image` kullanılacaksa)
  - `axe-core` playwright plugin ile a11y audit (renk kontrastı, aria label'ler, tab order)

---

## 9. Altın Standart (Golden Standard)

**TDD kullanılacak alanlar:**
1. ✅ `ScoreCalculator` — %100 coverage hedefi → **test-first yazılacak TEK sınıf**
2. Global timer `getRemainingMs` — matematiksel olarak belirlenebilir sonuç
3. Security rules — Firebase emulator'da `assertFails` / `assertSucceeds`

**Diğer katmanlarda (Repository, Provider, UI):** test-after.
Refaktör veya regression oldukça test eklenir.

---

## 10. Firestore Emulator ile Offline Test

Firebase Rules + client kodu birlikte test edilirken gerçek Firebase'e bağlanılmaz:

```bash
# firebase.json
{
  "emulators": {
    "firestore": { "port": 8080 },
    "database": { "port": 9000 }
  }
}

# Test başlat
firebase emulators:exec 'npm run test:rules'
```

Local emulator → tüm testler offline çalışır, Firebase quota tüketilmez, clean state her seferinde.

---

Bu belge Phase 1 implementation başladığı anda **yaşayan belge** olarak güncellenmelidir.
Test framework kurulum adımları scaffold sırasında uygulanır.
