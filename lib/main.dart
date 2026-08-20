import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_pages.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('admin_token');

  bool isConnected = false;
  if (token != null) {
    if (kIsWeb) {
      isConnected = true;
    } else {
      try {
        final result = await InternetAddress.lookup('www.google.com')
            .timeout(const Duration(seconds: 3));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          isConnected = true;
        }
      } catch (_) {
        isConnected = false;
      }
    }
  }


  final String initialRoute;
  if (token != null && isConnected) {
    initialRoute = Routes.ADMIN_PANEL;
  } else {

    if (token != null && !isConnected) {
      await prefs.remove('admin_token');
    }
    initialRoute = Routes.LOGIN;
  }

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
