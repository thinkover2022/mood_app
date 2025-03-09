import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_app/repos/auth_repository.dart';
import 'package:mood_app/view_models/messages_view_model.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PostScreen();
  }
}

class _PostScreen extends ConsumerState<PostScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? selectedMood;
  final List<String> moodEmojis = [
    "😀",
    "😍",
    "🙂",
    "😴",
    "😭",
    "😡",
    "🤔",
    "🤢",
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        Text(
          "How do you feel?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _messageController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Write it down here!",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        Text(
          "What's your mood?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children:
              moodEmojis.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = emoji;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          selectedMood == emoji ? Colors.black : Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      emoji,
                      style: TextStyle(
                        fontSize: 24,
                        color:
                            selectedMood == emoji ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
        SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              if (_messageController.text.isEmpty || selectedMood == null) {
                return;
              }
              ref
                  .read(gMessageViewModelProvider.notifier)
                  .sendMessage(selectedMood!, _messageController.text, context);
            },
            child: Text(
              "Post",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
