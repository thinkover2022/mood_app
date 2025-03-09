import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

class AuthNotifier extends StateNotifier<Session?> {
  AuthNotifier() : super(null) {
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      state = event.session;
    });
  }
}

final gAuthStateProvider = StateNotifierProvider<AuthNotifier, Session?>((ref) {
  return AuthNotifier();
});
final gAuthRepositoryProvider = Provider((ref) => AuthRepository());
