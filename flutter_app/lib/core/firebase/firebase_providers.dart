import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firebase core instance — initialized in main.dart
final firebaseAppProvider = Provider<FirebaseApp>((ref) {
  return Firebase.app();
});

/// Firestore
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Firebase Auth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Realtime Database
final rtdbProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instance;
});
