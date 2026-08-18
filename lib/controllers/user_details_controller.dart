import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserDetailsController extends GetxController {
  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  late Rx<UserModel> user;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user = (Get.arguments as UserModel).obs;
  }

  Future<void> toggleBlock() async {
    isLoading.value = true;
    
    final int userId = user.value.id;
    final bool willBlock = !user.value.isBlocked;
    final String nextStatus = willBlock ? 'blocked' : 'active';

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.patch(
        '$baseUrl/admin/users/$userId/status',
        {
          'status': nextStatus,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.status.isOk) {
        // Toggle the local state and refresh
        user.value.isBlocked = willBlock;
        user.refresh();
      } else {
        Get.snackbar(
          'Error',
          'Failed to update status: ${response.statusText ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFFECEF),
          colorText: const Color(0xFFEF4444),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFECEF),
        colorText: const Color(0xFFEF4444),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
