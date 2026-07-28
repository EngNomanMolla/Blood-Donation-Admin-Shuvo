import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_recharge_model.dart';

class RechargeController extends GetxController {
  final rechargeList = <AdminRechargeModel>[].obs;
  final isLoadingRecharges = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalRecharges = 0.obs;
  final pendingRecharges = 0.obs;
  final successfulRecharges = 0.obs;
  final failedRecharges = 0.obs;

  final selectedStatusFilter = 'All'.obs;

  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  @override
  void onInit() {
    super.onInit();
    fetchRecharges(1);
  }

  void setStatusFilter(String? filter) {
    if (filter != null) {
      selectedStatusFilter.value = filter;
      fetchRecharges(1);
    }
  }

  Future<void> fetchRecharges(int page) async {
    isLoadingRecharges.value = true;
    currentPage.value = page;

    final filter = selectedStatusFilter.value.toLowerCase();
    
    // Build query parameters
    final Map<String, String> queryParams = {
      'per_page': '10',
      'page': page.toString(),
    };
    
    if (filter != 'all') {
      queryParams['status'] = filter;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.get(
        '$baseUrl/admin/recharges',
        query: queryParams,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      
      if (response.status.isOk && response.body != null) {
        final Map<String, dynamic> responseData = response.body as Map<String, dynamic>;
        final Map<String, dynamic>? dataObj = responseData['data'] as Map<String, dynamic>?;
        
        if (dataObj != null) {
          // Parse list
          final listData = dataObj['data'] as List?;
          if (listData != null) {
            rechargeList.value = listData
                .map((e) => AdminRechargeModel.fromJson(e as Map<String, dynamic>))
                .toList();
          } else {
            rechargeList.clear();
          }
          
          // Parse meta info
          final meta = dataObj['meta'] as Map<String, dynamic>?;
          if (meta != null) {
            currentPage.value = meta['current_page'] as int? ?? page;
            totalPages.value = meta['last_page'] as int? ?? 1;
            totalRecharges.value = meta['total'] as int? ?? 0;
          }
        } else {
          rechargeList.clear();
        }
        
        // Parse summaries
        final summary = responseData['summary'] as Map<String, dynamic>?;
        if (summary != null) {
          pendingRecharges.value = summary['pending_recharges'] as int? ?? 0;
          successfulRecharges.value = summary['successful_recharges'] as int? ?? 0;
          failedRecharges.value = summary['failed_recharges'] as int? ?? 0;
          final totalFromSummary = summary['total_recharges'] as int?;
          if (totalFromSummary != null) {
            totalRecharges.value = totalFromSummary;
          }
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load recharges: ${response.statusText}',
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
      isLoadingRecharges.value = false;
    }
  }

  Future<void> _updateStatus(int id, String status, String adminNote) async {
    isLoadingRecharges.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.patch(
        '$baseUrl/admin/recharges/$id/status',
        {
          'status': status,
          'admin_note': adminNote,
        },
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      
      if (response.status.isOk) {
        Get.snackbar(
          'Success',
          'Status updated successfully to $status!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        // Refresh list
        await fetchRecharges(currentPage.value);
      } else {
        Get.snackbar(
          'Error',
          'Failed to update status: ${response.statusText}',
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
      isLoadingRecharges.value = false;
    }
  }

  void approveRecharge(int id, String adminNote) {
    _updateStatus(id, 'approved', adminNote);
  }

  void rejectRecharge(int id, String adminNote) {
    _updateStatus(id, 'rejected', adminNote);
  }
}
