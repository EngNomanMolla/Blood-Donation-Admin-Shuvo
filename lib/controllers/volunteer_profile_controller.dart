import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/volunteer_profile_model.dart';
import '../models/recharge_model.dart';
import '../models/volunteer_request.dart';

class VolunteerProfileController extends GetxController {
  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  final profile = Rx<VolunteerProfileModel>(
    const VolunteerProfileModel(
      name: "Unknown",
      email: "-",
      phone: "-",
      bloodGroup: "-",
      level: "Volunteer",
      totalRegistration: "0",
      totalEarning: "৳0",
      totalWithdraw: "৳0",
      currentBalance: "৳0",
      isBlocked: false,
    ),
  );

  final transactions = <RechargeModel>[].obs;
  final isLoading = false.obs;
  
  // Store the actual request object
  final volunteerReq = Rxn<VolunteerRequest>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is VolunteerRequest) {
      final req = Get.arguments as VolunteerRequest;
      volunteerReq.value = req;
      
      final balanceText = req.walletBalance != null ? '৳${req.walletBalance!.toInt()}' : '৳0';
      final earningsText = req.volunteerEarnings != null ? '৳${req.volunteerEarnings!.toInt()}' : '৳0';
      final withdrawText = req.volunteerWithdrawals != null ? '৳${req.volunteerWithdrawals!.toInt()}' : '৳0';
      
      profile.value = VolunteerProfileModel(
        name: req.name,
        email: req.userEmail ?? '-',
        phone: req.userPhone ?? '-',
        bloodGroup: req.userBloodGroup ?? '-',
        level: req.isBlocked ? 'Blocked' : 'Volunteer',
        totalRegistration: req.donationsCount.toString(),
        totalEarning: earningsText,
        totalWithdraw: withdrawText,
        currentBalance: balanceText,
        isBlocked: req.isBlocked,
      );
    }
  }

  Future<void> toggleBlock() async {
    final req = volunteerReq.value;
    if (req == null) return;

    isLoading.value = true;
    
    // Determine target URL for block/unblock
    final currentBlockedStatus = profile.value.isBlocked;
    final actionPath = currentBlockedStatus ? 'unblock' : 'block';
    
    // Try to retrieve user id (since the id in approved list is user id!)
    // Wait, let's see: req.id is the user id or request id depending on layout
    final userId = req.id; 

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      // Try hitting volunteers block first, then fallback to users block
      var response = await _connect.patch(
        '$baseUrl/admin/volunteers/$userId/$actionPath',
        {},
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (!response.status.isOk) {
        response = await _connect.patch(
          '$baseUrl/admin/users/$userId/$actionPath',
          {},
          headers: {
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.status.isOk) {
        profile.value = profile.value.copyWith(isBlocked: !currentBlockedStatus);
        Get.snackbar(
          'Success',
          'Volunteer has been ${currentBlockedStatus ? 'unblocked' : 'blocked'} successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update block status: ${response.statusText}',
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
