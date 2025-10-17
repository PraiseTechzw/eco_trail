import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/offline_indicator.dart';
import '../../../../core/widgets/accessibility_settings.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Open settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryGreen,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome to Eco-Trail!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to access all features',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement authentication
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Settings Section
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.palette,
                      color: AppColors.primaryGreen,
                    ),
                    title: const Text('Theme'),
                    subtitle: Text(
                      themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
                    ),
                    trailing: Switch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                    ),
                  ),
                  const Divider(),
                  const OfflineModeToggle(),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.language,
                      color: AppColors.primaryGreen,
                    ),
                    title: const Text('Language'),
                    subtitle: const Text('English'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Language selection
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: AppColors.primaryGreen,
                    ),
                    title: const Text('Notifications'),
                    subtitle: const Text('Manage your notifications'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Notification settings
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.accessibility,
                      color: AppColors.primaryGreen,
                    ),
                    title: const Text('Accessibility'),
                    subtitle: const Text('Customize accessibility settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccessibilitySettings(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.help,
                      color: AppColors.primaryGreen,
                    ),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Help & Support
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
