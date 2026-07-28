import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_subscription_model.dart';

class SubscriptionController extends GetxController {
  final plansList = <AdminSubscriptionModel>[].obs;
  final isLoading = false.obs;

  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.get(
        '$baseUrl/admin/subscription-plans',
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.status.isOk && response.body != null) {
        final dynamic responseData = response.body;
        
        List<dynamic>? rawList;
        if (responseData is List) {
          rawList = responseData;
        } else if (responseData is Map<String, dynamic>) {
          if (responseData['data'] != null) {
            if (responseData['data'] is List) {
              rawList = responseData['data'] as List;
            } else if (responseData['data'] is Map<String, dynamic> &&
                responseData['data']['data'] is List) {
              rawList = responseData['data']['data'] as List;
            }
          }
        }

        if (rawList != null) {
          plansList.value = rawList
              .map((e) => AdminSubscriptionModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          plansList.clear();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load subscription plans: ${response.statusText}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createPlan(AdminSubscriptionModel plan) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.post(
        '$baseUrl/admin/subscription-plans',
        plan.toJson(),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.status.isOk) {
        fetchPlans(); // Refresh the list
        return true;
      } else {
        String errorMsg = 'Failed to create plan';
        if (response.body != null && response.body is Map) {
          final errorBody = response.body as Map;
          if (errorBody['message'] != null) {
            errorMsg = errorBody['message'].toString();
          }
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updatePlan(int id, AdminSubscriptionModel plan) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.put(
        '$baseUrl/admin/subscription-plans/$id',
        plan.toJson(),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.status.isOk) {
        fetchPlans(); // Refresh the list
        return true;
      } else {
        String errorMsg = 'Failed to update plan';
        if (response.body != null && response.body is Map) {
          final errorBody = response.body as Map;
          if (errorBody['message'] != null) {
            errorMsg = errorBody['message'].toString();
          }
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deletePlan(int id) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.delete(
        '$baseUrl/admin/subscription-plans/$id',
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.status.isOk) {
        fetchPlans(); // Refresh the list
        return true;
      } else {
        String errorMsg = 'Failed to delete plan';
        if (response.body != null && response.body is Map) {
          final errorBody = response.body as Map;
          if (errorBody['message'] != null) {
            errorMsg = errorBody['message'].toString();
          }
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
