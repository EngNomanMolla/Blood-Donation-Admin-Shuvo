import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  final isLoading = false.obs;

  void sendNotification() async {
    final title = titleController.text.trim();
    final message = messageController.text.trim();

    if (title.isEmpty || message.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in both title and message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;
    
    Get.snackbar(
      'Success',
      'Notification sent successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      colorText: Colors.green,
    );

    // Clear fields
    titleController.clear();
    messageController.clear();
  }

  @override
  void onClose() {
    titleController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
