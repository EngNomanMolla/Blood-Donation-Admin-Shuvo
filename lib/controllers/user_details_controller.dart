import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/recharge_model.dart';

class UserDetailsController extends GetxController {
  late Rx<UserModel> user;

  final rechargeHistory = <RechargeModel>[
    const RechargeModel(
      id: 'RCH001',
      amount: '৳500',
      date: '12 Apr 2026',
      time: '10:30 AM',
      method: 'bKash',
      status: 'success',
    ),
    const RechargeModel(
      id: 'RCH002',
      amount: '৳1,000',
      date: '10 Apr 2026',
      time: '02:15 PM',
      method: 'Nagad',
      status: 'success',
    ),
    const RechargeModel(
      id: 'RCH003',
      amount: '৳200',
      date: '08 Apr 2026',
      time: '11:45 AM',
      method: 'bKash',
      status: 'pending',
    ),
    const RechargeModel(
      id: 'RCH004',
      amount: '৳750',
      date: '05 Apr 2026',
      time: '09:00 PM',
      method: 'Rocket',
      status: 'failed',
    ),
    const RechargeModel(
      id: 'RCH005',
      amount: '৳300',
      date: '01 Apr 2026',
      time: '04:20 PM',
      method: 'bKash',
      status: 'success',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    user = (Get.arguments as UserModel).obs;
  }

  void toggleBlock() {
    user.value.isBlocked = !user.value.isBlocked;
    user.refresh();

    Get.snackbar(
      user.value.isBlocked ? 'User Blocked' : 'User Unblocked',
      user.value.isBlocked
          ? '${user.value.name} has been blocked.'
          : '${user.value.name} has been unblocked.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: user.value.isBlocked
          ? Colors.red.withValues(alpha: 0.1)
          : Colors.green.withValues(alpha: 0.1),
      colorText: user.value.isBlocked ? Colors.red : Colors.green,
    );
  }
}
