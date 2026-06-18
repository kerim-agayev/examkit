# ADR-002: Öğretmen Girişi için Google Sign-In (SMS OTP değil)

**Tarih:** Haziran 2026  
**Durum:** accepted

## Bağlam
Öğretmenler uygulamaya güvenli şekilde giriş yapmalı. İki seçenek değerlendirildi: telefon numarası ile SMS OTP veya Google hesabı ile SSO.

## Karar
**Google Sign-In** kullanılacak.

## Gerekçe
- Firebase SMS OTP her mesaj için $0.01–$0.06 ücretli — MVP için maliyet yaratır
- Google Sign-In Firebase Spark planında ücretsiz (50K MAU/ay)
- Azerbaycan ve Türkiye'de öğretmenlerin neredeyse tamamı Gmail hesabına sahip
- UX daha hızlı: telefon numarası + SMS bekleme yerine tek tuş

## Sonuçlar
- MVP maliyeti sıfır kalır
- Öğretmen hesabı = Google hesabı (profil fotoğrafı otomatik)
- SMS OTP Faz 3'te ek seçenek olarak eklenebilir

## Alternatifler
- SMS OTP — Kullanıcı dostu ama ücretli, MVP için uygun değil
- E-posta + şifre — Şifre unutma akışı gerektirir, UX daha kötü
- Apple Sign-In — iOS zorunlu kılar, Android'de ek iş
