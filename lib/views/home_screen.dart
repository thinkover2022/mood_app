import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_app/models/message_model.dart';
import 'package:mood_app/repos/auth_repository.dart';
import 'package:mood_app/view_models/messages_view_model.dart';
import 'package:mood_app/widgets/message_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gMessageViewModelProvider.notifier).listenToMessages();
    });
  }

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 24) {
      // 24시간 이내 → "몇 시간 몇 분 전"
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;

      if (hours > 0) {
        return "$hours시간 $minutes분 전";
      } else {
        return "$minutes분 전";
      }
    } else {
      // 24시간 이상 → "몇 일 전"
      final days = difference.inDays;
      return "$days일 전";
    }
  }

  void _showDeleteDialog(BuildContext context, MessageModel message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // 반투명 배경
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Delete note",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Are you sure you want to do this?"),
                      const SizedBox(height: 16),
                      Divider(height: 1, color: Colors.grey),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(gMessageViewModelProvider.notifier)
                              .deleteMessage(message.id, context);
                          Navigator.pop(context); // 다이얼로그 닫기
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(gAuthStateProvider);
    final messagesAsync = ref.watch(gMessageViewModelProvider);

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
                    if (context.mounted) {
                      context.go('/sign_in');
                    }
                  },
                  child: Icon(Icons.logout),
                ),
              ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: messagesAsync.when(
            data:
                (messages) => ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageTile(
                      mood: message.mood,
                      message: message.content,
                      time: timeAgo(message.createdAt),
                      longPressed: () => _showDeleteDialog(context, message),
                    );
                  },
                ),
            error: (error, stack) => Center(child: Text('Error:$error')),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}
