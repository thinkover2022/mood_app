import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_app/repos/auth_repository.dart';
import 'package:mood_app/utils/utils.dart';

class SignupViewModel extends AsyncNotifier {
  late final AuthRepository _authRepository;
  @override
  FutureOr<void> build() {
    _authRepository = ref.read(gAuthRepositoryProvider);
  }

  Future<void> signUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signUp(email, password);
    });
    if (state.hasError) {
      if (context.mounted) {
        context.showSnackBar(error: state.error);
      } else {
        if (context.mounted) {
          context.go('/home');
        }
      }
    }
  }
}

final gSignUpProvider = AsyncNotifierProvider<SignupViewModel, void>(
  () => SignupViewModel(),
);
