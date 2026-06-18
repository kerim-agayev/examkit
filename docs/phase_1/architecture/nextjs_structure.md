# Next.js Öğrenci Web Mimarisi

**Framework:** Next.js 15.5 (App Router)  
**State:** Zustand 5  
**Styling:** Tailwind CSS 4  
**Firebase:** Web SDK 11

---

## Sayfa Yapısı (App Router)

```
app/
├── layout.tsx              # Root: Firebase init, i18n provider
├── page.tsx                # "/" — Kod giriş sayfası
│
├── join/[code]/
│   └── page.tsx            # Ad-soyad girişi
│                           # URL: /join/MAT7K2
│
├── waiting/[sessionId]/
│   └── page.tsx            # Bekleme odası
│                           # RTDB stream: examStatus
│
├── exam/[sessionId]/
│   └── page.tsx            # Sınav — mode'a göre render
│                           # 'scroll' | 'sequential'
│
└── results/[sessionId]/
    └── page.tsx            # Sonuçlar + liderboard
```

---

## Veri Akışı

```
URL Parametresi (code / sessionId)
    ↓
Server Component (page.tsx) — ilk veri çekimi
    ↓
Client Component — real-time subscription
    ↓
Zustand Store — lokal state
    ↓
UI Bileşenleri
```

---

## Zustand Store Yapısı

```typescript
// stores/examStore.ts
interface ExamStore {
  // Sınav verisi
  exam: Exam | null;
  questions: Question[];
  sessionId: string | null;
  studentName: string | null;

  // Sınav state
  status: 'waiting' | 'active' | 'completed';
  currentQuestionIndex: number;  // Sequential için
  answers: Record<string, AnswerValue>;
  timeLeft: number | null;
  confirmAdvance: boolean;       // Sequential: onay akışı (ADR-005)

  // Aksiyonlar
  setExam: (exam: Exam) => void;
  setAnswer: (questionId: string, value: AnswerValue) => void;
  submitExam: () => Promise<void>;
  setStatus: (status: string) => void;
}
```

---

## Server vs Client Component Kuralı

```typescript
// Server Component (varsayılan) — SEO, ilk yükleme hızı
// page.tsx — exam verisini server'da çek
export default async function ExamPage({ params }) {
  const session = await getSession(params.sessionId);  // Firestore
  return <ExamClient session={session} />;
}

// Client Component — real-time, interaktif
// 'use client' sadece gerektiğinde
'use client';
export function ExamClient({ session }) {
  useRealtimeSync(session.examId);  // RTDB subscription
  // ...
}
```

---

## Offline Cevap Koruma

```typescript
// hooks/useExamSession.ts
// Cevaplar hem Zustand state'te hem localStorage'da tutulur
// Sayfa yenilenirse localStorage'dan restore edilir

const saveAnswer = useCallback((questionId: string, value: AnswerValue) => {
  setAnswer(questionId, value);  // Zustand
  const key = `exam_answers_${sessionId}`;
  const stored = JSON.parse(localStorage.getItem(key) || '{}');
  stored[questionId] = { value, savedAt: Date.now() };
  localStorage.setItem(key, JSON.stringify(stored));
  // Firestore'a da yaz (offline durumda kuyrukta bekler)
  saveAnswerToFirestore(sessionId, questionId, value).catch(/* retry */);
}, [sessionId]);
```

---

## i18n (next-intl)

```typescript
// messages/az.json
{
  "join": { "title": "İmtahana qoşul", "enterCode": "Kodu daxil et" },
  "waiting": { "title": "Müəllimi gözləyin..." },
  "exam": { "submit": "Göndər", "next": "İrəli" }
}

// Kullanım
const t = useTranslations('exam');
<button>{t('submit')}</button>
```
