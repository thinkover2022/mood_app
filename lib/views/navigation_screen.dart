import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_app/views/home_screen.dart';
import 'package:mood_app/views/post_screen.dart';

class NavigationScreen extends StatefulWidget {
  final String tab;
  const NavigationScreen({super.key, required this.tab});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.tab == 'home' ? 0 : 1,
        children: [HomeScreen(), PostScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            context.go('/home');
          } else {
            context.go('/post');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_outlined),
            label: "Post",
          ),
        ],
      ),
    );
  }
}
