// Provider status autentikasi aplikasi.
//
// Menyediakan authRepositoryProvider (implementasi repository) dan
// authNotifierProvider yang mengikuti perubahan sesi login. Dalam mode
// demo (Supabase belum terinisialisasi) sesi selalu belum login.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/supabase_auth_repository.dart';

/// Provider repository autentikasi.
final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
  (Ref ref) => SupabaseAuthRepository(),
);

/// Notifier status autentikasi yang mengikuti perubahan sesi.
class AuthNotifier extends StateNotifier<AuthSession> {
  /// Membuat notifier dan mulai mengikuti [repository.authStateChanges].
  AuthNotifier(this._repository) : super(_repository.currentSession) {
    _subscription = _repository.authStateChanges.listen(
      (AuthSession session) {
        state = session;
      },
    );
  }

  final AuthRepository _repository;

  StreamSubscription<AuthSession>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Provider status login aplikasi.
final StateNotifierProvider<AuthNotifier, AuthSession> authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthSession>(
  (Ref ref) => AuthNotifier(ref.watch(authRepositoryProvider)),
);