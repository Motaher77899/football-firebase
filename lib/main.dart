

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:football_user_app/providers/player_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/my_profile_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()), // ← Add this
        // Your other providers...
        // Your other providers here
      ],
      child: MaterialApp(
        title: 'Football Live Score',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/profile': (context) => const MyProfileScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Provider.of<AuthProvider>(context, listen: false)
//           .checkLoginStatus(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             backgroundColor: Color(0xFF1A1A2E),
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//
//         return Consumer<AuthProvider>(
//           builder: (context, authProvider, child) {
//             if (authProvider.isLoggedIn) {
//               return const HomeScreen();
//             } else {
//               return const LoginScreen();
//             }
//           },
//         );
//       },
//     );
//   }
// }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Provider.of<AuthProvider>(context, listen: false).checkLoginStatus(),
        // Check player profile after auth
        Provider.of<AuthProvider>(context, listen: false).checkLoginStatus().then((_) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          if (authProvider.isLoggedIn) {
            Provider.of<PlayerProvider>(context, listen: false)
                .checkPlayerProfile(authProvider.currentUser!.uid);
          }
        }),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A2E),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoggedIn) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        );
      },
    );
  }
}