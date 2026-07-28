import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_pages.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Retrieve persistent session state
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('admin_token');
  
  // Set initial route based on session presence
  final String initialRoute = token != null ? Routes.ADMIN_PANEL : Routes.LOGIN;

  runApp(
    GetMaterialApp(
      title: "Blood Donation Admin",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    ),
  );
}
