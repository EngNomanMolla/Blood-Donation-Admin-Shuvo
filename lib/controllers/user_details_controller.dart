import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserDetailsController extends GetxController {
  final GetConnect _connect = GetConnect(timeout: const Duration(seconds: 15));
  final String baseUrl = 'https://bloodlinkonline.xyz/api/v1';
  final String fallbackBaseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

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
    // Status payload: 'blocked' when blocking, 'active' when unlocking
    final String nextStatus = willBlock ? 'blocked' : 'active';

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      var response = await _connect.patch(
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

      // Fallback if needed
      if (!response.status.isOk) {
        response = await _connect.patch(
          '$fallbackBaseUrl/admin/users/$userId/status',
          {
            'status': nextStatus,
          },
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.status.isOk) {
        // Toggle the local state and refresh
        user.value.isBlocked = willBlock;
        user.value.isActive = !willBlock;
        user.refresh();

        String msg = willBlock
            ? 'User has been blocked successfully.'
            : 'User has been unblocked successfully.';
        if (response.body is Map && response.body['message'] != null) {
          msg = response.body['message'].toString();
        }

        Get.snackbar(
          'Success',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: const Color(0xFF2E7D32),
        );
      } else {
        String errorMsg = 'Failed to update status';
        if (response.body is Map && response.body['message'] != null) {
          errorMsg = response.body['message'].toString();
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }

        Get.snackbar(
          'Error',
          errorMsg,
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
