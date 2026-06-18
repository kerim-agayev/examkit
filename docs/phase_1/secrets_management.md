# ExamKit — Secret Yönetimi (Firebase Kimlik Bilgileri)

> **Durum:** Aktif. Phase 1 boyunca geçerlidir.
> **İlgili ADR'ler:** ADR-001 (Spark tier), ADR-002 (Google Sign-In)
> **Risk sınıfı:** Yüksek (sızıntı → quota abuse, yetkisiz RTDB erişimi)

---

## 1. Neden Bu Doküman Var?

`google-services.json` (Android) ve `for_firebase.txt` (Web) dosyaları canlı Firebase
projesinin kimlik bilgilerini içerir. Bu değerler "restricted public key" olsa da,
açık RTDB kurallarıyla (`students` node `".read": true, ".write": true`) birleşince
**gerçek bir sömürülebilir risk** oluşturur. Bu dosya, secret'ların:

- Repoya (GitHub dahil) **commit edilmesini** engellemek
- Hangi key'in **nerede** kullanıldığını izlemek
- **Rotation** ve **sızıntı sonrası** müdahale prosedürünü tanımlamak

için tek kaynak (single source of truth) olarak yazılmıştır.

---

## 2. Secret Envanteri

| # | Dosya (gitignored) | Platform | İçerdiği key | Kim okur | Nerde saklanmalı |
|---|--------------------|----------|--------------|----------|------------------|
| 1 | `google-services.json` | Android (Flutter) | Android API key + app id + OAuth client | Flutter build (`flutter_app/android/app/`) | Lokal FS, **asla repo** |
| 2 | `GoogleService-Info.plist` | iOS (Flutter) | iOS API key + bundle id | Flutter build (`flutter_app/ios/Runner/`) | Lokal FS, **asla repo** |
| 3 | `for_firebase.txt` (örnek haldi) | Web (Next.js) | Web API key + app id + measurement id | `student_web/` env | `.env.local` (**asla repo**) |
| 4 | Firestore/RTDB **security rules** | Backend | Yok (kural dosyaları) | Firebase CLI deploy | Repo içinde **güvenli** |

> Not: Şu anda projede `google-services.json` kök dizinde, `for_firebase.txt` ise
> `docs/phase_1/` altında. **İkisi de `.gitignore`'a alındı.** Yerleri ADR-006'dan
> sonra taşınmalı: `google-services.json` → `flutter_app/android/app/`,
> web config → `student_web/.env.local`.

### Tutarlılık Notu (Mevcut Durum)
Aynı Firebase projesi (`examkit-c39fc`) için **iki farklı API key** mevcut:
- Android key: `AIzaSyBB…` (`google-services.json`)
- Web key: `AIzaSyAdp…` (`for_firebase.txt`)

Bu **beklenen** bir durumdur (Firebase platform başına ayrı key üretir). Risk,
rotation sırasında iki dosyanın senkronizasyonunun unutulmasıdır. Rotation
prosedürü §5'e bakın.

---

## 3. Repoya Commit Edilemez Listesi (`.gitignore` alıntı)

```
google-services.json
GoogleService-Info.plist
docs/phase_1/for_firebase.txt
**/google-services.json
**/GoogleService-Info.plist
**/firebase-config*.json
**/.env.local
**/.env.*.local
```

**Örnek (placeholder)** dosyalar repoya commit edilir:
- `google-services.example.json` (kök)
- `docs/phase_1/for_firebase.example.txt`

Gerçek dosyalar bu şablonlardan kopyalanıp değerleri doldurularak oluşturulur.

---

## 4. Developer Onboarding (Yeni Geliştirici)

Yeni bir geliştirici projeyi klonladığında:

1. Firebase Console'a erişim iste (proje: `examkit-c39fc`)
2. Console > Project Settings:
   - Android app → `google-services.json` indir → `flutter_app/android/app/` (Flutter scaffold sonrası)
   - iOS app → `GoogleService-Info.plist` indir → `flutter_app/ios/Runner/`
   - Web app → Config snippet → `.env.local` olarak `student_web/` altına
