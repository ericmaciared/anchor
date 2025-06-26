import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';

class ProfileNameSection extends ConsumerWidget {
  final String profileName;
  final Color onSurfaceColor; // For the text color

  const ProfileNameSection({
    super.key,
    required this.profileName,
    required this.onSurfaceColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        String? newName = await showDialog<String>(
          context: context,
          builder: (context) {
            final TextEditingController nameController =
                TextEditingController(text: profileName);
            return AlertDialog(
              title: const Text('Edit Profile Name'),
              content: TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Enter new name'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(nameController.text),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
        if (newName != null && newName.isNotEmpty) {
          ref.read(settingsProvider.notifier).updateProfileName(newName);
        }
      },
      child: Text(
        profileName,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: onSurfaceColor,
            ),
      ),
    );
  }
}
