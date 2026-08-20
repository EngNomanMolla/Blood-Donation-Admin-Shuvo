import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/withdrawal_model.dart';

class WithdrawalController extends GetxController {
  final withdrawalList = <WithdrawalModel>[].obs;
  final isLoadingWithdrawals = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalWithdrawals = 0.obs;
  final pendingWithdrawals = 0.obs;
  final approvedWithdrawals = 0.obs;
  final rejectedWithdrawals = 0.obs;

  final selectedStatusFilter = 'Pending'.obs;

  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  @override
  void onInit() {
    super.onInit();
    fetchWithdrawals(1);
  }

  void setStatusFilter(String? filter) {
    if (filter != null) {
      selectedStatusFilter.value = filter;
      fetchWithdrawals(1);
    }
  }

  Future<void> fetchWithdrawals(int page) async {
    isLoadingWithdrawals.value = true;
    currentPage.value = page;

    final filter = selectedStatusFilter.value.toLowerCase();
    
    // Build query parameters
    final Map<String, String> queryParams = {
      'per_page': '15',
      'page': page.toString(),
    };
    
    if (filter != 'all') {
      queryParams['status'] = filter;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.get(
        '$baseUrl/admin/withdrawals',
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
            withdrawalList.value = listData
                .map((e) => WithdrawalModel.fromJson(e as Map<String, dynamic>))
                .toList();
          } else {
            withdrawalList.clear();
          }
          
          // Parse meta info
          final meta = dataObj['meta'] as Map<String, dynamic>?;
          if (meta != null) {
            currentPage.value = meta['current_page'] as int? ?? page;
            totalPages.value = meta['last_page'] as int? ?? 1;
            totalWithdrawals.value = meta['total'] as int? ?? 0;
          }
        } else {
          withdrawalList.clear();
        }
        
        // Parse summaries
        final summary = responseData['summary'] as Map<String, dynamic>?;
        if (summary != null) {
          pendingWithdrawals.value = summary['pending_withdrawals'] as int? ?? 0;
          approvedWithdrawals.value = summary['approved_withdrawals'] as int? ?? 0;
          rejectedWithdrawals.value = summary['rejected_withdrawals'] as int? ?? 0;
          final totalFromSummary = summary['total_withdrawals'] as int?;
          if (totalFromSummary != null) {
            totalWithdrawals.value = totalFromSummary;
          }
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load withdrawals: ${response.statusText}',
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
      isLoadingWithdrawals.value = false;
    }
  }

  Future<void> _updateStatus(int id, String status, String adminNote) async {
    isLoadingWithdrawals.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      // Try hitting /status suffix endpoint first
      var response = await _connect.patch(
        '$baseUrl/admin/withdrawals/$id/status',
        {
          'status': status,
          'admin_note': adminNote,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      
      // Fallback to direct patch endpoint
      if (!response.status.isOk) {
        response = await _connect.patch(
          '$baseUrl/admin/withdrawals/$id',
          {
            'status': status,
            'admin_note': adminNote,
          },
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.status.isOk) {
        Get.snackbar(
          'Success',
          'Status updated successfully to $status!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        // Refresh list
        await fetchWithdrawals(currentPage.value);
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
      isLoadingWithdrawals.value = false;
    }
  }

  void approveWithdrawal(int id, String adminNote) {
    _updateStatus(id, 'approved', adminNote);
  }

  void rejectWithdrawal(int id, String adminNote) {
    _updateStatus(id, 'rejected', adminNote);
  }
}
