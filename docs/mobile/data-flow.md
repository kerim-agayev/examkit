# Mobil Veri Akışı (Öğretmen Tarafı)

## Grup Oluşturma

```
Kullanıcı Grup Adı girer → Kaydet
├── RTDB WRITE (multi-path update):
│   ├── groups/{gKey} (name, teacherId, description, examCount: 0, createdAt: now)
│   └── groups_by_teacher/{uid}/{gKey}: now
└── UI: context.pop() → group listesinde görünür (watchGroupsProvider)
```

## Sınav Oluşturma (5 Adım)

```
1. Temel Bilgiler (exam_create_screen)
   ├── Başlık + Grup seç
   └── RTDB WRITE (multi-path):
       ├── exams/{eKey} (title, groupId, ownerTeacherId, status: draft, ...)
       ├── exams_by_teacher/{uid}/{eKey}: now
       └── groups/{gid}/examCount: increment(1)

2. Ayarlar (exam_settings_screen)
   └── State: mode, timer, shuffle, showScore (sadece CreateExamState)

3. Sorular (question_list_screen + question_editor_screen)
   ├── RTDB READ: questions/{examId} (StreamBuilder + onValue)
   ├── Soru ekle → RTDB WRITE (multi-path):
   │   ├── questions/{eid}/{qKey}
   │   ├── exam_answers/{eid}/{qKey}
   │   └── exams/{eid}/questionCount: increment(1)
   └── Soru sil → RTDB WRITE (multi-path null)

4. Önizleme (exam_preview_screen)
   └── RTDB UPDATE: exams/{eid} (mode, settings{}, status: published)

5. Paylaş (share_screen)
   ├── Kod üret (ExamCodeGenerator)
   ├── RTDB UPDATE: exams/{eid} (code, status: active)
   └── WhatsApp / Link Kopyala / Kod Kopyala
```

## Canlı Kontrol (live_control_screen)

```
/exams/{examId}/live
├── RTDB LISTEN: live_exams/{examId} (watchLiveExamProvider)
│   ├── students sayısı, isimleri, durumları
│   └── completedCount (tamamlayan öğrenci sayısı)
├── Sınavı Başlat:
│   └── RTDB WRITE: live_exams/{eid} (teacherId, status: active, startedAt)
└── Sınavı Bitir:
    ├── RTDB WRITE: live_exams/{eid} (status: ended)
    ├── ScoreCalculator.calculateAllScores(eid)
    │   ├── exam_answers/{eid} → doğru cevaplar
    │   ├── questions/{eid} → puan değerleri
    │   ├── sessions_by_exam/{eid} → tüm session'lar
    │   ├── Her session için puan hesapla → sessions/{sid} (score, percentage, rank)
    │   └── leaderboards/{eid} → sıralı liste
    └── Navigate: /exams/{eid}/results
```

## Sonuçlar (results_screen)

```
/exams/{examId}/results
├── RTDB LISTEN: leaderboards/{examId} (StreamBuilder + onValue)
│   ├── Katılımcı sayısı, Ortalama %, En Yüksek %
│   └── Sıralama listesi (🥇🥈🥉 + isim + puan)
```
