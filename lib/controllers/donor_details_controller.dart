import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class DonationRecord {
  final String date;
  final String hospital;

  const DonationRecord(this.date, this.hospital);
}

class DonorDetailsController extends GetxController {
  final GetConnect _connect = GetConnect(timeout: const Duration(seconds: 15));
  final String baseUrl = 'https://bloodlinkonline.xyz/api/v1';
  final String fallbackBaseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  late Rx<UserModel> donor;
  final isLoading = false.obs;

  final String lastDonationDate = "10 Jan 2026";
  final String nextAvailableDate = "10 Apr 2026";

  final donationHistory = <DonationRecord>[
    const DonationRecord("10 Jan 2026", "Dhaka Medical College"),
    const DonationRecord("05 Sep 2025", "Square Hospital"),
    const DonationRecord("12 Apr 2025", "Evercare Hospital"),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    donor = (Get.arguments as UserModel).obs;
  }

  Future<void> toggleBlock() async {
    isLoading.value = true;

    final int donorId = donor.value.id;
    final bool willBlock = !donor.value.isBlocked;
    final String nextStatus = willBlock ? 'blocked' : 'active';

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      var response = await _connect.patch(
        '$baseUrl/admin/users/$donorId/status',
        {
          'status': nextStatus,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (!response.status.isOk) {
        response = await _connect.patch(
          '$fallbackBaseUrl/admin/users/$donorId/status',
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
        donor.value.isBlocked = willBlock;
        donor.value.isActive = !willBlock;
        donor.refresh();

        String msg = willBlock
            ? '${donor.value.name} has been blocked.'
            : '${donor.value.name} has been unblocked.';
        if (response.body is Map && response.body['message'] != null) {
          msg = response.body['message'].toString();
        }

        Get.snackbar(
          willBlock ? 'Donor Blocked' : 'Donor Unblocked',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: willBlock
              ? Colors.red.withValues(alpha: 0.1)
              : Colors.green.withValues(alpha: 0.1),
          colorText: willBlock ? Colors.red : Colors.green,
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
