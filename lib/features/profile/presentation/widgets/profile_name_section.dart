import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNameSection extends ConsumerWidget {
  final String profileName;
  final Color onSurfaceColor;

  const ProfileNameSection({
    super.key,
    required this.profileName,
    required this.onSurfaceColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextStyle? nameTextStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
        );

    return GestureDetector(
      onTap: () async {
        HapticService.light(); // Light feedback for opening edit dialog

        String? newName = await showCupertinoDialog<String>(
          context: context,
          builder: (context) {
            final TextEditingController nameController = TextEditingController(text: profileName);
            return CupertinoAlertDialog(
              title: const Text('Edit Profile Name'),
              content: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: CupertinoTextField(
                  controller: nameController,
                  placeholder: 'Enter new name',
                  autofocus: true,
                  onSubmitted: (value) {
                    HapticService.medium(); // Feedback for submission
                    Navigator.of(context).pop(value);
                  },
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    HapticService.light(); // Cancel feedback
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    HapticService.medium(); // Save feedback
                    Navigator.of(context).pop(nameController.text);
                  },
                  isDefaultAction: true,
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
        style: nameTextStyle,
      ),
    );
  }
}
