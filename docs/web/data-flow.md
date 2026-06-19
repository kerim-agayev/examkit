# Web Veri Akışı (Öğrenci Tarafı)

## Join (Katılım)

```
Kullanıcı kod girer → /join/{code}
├── RTDB READ: exams node'da code ile eşleşen exam ara (client-side filter)
├── Kullanıcı isim girer
└── RTDB WRITE:
    ├── sessions/{sid} (examId, studentName, status: active, answers: {})
    ├── sessions_by_exam/{eid}/{sid}: true
    └── live_exams/{eid}/students/{sid} (name, joinedAt, progress: 0, status: waiting)
```

## Waiting (Bekleme Odası)

```
/waiting/{sessionId}
├── localStorage'dan examId, name al
├── RTDB LISTEN: live_exams/{eid}/status → active ise /exam/{sid}'e yönlen
├── RTDB LISTEN: live_exams/{eid}/students → öğrenci sayısı (onValue)
└── RTDB LISTEN: live_exams/{eid}/status → ended ise /results/{sid}'e yönlen
```

## Exam (Sınav)

```
/exam/{sessionId}
├── RTDB READ: sessions/{sid} → examId
├── RTDB READ: questions/{examId} → soru listesi (client-side orderIndex sort)
├── Kullanıcı cevap seçer
│   └── RTDB WRITE: sessions/{sid}/answers/{qid} (value, timestamp)
├── Kullanıcı tamamlar (finish)
│   ├── RTDB UPDATE: sessions/{sid} (status: completed, completedAt)
│   └── RTDB UPDATE: live_exams/{eid}/students/{sid} (status: completed)
│   └── Yönlen: /results/{sid}
└── RTDB LISTEN: live_exams/{eid}/status → ended ise /results/{sid}'e yönlen
```

## Results (Sonuçlar)

```
/results/{sessionId}
├── RTDB LISTEN: sessions/{sid} (onValue — scoreCalculatedAt gelene kadar bekle)
│   ├── scoreCalculatedAt null → "Öğretmen puanlama yapıyor, bekleyin..."
│   └── scoreCalculatedAt var → puanı, yüzdeyi, sıralamayı göster
└── RTDB READ: leaderboards/{examId} → sınıf sıralaması
```
