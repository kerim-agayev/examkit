/**
 * ExamKit — Firebase istemci yapılandırması.
 * Tüm secret'lar NEXT_PUBLIC_FIREBASE_* environment değişkenlerinden alınır.
 * Değişkenler student_web/.env.local dosyasında tanımlanır (gitignored).
 * Bkz: docs/phase_1/secrets_management.md
 */

import { initializeApp, getApps, type FirebaseApp } from "firebase/app";
import { getFirestore, type Firestore } from "firebase/firestore";
import { getDatabase, type Database } from "firebase/database";

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  databaseURL: process.env.NEXT_PUBLIC_FIREBASE_DATABASE_URL,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
  measurementId: process.env.NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID,
};

function getFirebaseApp(): FirebaseApp | null {
  if (typeof window === "undefined") return null; // SSR: no Firebase
  if (!firebaseConfig.apiKey) return null; // not configured
  if (getApps().length > 0) return getApps()[0]!;
  return initializeApp(firebaseConfig);
}

export function getDb(): Firestore | null {
  const app = getFirebaseApp();
  return app ? getFirestore(app) : null;
}

export function getRtdb(): Database | null {
  const app = getFirebaseApp();
  return app ? getDatabase(app) : null;
}
