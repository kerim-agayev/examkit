import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAppProvider = Provider<FirebaseApp>((ref) => Firebase.app());
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final rtdbProvider = Provider<FirebaseDatabase>((ref) => FirebaseDatabase.instance);
