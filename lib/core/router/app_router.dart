import 'package:anchor/features/home/home_screen.dart';
import 'package:anchor/features/tasks/tasks_screen.dart';
import 'package:anchor/features/welcome/welcome_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/tasks',
      name: 'tasks',
      builder: (context, state) => const TasksScreen(),
    ),
  ],
);
