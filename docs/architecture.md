# Mimari

## Genel Yapı

```
Öğretmen (Flutter)          Öğrenci (Next.js)
Android APK                 Tarayıcı Web
Google Sign-In              İsimle katılım
     │                            │
     │   auth != null            │   anonim
     │                            │
     └──────────┬─────────────────┘
                │
         Firebase RTDB
         (WebSocket)
         europe-west1
                │
          Vercel (CDN)
     examkit-beta.vercel.app
```

## RTDB Veri Yapısı

### Neden RTDB?

Firestore gRPC bağlantısı bu projede çalışmadı. Admin API veritabanını görüyordu ama data plane `NOT_FOUND: database does not exist` hatası veriyordu. Billing, test mode rules, farklı bölgeler denendi — hiçbiri çalışmadı. RTDB ise sorunsuz çalıştı. Detay: [decisions.md](./decisions.md)

### Veri Ağacı

```
examkit-5e691-default-rtdb/
├── users/{uid}/                  name, school, lang, updatedAt
├── groups/{groupId}/             name, teacherId, description, examCount, createdAt
├── groups_by_teacher/{uid}/{gid}/ createdAt (index)
├── exams/{examId}/               title, ownerTeacherId, groupId, groupName, status, mode, code, settings{}, createdAt
├── exams_by_teacher/{uid}/{eid}/ createdAt (index)
├── questions/{examId}/{qid}/     text, type, options[], points, orderIndex
├── exam_answers/{examId}/{qid}/  correctOptionId|correctBool|acceptedAnswers (SADECE ÖĞRETMEN)
├── sessions/{sid}/               examId, studentName, status, answers{}, score, percentage, rank, scoreCalculatedAt
├── sessions_by_exam/{eid}/{sid}/ true (index)
├── leaderboards/{examId}/{sid}/  rank, studentName, score, percentage
└── live_exams/{examId}/          teacherId, status, students/{sid}/  (canlı senkronizasyon)
```

## Tipik Sınav Akışı

| Adım | Öğretmen | RTDB Write | Öğrenci |
|---|---|---|---|
| 1 | Grup oluştur | groups/ + groups_by_teacher/ | — |
| 2 | Sınav oluştur (5 adım) | exams/ + exams_by_teacher/ | — |
| 3 | Soru ekle | questions/{eid}/ + exam_answers/{eid}/ | — |
| 4 | Yayınla | exams/{eid}/code, status: active | — |
| 5 | — | — | /join/{kod} → isim gir |
| 6 | — | sessions/{sid}, live_exams/{eid}/students/{sid} | Katılım |
| 7 | — | — | Bekleme odası (öğrenci sayısı) |
| 8 | Sınavı başlat | live_exams/{eid}/status: active | Otomatik yönlenme |
| 9 | — | sessions/{sid}/answers/{qid} | Cevaplama |
| 10 | Canlı kontrol | live_exams/{eid}/students | Sınavı bitir |
| 11 | Sınavı bitir → puanlama | ScoreCalculator → leaderboards/ | Otomatik sonuç |
| 12 | Sonuçları gör | leaderboards/{eid} | Sonuç sayfası |
