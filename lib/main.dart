import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/constants/app_constants.dart';
import 'firebase_options.dart';
import 'features/map/presentation/pages/map_page.dart';
import 'features/events/presentation/pages/events_page.dart';
import 'features/bookings/presentation/pages/bookings_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/tips/presentation/pages/tips_page.dart';
import 'features/reviews/presentation/pages/reviews_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'widgets/splash_screen.dart';
import 'widgets/onboarding_screen.dart';
import 'features/tips/data/services/demo_tips_service.dart';
import 'features/reviews/data/services/demo_reviews_service.dart';
import 'features/events/data/services/demo_events_service.dart';
import 'features/map/data/services/demo_locations_service.dart';
import 'core/services/offline_service.dart';
import 'core/widgets/offline_indicator.dart';
import 'core/services/accessibility_service.dart';
import 'features/bookings/data/services/payment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize offline service
  await OfflineService.initialize();

  // Initialize accessibility service
  await AccessibilityService.initialize();

  // Initialize payment service
  await PaymentService.initialize();

  // Populate demo data
  try {
    await DemoTipsService.populateSampleTips();
    await DemoReviewsService.populateSampleReviews();
    await DemoEventsService.populateSampleEvents();
    await DemoLocationsService.populateSampleLocations();
  } catch (e) {
    print('Error populating demo data: $e');
  }

  runApp(const ProviderScope(child: EcoTrailApp()));
}

class EcoTrailApp extends ConsumerWidget {
  const EcoTrailApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/main': (context) => const MainNavigationPage(),
      },
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MapPage(),
    const EventsPage(),
    const BookingsPage(),
    const TipsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return OfflineIndicator(
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_outlined),
              activeIcon: Icon(Icons.event),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online_outlined),
              activeIcon: Icon(Icons.book_online),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.eco_outlined),
              activeIcon: Icon(Icons.eco),
              label: 'Tips',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
