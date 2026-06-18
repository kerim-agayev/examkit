import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/firebase/firebase_providers.dart';

/// Auth state stream — tüm uygulama tarafından dinlenir
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Google Sign-In
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(scopes: ['email', 'profile']);
});

/// signInWithGoogle
final signInWithGoogleProvider = FutureProvider.autoDispose<UserCredential?>((ref) async {
  final googleSignIn = ref.watch(googleSignInProvider);
  final firebaseAuth = ref.watch(firebaseAuthProvider);

  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) return null; // kullanıcı iptal etti

  final googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return firebaseAuth.signInWithCredential(credential);
});

/// signOut
final signOutProvider = FutureProvider.autoDispose<void>((ref) async {
  await ref.watch(googleSignInProvider).signOut();
  await ref.watch(firebaseAuthProvider).signOut();
});
