import 'package:flutter/material.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String profileName;
  final Color profileColor;
  final Color onPrimaryColor;

  const ProfileAvatarSection({
    super.key,
    required this.profileName,
    required this.profileColor,
    required this.onPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: profileColor,
          child: Text(
            profileName.isNotEmpty ? profileName[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: onPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
