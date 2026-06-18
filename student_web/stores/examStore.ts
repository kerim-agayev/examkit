/**
 * ExamKit — Zustand exam store.
 * Tüm sınav state'i burada yönetilir.
 * Offline dayanıklılık: cevaplar localStorage'da yedeklenir.
 */

import { create } from "zustand";

export type ExamStatus = "waiting" | "active" | "completed";
export type AnswerValue = string | boolean;

interface Question {
  id: string;
  text: string;
  type: "mcq" | "true_false" | "short_answer";
  options?: string[]; // mcq: A, B, C, D
  points: number;
  timerSeconds: number | null;
  orderIndex: number;
}

interface Exam {
  id: string;
  title: string;
  groupName?: string;
  teacherName?: string;
  mode: "scroll" | "sequential";
  globalTimerMinutes: number | null;
  shuffleQuestions: boolean;
  shuffleOptions: boolean;
  showScore: boolean;
  showCorrectAnswers: boolean;
  showLeaderboard: boolean;
}

interface ExamStore {
  // Exam data
  exam: Exam | null;
  questions: Question[];
  sessionId: string | null;
  studentName: string | null;

  // Exam state
  status: ExamStatus;
  currentQuestionIndex: number; // sequential mode
  answers: Record<string, AnswerValue>;
  globalTimeLeft: number | null; // ms
  confirmAdvance: boolean; // sequential UX (ADR-005)

  // Actions
  setExam: (exam: Exam) => void;
  setQuestions: (questions: Question[]) => void;
  setSessionId: (id: string) => void;
  setStudentName: (name: string) => void;
  setStatus: (status: ExamStatus) => void;
  setAnswer: (questionId: string, value: AnswerValue) => void;
  setGlobalTimeLeft: (ms: number | null) => void;
  advanceToNext: () => void;
  resetStore: () => void;
}

const initialState = {
  exam: null,
  questions: [],
  sessionId: null,
  studentName: null,
  status: "waiting" as ExamStatus,
  currentQuestionIndex: 0,
  answers: {},
  globalTimeLeft: null,
  confirmAdvance: false,
};

export const useExamStore = create<ExamStore>((set) => ({
  ...initialState,

  setExam: (exam) => set({ exam }),
  setQuestions: (questions) => set({ questions }),
  setSessionId: (sessionId) => set({ sessionId }),
  setStudentName: (studentName) => set({ studentName }),
  setStatus: (status) => set({ status }),
  setAnswer: (questionId, value) =>
    set((state) => ({
      answers: { ...state.answers, [questionId]: value },
    })),
  setGlobalTimeLeft: (globalTimeLeft) => set({ globalTimeLeft }),
  advanceToNext: () =>
    set((state) => ({
      currentQuestionIndex: state.currentQuestionIndex + 1,
      confirmAdvance: false,
    })),
  resetStore: () => set(initialState),
}));
