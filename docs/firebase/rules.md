# RTDB Güvenlik Kuralları

## Mevcut Kurallar (`database.rules.json`)

### Erişim Seviyeleri

| Node | Read | Write |
|---|---|---|
| `users/{uid}` | auth && uid match | auth && uid match |
| `groups/{gid}` | auth | auth && teacherId match |
| `groups_by_teacher/{uid}` | auth && uid match | auth && uid match |
| `exams/{eid}` | **public** | auth && ownerTeacherId match |
| `exams_by_teacher/{uid}` | auth && uid match | auth && uid match |
| `questions/{eid}` | **public** | auth |
| `exam_answers/{eid}` | **auth only** | **auth only** |
| `sessions/{sid}` | **public** | **public** |
| `sessions_by_exam/{eid}` | **public** | **public** |
| `leaderboards/{eid}` | **public** | auth |
| `live_exams/{eid}` | **public** | kısmi (teacherId, status: auth, students: özel) |

### Neden Bazı Node'lar Public?

Öğrenciler Google hesabıyla giriş yapmaz (sadece isimle katılır). `exams`, `questions`, `sessions`, `leaderboards` bu yüzden herkese açıktır. Hassas veri (`exam_answers` — doğru cevaplar) sadece `auth != null` ile korunur.

## Deploy

```bash
firebase deploy --only database
```

Kurallar anında geçerli olur, deploy süresi ~5 saniye.
