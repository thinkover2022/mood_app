import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_app/repos/auth_repository.dart';
import 'package:mood_app/utils/utils.dart';

class SigninViewModel extends AsyncNotifier {
  late final AuthRepository _authRepository;
  @override
  FutureOr<void> build() {
    _authRepository = ref.read(gAuthRepositoryProvider);
  }

  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signIn(email, password);
    });
    if (state.hasError) {
      if (context.mounted) {
        context.showSnackBar(error: state.error);
      }
    } else {
      if (context.mounted) {
        context.go('/home');
      }
    }
  }
}

final gSignInProvider = AsyncNotifierProvider<SigninViewModel, void>(
  () => SigninViewModel(),
);
