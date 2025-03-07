import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_app/repos/auth_repository.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gAuthStateProvider);
    return Column(
      children: [
        SizedBox(height: 60),
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '🔥 MOOD 🔥',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            if (session != null)
              Positioned(
                right: 30,
                child: GestureDetector(
                  onTap: () {
                    ref.read(gAuthRepositoryProvider).signOut();
                    context.go('/sign_in');
                  },
                  child: Icon(Icons.logout),
                ),
              ),
          ],
        ),
        Center(child: Text("Post")),
      ],
    );
  }
}
