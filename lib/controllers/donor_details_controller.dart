import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class DonationRecord {
  final String date;
  final String hospital;

  const DonationRecord(this.date, this.hospital);
}

class DonorDetailsController extends GetxController {
  late Rx<UserModel> donor;

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

  void toggleBlock() {
    donor.value.isBlocked = !donor.value.isBlocked;
    donor.refresh();

    Get.snackbar(
      donor.value.isBlocked ? 'Donor Blocked' : 'Donor Unblocked',
      donor.value.isBlocked
          ? '${donor.value.name} has been blocked.'
          : '${donor.value.name} has been unblocked.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: donor.value.isBlocked
          ? Colors.red.withValues(alpha: 0.1)
          : Colors.green.withValues(alpha: 0.1),
      colorText: donor.value.isBlocked ? Colors.red : Colors.green,
    );
  }
}
