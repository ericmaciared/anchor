import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'floating_navbar.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(
              child: FloatingNavBar(
                currentIndex: navigationShell.currentIndex,
                onTap: (index) => navigationShell.goBranch(index),
              ),
            ),
          )
        ],
      ),
    );
  }
}
