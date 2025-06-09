import 'package:cinema_app/cinema_features/cinema_auth/providers/cinema_auth_provider.dart';
import 'package:cinema_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/cinema_router.dart';
// import 'cinema_features/cinema_auth/providers/cinema_auth_provider.dart';
import 'core/constants/app_colors.dart';  // Make sure to import these
import 'core/constants/app_styles.dart';

void main() async {  // <-- This main() function must exist
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // If using firebase_options
    
  );
  debugPrint('Firebase initialized: ${Firebase.apps.isNotEmpty}');
  runApp(const CinemaApp());
}

class CinemaApp extends StatelessWidget {
  const CinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CinemaAuthProvider()),
      ],
      child: MaterialApp.router(
        title: 'Cinema Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.darkBg,
          cardColor: AppColors.cardBg,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white), // For input text
            bodyMedium: TextStyle(color: Colors.white),
          ).apply(
            bodyColor: AppColors.textLight,
            displayColor: AppColors.textLight,
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: AppStyles.mutedText,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        routerConfig: cinemaRouter,
      ),
    );
  }
}