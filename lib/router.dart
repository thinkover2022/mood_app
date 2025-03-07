import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_app/repos/auth_repository.dart';
import 'package:mood_app/views/navigation_screen.dart';
import 'package:mood_app/views/sign_in_screen.dart';
import 'package:mood_app/views/sign_up_screen.dart';

final gRouterProvider = Provider.autoDispose<GoRouter>((ref) {
  final session = ref.watch(gAuthStateProvider);
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      if (state.uri.path == '/home' || state.uri.path == '/post') {
        return session != null ? state.uri.path : '/sign_in';
      }
      return state.uri.path;
    },
    routes: [
      GoRoute(path: '/sign_in', builder: (context, state) => SignInScreen()),
      GoRoute(path: '/sign_up', builder: (context, state) => SignUpScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return NavigationScreen(tab: 'home');
        },
      ),
      GoRoute(
        path: '/post',
        builder: (context, state) {
          return NavigationScreen(tab: 'post');
        },
      ),
    ],
  );
});
