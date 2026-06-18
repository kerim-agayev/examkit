/**
 * ExamKit — Firestore veri katmanı.
 * Öğrenci web tarafından çağrılan tüm Firestore fonksiyonları.
 * Bkz: docs/phase_1/architecture/api_design.md
 *
 * ÖNEMLİ: Bu fonksiyonlar sadece öğrencinin OKUYABİLDİĞİ verilere erişir.
 * Doğru cevaplar (exam_answers/) ÖĞRENCİ TARAFINDAN OKUNAMAZ.
 * Puanlama öğretmen Flutter uygulamasında yapılır (ADR-006).
 */

import {
  getFirestore,
  collection,
  query,
  where,
  getDocs,
  getDoc,
  doc,
  setDoc,
  updateDoc,
  serverTimestamp,
  runTransaction,
  orderBy,
  limit,
  type Firestore,
  type Timestamp,
} from "firebase/firestore";

function db(): Firestore {
  return getFirestore();
}

// ============================================================================
// Types
// ============================================================================

export interface Exam {
  id: string;
  title: string;
  code: string;
  status: "draft" | "active" | "live" | "completed";
  mode: "scroll" | "sequential";
  groupId?: string;
  groupName?: string;
  teacherId: string;
  teacherName: string;
  settings: ExamSettings;
  questionCount: number;
  totalPoints: number;
  createdAt: Timestamp;
}

export interface ExamSettings {
  globalTimerMinutes: number | null;
  questionTimerSeconds: number | null;
  shuffleQuestions: boolean;
  shuffleOptions: boolean;
  showScore: boolean;
  showCorrectAnswers: boolean;
  showLeaderboard: boolean;
}

export interface Question {
  id: string;
  text: string;
  type: "mcq" | "true_false" | "short_answer";
  options?: string[];
  points: number;
  timerSeconds: number | null;
  orderIndex: number;
}

export interface Session {
  id: string;
  examId: string;
  studentName: string;
  status: "active" | "completed";
  answers: Record<string, { value: string | boolean; timestamp: Timestamp }>;
  questionOrder: string[];
  optionOrders: Record<string, string[]>;
  score?: number;
  percentage?: number;
  rank?: number;
  scoreCalculatedAt?: Timestamp;
  startedAt: Timestamp;
  completedAt?: Timestamp;
}

export interface LeaderboardEntry {
  rank: number;
  name: string;
  score: number;
  percentage: number;
  durationMs: number;
}

// ============================================================================
// Exam Lookup
// ============================================================================

/**
 * Sınav koduna göre exam dökümanını bul.
 * Sadece status !== 'draft' olan sınavlar döner.
 */
export async function getExamByCode(code: string): Promise<Exam | null> {
  const q = query(
    collection(db(), "exams"),
    where("code", "==", code.toUpperCase()),
    where("status", "!=", "draft"),
    limit(1)
  );
  const snap = await getDocs(q);
  if (snap.empty) return null;
  return { id: snap.docs[0]!.id, ...snap.docs[0]!.data() } as Exam;
}

/**
 * Sınav sorularını getir (DOĞRU CEVAPLAR HARİÇ).
 * exam_answers/ ayrı koleksiyondadır — öğrenci okuyamaz.
 */
export async function getExamQuestions(examId: string): Promise<Question[]> {
  const q = query(
    collection(db(), `exams/${examId}/questions`),
    orderBy("orderIndex")
  );
  const snap = await getDocs(q);
  return snap.docs.map((d) => ({
    id: d.id,
    ...d.data(),
  })) as Question[];
}

// ============================================================================
// Session Management
// ============================================================================

/**
 * Session oluştur — shuffle hesapla ve kaydet.
 * Aynı isim kontrolü transaction ile yapılır (race condition önlem).
 */
