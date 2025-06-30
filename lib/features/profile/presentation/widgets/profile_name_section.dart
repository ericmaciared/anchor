import 'package:flutter/cupertino.dart'; // Import Cupertino for iOS-style widgets
import 'package:flutter/material.dart'; // Still needed for ThemeData, etc.
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
    final TextStyle? nameTextStyle =
        Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: onSurfaceColor,
            );

    return GestureDetector(
      onTap: () async {
        String? newName = await showCupertinoDialog<String>(
          // Use showCupertinoDialog
          context: context,
          builder: (context) {
            final TextEditingController nameController =
                TextEditingController(text: profileName);
            return CupertinoAlertDialog(
              // Use CupertinoAlertDialog
              title: const Text('Edit Profile Name'),
              content: Padding(
                // Add padding for the TextField
                padding: const EdgeInsets.only(top: 10.0),
                child: CupertinoTextField(
                  // Use CupertinoTextField
                  controller: nameController,
                  placeholder:
                      'Enter new name', // Use placeholder instead of hintText
                  autofocus: true,
                  onSubmitted: (value) {
                    Navigator.of(context).pop(value);
                  },
                  // Apply a minimal border to make it visually editable if needed,
                  // or remove for a truly bare-bones look.
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  // Use CupertinoDialogAction
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  // Use CupertinoDialogAction
                  onPressed: () =>
                      Navigator.of(context).pop(nameController.text),
                  isDefaultAction: true, // Highlights the default action (Save)
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
        // Just the text, relying on tap gesture for editability
        profileName,
        style: nameTextStyle,
      ),
    );
  }
}
