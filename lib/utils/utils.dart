import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String getSupabaseErrorMessage(Object? error) {
  if (error is AuthException ||
      error is PostgrestException ||
      error is StorageException) {
    return (error as dynamic).message;
  }
  return error.toString();
}

extension ShowSnackBar on BuildContext {
  void showSnackBar({Object? error, Color bgColor = Colors.white}) {
    String errorMsg = getSupabaseErrorMessage(error);
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        content: Text(
          errorMsg,
          style: TextStyle(fontSize: 26, color: Colors.black),
        ),
        backgroundColor: bgColor,
      ),
    );
  }
}