export async function createSession(params: {
  examId: string;
  studentName: string;
  questionIds: string[];
  shuffleQuestions: boolean;
  shuffleOptions: boolean;
  optionsMap: Record<string, string[]>; // questionId → ["A","B","C","D"]
}): Promise<{ sessionId: string; questionOrder: string[]; optionOrders: Record<string, string[]> }> {
  const { examId, studentName, questionIds, shuffleQuestions, shuffleOptions, optionsMap } = params;

  // Shuffle helpers
  const shuffle = <T>(arr: T[]): T[] => {
    const a = [...arr];
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [a[i], a[j]] = [a[j]!, a[i]!];
    }
    return a;
  };

  const questionOrder = shuffleQuestions ? shuffle(questionIds) : questionIds;
  const optionOrders: Record<string, string[]> = {};
  for (const qId of questionIds) {
    const opts = optionsMap[qId];
    if (opts && shuffleOptions) {
      optionOrders[qId] = shuffle(opts);
    } else if (opts) {
      optionOrders[qId] = opts;
    }
  }

  // Transaction: duplicate name kontrolü + session oluşturma
  const sessionRef = doc(collection(db(), "sessions"));

  await runTransaction(db(), async (tx) => {
    // Aynı isim kontrolü
    const dupQuery = query(
      collection(db(), "sessions"),
      where("examId", "==", examId),
      where("studentName", "==", studentName),
      limit(1)
    );
    const dupSnap = await getDocs(dupQuery);
    if (!dupSnap.empty) {
      // Aynı isim varsa suffix ekle
      const suffix = Math.floor(Math.random() * 1000);
      const newName = `${studentName} (${suffix})`;
      tx.set(sessionRef, {
        examId,
        studentName: newName,
        status: "active",
        answers: {},
        questionOrder,
        optionOrders,
        startedAt: serverTimestamp(),
      });
    } else {
      tx.set(sessionRef, {
        examId,
        studentName,
        status: "active",
        answers: {},
        questionOrder,
        optionOrders,
        startedAt: serverTimestamp(),
      });
    }
  });

  return { sessionId: sessionRef.id, questionOrder, optionOrders };
}

/**
 * Cevap kaydet — Firestore'a yaz.
 * Offline durumda Firestore persistence kuyruğa atar.
 */
export async function saveAnswer(
  sessionId: string,
  questionId: string,
  value: string | boolean
): Promise<void> {
  const ref = doc(db(), "sessions", sessionId);
  await updateDoc(ref, {
    [`answers.${questionId}`]: {
      value,
      timestamp: serverTimestamp(),
    },
  });
}

/**
 * Session'ı tamamlandı olarak işaretle.
 * NOT: Puanlama yapılmaz — öğretmen Flutter uygulaması yapacak.
 */
export async function completeSession(sessionId: string): Promise<void> {
  const ref = doc(db(), "sessions", sessionId);
  await updateDoc(ref, {
    status: "completed",
    completedAt: serverTimestamp(),
  });
}

// ============================================================================
// Results (Read-only — teacher yazmış olmalı)
// ============================================================================

/**
 * Session sonucunu getir.
 * scoreCalculatedAt null ise: öğretmen henüz puanlamamış.
 * Bkz: ADR-006 recovery akışı.
 */
export async function getSessionResult(
  sessionId: string
): Promise<Session | null> {
  const snap = await getDoc(doc(db(), "sessions", sessionId));
  if (!snap.exists()) return null;
  return { id: snap.id, ...snap.data() } as Session;
}

/**
 * Leaderboard — sıralı session listesi.
 * Sadece scoreCalculatedAt != null olanlar gösterilir.
 */
export async function getLeaderboard(
  examId: string
): Promise<LeaderboardEntry[]> {
  const q = query(
    collection(db(), "sessions"),
    where("examId", "==", examId),
    where("scoreCalculatedAt", "!=", null),
    orderBy("scoreCalculatedAt"),
    orderBy("score", "desc")
  );
  const snap = await getDocs(q);
  return snap.docs.map((d, i) => ({
    rank: i + 1,
    name: d.data().studentName,
    score: d.data().score ?? 0,
    percentage: d.data().percentage ?? 0,
    durationMs: (d.data().completedAt?.toMillis?.() ?? 0) - (d.data().startedAt?.toMillis?.() ?? 0),
  }));
}
