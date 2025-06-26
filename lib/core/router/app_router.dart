import 'package:anchor/features/habits/presentation/screens/habits_screen.dart';
import 'package:anchor/features/profile/presentation/screens/profile_screen.dart';
import 'package:anchor/features/shared/main/main_scaffold.dart';
import 'package:anchor/features/tasks/presentation/screens/tasks_screen.dart';
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

    // Main tabs shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScaffold(navigationShell: navigationShell),
      branches: [
        // Tasks branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tasks',
              name: 'tasks',
              builder: (context, state) => const TasksScreen(),
            ),
          ],
        ),

        // Habits branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/habits',
              name: 'habits',
              builder: (context, state) => const HabitsScreen(),
            ),
          ],
        ),

        // Profile branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
