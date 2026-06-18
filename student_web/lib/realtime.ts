/**
 * ExamKit — Realtime Database (RTDB) katmanı.
 * Canlı sınav senkronizasyonu: öğrenci varlığı, ilerleme, global timer.
 * Bkz: docs/phase_1/architecture/api_design.md §Next.js Client Functions
 */

import {
  getDatabase,
  ref,
  onValue,
  set,
  update,
  serverTimestamp,
  type Unsubscribe,
  type Database,
} from "firebase/database";

function rtdb(): Database {
  return getDatabase();
}

// ============================================================================
// Types
// ============================================================================

export interface StudentPresence {
  name: string;
  joinedAt: number;
  progress: number; // answered count
  status: "waiting" | "active" | "completed";
}

export interface LiveExamState {
  status: "waiting" | "active" | "ended";
  teacherId: string;
  startedAt?: number;
  globalTimerEndsAt?: number;
}

// ============================================================================
// Subscriptions
// ============================================================================

/**
 * Sınav durumunu dinle — waiting → active geçişini yakala.
 */
export function subscribeToExamStatus(
  examId: string,
  callback: (status: string, liveState: LiveExamState | null) => void
): Unsubscribe {
  const examRef = ref(rtdb(), `live_exams/${examId}`);
  return onValue(examRef, (snap) => {
    if (!snap.exists()) {
      callback("waiting", null);
      return;
    }
    const data = snap.val() as LiveExamState;
    callback(data.status, data);
  });
}

/**
 * Bekleme odasındaki / aktif öğrencileri dinle.
 */
export function subscribeToStudents(
  examId: string,
  callback: (students: Record<string, StudentPresence>) => void
): Unsubscribe {
  const studentsRef = ref(rtdb(), `live_exams/${examId}/students`);
  return onValue(studentsRef, (snap) => {
    if (!snap.exists()) {
      callback({});
      return;
    }
    callback(snap.val() as Record<string, StudentPresence>);
  });
}

// ============================================================================
// Writes
// ============================================================================

/**
 * Öğrenci bekleme odasına katılır.
 */
export async function joinWaitingRoom(
  examId: string,
  sessionId: string,
  name: string
): Promise<void> {
  const studentRef = ref(
    rtdb(),
    `live_exams/${examId}/students/${sessionId}`
  );
  await set(studentRef, {
    name,
    joinedAt: serverTimestamp(),
    progress: 0,
    status: "waiting",
  });
}

/**
 * Öğrenci ilerlemesini güncelle (cevaplanan soru sayısı).
 */
export async function updateProgress(
  examId: string,
  sessionId: string,
  count: number
): Promise<void> {
  const refPath = `live_exams/${examId}/students/${sessionId}`;
  await update(ref(rtdb(), refPath), {
    progress: count,
  });
}

/**
 * Öğrenci sınavı tamamladı.
 */
export async function markCompleted(
  examId: string,
  sessionId: string
): Promise<void> {
  const refPath = `live_exams/${examId}/students/${sessionId}`;
  await update(ref(rtdb(), refPath), {
    status: "completed",
  });
}

// ============================================================================
// Timer Utility (Pure Function)
// ============================================================================

/**
 * Global timer için kalan ms hesapla.
 * Server clock skew: RTDB /.info/serverTimeOffset ile düzeltilebilir.
 *
 * @param globalTimerEndsAt — Öğretmenin yazdığı mutlak bitiş timestamp'i (ms)
 * @returns Kalan ms (en az 0)
 */
export function getRemainingMs(globalTimerEndsAt: number): number {
  return Math.max(0, globalTimerEndsAt - Date.now());
}