3. `student_web/.env.local` örneği için `docs/phase_1/for_firebase.example.txt`'e bak
4. `git status` ile secret dosyalarının **untracked + ignored** olduğunu doğrula:
   ```bash
   git check-ignore -v google-services.json
   git check-ignore -v docs/phase_1/for_firebase.txt
   # her ikisi de .gitignore satırı dönmeli
   ```

---

## 5. Rotation Prosedürü (Key Yenileme)

Bir API key'in rotate edilmesi gerektiğinde (şüpheli sızıntı, periyodik):

1. **Firebase Console > Project Settings > "Web/Android SDK Config"** → yeni key üret
2. Eski key'i **revoke** et (Console'dan "Delete API key")
3. **Tüm** dosyaları aynı anda güncelle — tek kontrol listesi:
   - [ ] `google-services.json` (Android key) — lokal, build makinesi
   - [ ] `GoogleService-Info.plist` (iOS key) — lokal, build makinesi
   - [ ] `student_web/.env.local` (Web key) — tüm deploy ortamları (Cloudflare Pages env vars!)
   - [ ] Cloudflare Pages dashboard > Settings > Environment variables
4. Yeni key'in çalıştığını doğrula: web + Android launch, Auth + Firestore + RTDB OK
5. `docs/phase_1/logs/` altına rotation kaydı düş (tarih, neden, yapan)

> ⚠️ **Cloudflare Pages unutulması en sık hatadır** — oradaki env var'lar
> manuel güncellenmeli. Deploy sırasında `.env.local` **kullanılmaz**.

---

## 6. Sızıntı Sonrası Müdahale Planı

Eğer bir secret'ın commit edildiği/sızdığı tespit edilirse:

### 6.1 Acil (ilk 1 saat)
1. Firebase Console → ilgili API key'i **hemen revoke** et
2. Etkilenen deploy'ları durdur (Cloudflare Pages deploy pause)
3. RTDB'de `live_exams/` okuma hacmini kontrol et (quota abuse belirtisi)

### 6.2 Kısa vade (ilk 24 saat)
4. Yeni key üret (§5 rotation)
5. **Git history'den temizlik** — `git filter-repo` veya BFG Repo-Cleaner:
   ```bash
   # BFG örneği
   bfg --delete-files google-services.json
   bfg --delete-files "for_firebase.txt"
   git reflog expire --expire=now --all && git gc --prune=now --aggressive
   git push --force
   ```
6. GitHub > Settings > Secret scanning varsa aktif et (varsayılan public repolarda açık)
7. Tüm collaborator'lar `git pull --rebase` yapsın (history değişti)

### 6.3 Uzun vade
8. Post-mortem: `docs/phase_1/bugs/` altına yeni kayıt
9. `.gitignore` + pre-commit hook'a secret taraması ekle (örn. `gitleaks`)

---

## 7. Ek Sorumluluklar

### 7.1 RTDB Security Rules (Yanı Sıra Sıkılaştırma Gereken)
Mevcut `firebase_schema.md` örneğinde `students` node'u tam açık:
```
"students": { ".read": true, ".write": true }
```
Bu, secret sızıntısıyla birleşince riski katlar. Phase 1 implementation öncesi:
- `".write"` kısıtlanmalı: sadece teacher app auth id'si yazabilmeli
- `".read"` session-id doğrulamasıyla kısıtlanmalı (server-side validation)

> Bkz. `architecture/firebase_schema.md` — Security Rules bölümünün revize
> edilmesi takip eden adımlardan biridir.

### 7.2 Pre-commit Hook (Önerilen)
Repo kökünde `.gitleaks.toml` + Git hook ile commit öncesi otomatik tarama:
```bash
# .git/hooks/pre-commit
gitleaks protect --staged --redact --config .gitleaks.toml
```

---

## 8. Onay ve Tarihçe

| Tarih | Değişiklik | Yapan |
|-------|------------|-------|
| 2026-06-18 | İlk oluşturma; canlı key'ler tespit edildi, `.gitignore` alındı | (Risk çözüm planı) |
