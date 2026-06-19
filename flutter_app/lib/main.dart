import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // NOT: Firestore varsayılan ayarlarla (persistence açık) başlar.
  // Settings elle ayarlanmaz — native SDK kendi yönetir.
  runApp(const ProviderScope(child: ExamKitApp()));
}
