//
//
// import 'dart:ui';
//
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:football_user_app/providers/match_provider.dart';
// import 'package:football_user_app/providers/team_provider.dart';
// import 'package:football_user_app/providers/tournament_provider.dart';
// import 'package:provider/provider.dart';
// import 'fcm_service.dart';
// import 'firebase_options.dart';
// import 'providers/auth_provider.dart';
// import 'providers/player_provider.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/signup_screen.dart';
// import 'screens/my_profile_screen.dart';
// import 'screens/main_navigation_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   // FCMService.initialize();
//   // print(await FCMService.getToken());
//
//   // Flutter Error
//   FlutterError.onError = (errorDetails) {
//     FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
//   };
//
//   // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
//   PlatformDispatcher.instance.onError = (error, stack) {
//     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//     return true;
//   };
//
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => PlayerProvider()),
//         ChangeNotifierProvider(create: (_) => MatchProvider()),
//         ChangeNotifierProvider(create: (_) => TeamProvider()),
//         ChangeNotifierProvider(create: (_) => TournamentProvider()),
//       ],
//       child: MaterialApp(
//         title: 'Football Live Score',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           fontFamily: 'Roboto',
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: const AuthWrapper(),
//         routes: {
//           '/home': (context) => const MainNavigationScreen(),
//           '/login': (context) => const LoginScreen(),
//           '/signup': (context) => const SignUpScreen(),
//           '/profile': (context) => const MyProfileScreen(),
//         },
//       ),
//     );
//   }
// }
//
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeApp(context),
//       builder: (context, snapshot) {
//         // Show loading screen while initializing
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             backgroundColor: Color(0xFF1A1A2E),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     color: Color(0xFF0F3460),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     '⚽ Football Live Score',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Loading...',
//                     style: TextStyle(
//                       color: Colors.white54,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         // Show error screen if initialization failed
//         if (snapshot.hasError) {
//           return Scaffold(
//             backgroundColor: const Color(0xFF1A1A2E),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.error_outline,
//                     color: Colors.red,
//                     size: 60,
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Something went wrong',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     snapshot.error.toString(),
//                     style: const TextStyle(
//                       color: Colors.white54,
//                       fontSize: 14,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         // Navigate based on authentication status
//         return Consumer<AuthProvider>(
//           builder: (context, authProvider, child) {
//             if (authProvider.isLoggedIn) {
//               return const MainNavigationScreen();
//             } else {
//               return const LoginScreen();
//             }
//           },
//         );
//       },
//     );
//   }
//
//   // Initialize app data
//   Future<void> _initializeApp(BuildContext context) async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
//
//       // Check login status
//       await authProvider.checkLoginStatus();
//
//       // If logged in, check player profile
//       if (authProvider.isLoggedIn && authProvider.currentUser != null) {
//         await playerProvider.checkPlayerProfile(authProvider.currentUser!.uid);
//       }
//     } catch (e) {
//       debugPrint('Error initializing app: $e');
//       rethrow;
//     }
//   }
// }

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';

// Import Options & Services
import 'firebase_options.dart';
// import 'fcm_service.dart'; // প্রয়োজন হলে আনকমেন্ট করুন

// Import Providers
import 'providers/auth_provider.dart';
import 'providers/player_provider.dart';
import 'providers/match_provider.dart';
import 'providers/team_provider.dart';
import 'providers/tournament_provider.dart';

// Import Screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/my_profile_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // অফলাইন ক্যাশ সাপোর্ট চালু করা
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Crashlytics for Error Tracking
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => TournamentProvider()),
      ],
      child: MaterialApp(
        title: 'Football Live Score',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark, // অ্যাপের ডার্ক থিমের সাথে সামঞ্জস্য রাখতে
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
        routes: {
          '/home': (context) => const MainNavigationScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/profile': (context) => const MyProfileScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        // ১. লোডিং স্ক্রিন
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A2E),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF0F3460)),
                  SizedBox(height: 20),
                  Text(
                    '⚽ Football Live Score',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }

        // ২. এরর হ্যান্ডলিং
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A2E),
            body: Center(
              child: Text(
                'Initialization Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // ৩. লগইন স্ট্যাটাস অনুযায়ী স্ক্রিন দেখানো
        return Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // আপনার AuthProvider-এ isAuthenticated অথবা currentUser ফিল্ডটি চেক করা হচ্ছে
            if (authProvider.isAuthenticated) {
              return const MainNavigationScreen();
            } else {
              return const LoginScreen();
            }
          },
        );
      },
    );
  }

  // অ্যাপ ডাটা ইনিশিয়ালাইজ করার ফাংশন
  Future<void> _initializeApp(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    // ইউজারের লগইন স্ট্যাটাস চেক করবে (Firebase Auth থেকে)
    await authProvider.checkLoginStatus();

    // ইউজার যদি লগইন থাকে, তবে তার প্লেয়ার প্রোফাইল ফায়ারস্টোর থেকে লোড করবে
    if (authProvider.isAuthenticated && authProvider.currentUser != null) {
      await playerProvider.checkPlayerProfile(authProvider.currentUser!.uid);
    }
  }
}