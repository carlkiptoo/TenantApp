import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const RentalTenantApp());

}

class RentalTenantApp extends StatelessWidget {
  const RentalTenantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tenant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,

      ),
      home: const SplashScreen(),
    );
  }
}