# Web Uygulama (Öğrenci)

## Teknoloji
- Next.js 15 / React 19 / TypeScript
- Tailwind CSS (CDN)
- Firebase RTDB (Realtime Database)
- Vercel hosting

## Dosya Yapısı

```
student_web/
├── app/
│   ├── layout.tsx              # Root layout (Tailwind CDN, ErrorBoundary)
│   ├── page.tsx                # W1: Kod girişi
│   ├── join/[code]/page.tsx    # W2: İsim girişi + exam lookup (RTDB)
│   ├── waiting/[sid]/page.tsx  # W3: Bekleme odası (RTDB listener)
│   ├── exam/[sid]/page.tsx     # W4/W5: Sınav (scroll/sequential)
│   └── results/[sid]/page.tsx  # W7: Sonuçlar (RTDB realtime listener)
├── lib/
│   ├── firebase.ts             # Firebase init (getRtdb, getFirebaseApp)
│   ├── realtime.ts             # RTDB: live_exams subscription + writes
│   └── firestore.ts            # KULLANILMIYOR (Firestore kaldırıldı)
├── hooks/
│   └── useExamSession.ts       # KULLANILMIYOR (sayfalar direkt RTDB)
├── stores/
│   └── examStore.ts            # Zustand store (kısmen kullanılıyor)
└── components/                 # UI bileşenleri
```

## Sayfa Akışı

```
/ (ana sayfa)
  → kod gir
/join/{code}
  → exam RTDB'den lookup (exams node'da code ile ara)
  → isim + soyisim gir
  → session oluştur (sessions/ + sessions_by_exam/ + live_exams/)
  → localStorage: examkit_session, examkit_name, examkit_examId
/waiting/{sessionId}
  → subscribeToExamStatus (live_exams/{eid}/status → active → yönlen)
  → subscribeToStudents (live_exams/{eid}/students → öğrenci sayısı)
/exam/{sessionId}
  → RTDB'den soruları al (questions/{eid})
  → Cevapları RTDB'ye yaz (sessions/{sid}/answers/{qid})
  → Tamamla → sessions/{sid}/status: completed + markCompleted()
  → live_exams/{eid}/status: ended dinle → otomatik sonuç
/results/{sessionId}
  → onValue listener: sessions/{sid}/scoreCalculatedAt gelince göster
  → Leaderboard: leaderboards/{eid}
```

## Kritik Pattern'ler

### Firebase Init (HER sayfada)
```ts
import { getRtdb } from "@/lib/firebase";
function db() { return getRtdb()!; }
// ASLA direkt getDatabase() kullanma!
```

### RTDB Realtime Listener
```ts
import { onValue, ref } from "firebase/database";
onValue(ref(db(), `sessions/${sid}`), (snap) => {
  // veri değişince otomatik çalışır
});
```
