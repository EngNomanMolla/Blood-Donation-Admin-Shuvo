import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/complaint_model.dart';

class ComplaintController extends GetxController {
  final complaintsList = <ComplaintModel>[].obs;
  final isLoading = false.obs;
  final isUpdatingStatus = false.obs;
  final isDeleting = false.obs;

  // Pagination & meta
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalComplaints = 0.obs;

  // Filter & Search
  // Status filter can be: 'all', 'pending', 'in_progress', 'resolved', 'rejected'
  final selectedStatusFilter = 'all'.obs;
  final searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Summary counts
  final pendingComplaints = 0.obs;
  final inProgressComplaints = 0.obs;
  final resolvedComplaints = 0.obs;
  final rejectedComplaints = 0.obs;

  final GetConnect _connect = GetConnect(timeout: const Duration(seconds: 15));
  final String baseUrl = 'https://bloodlinkonline.xyz/api/v1';
  final String fallbackBaseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    fetchComplaints(page: 1);
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void setStatusFilter(String filter) {
    if (selectedStatusFilter.value != filter) {
      selectedStatusFilter.value = filter;
      fetchComplaints(page: 1);
    }
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (searchQuery.value != query.trim()) {
        searchQuery.value = query.trim();
        fetchComplaints(page: 1);
      }
    });
  }

  void onSearchSubmitted(String query) {
    _searchDebounce?.cancel();
    searchQuery.value = query.trim();
    fetchComplaints(page: 1);
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    searchController.clear();
    if (searchQuery.value.isNotEmpty) {
      searchQuery.value = '';
      fetchComplaints(page: 1);
    }
  }

  Future<void> fetchComplaints({int page = 1}) async {
    isLoading.value = true;
    currentPage.value = page;

    final filter = selectedStatusFilter.value.trim().toLowerCase();
    final search = searchQuery.value.trim();

    final Map<String, String> queryParams = {
      'per_page': '15',
      'page': page.toString(),
    };

    if (filter.isNotEmpty && filter != 'all') {
      queryParams['status'] = filter;
    }

    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      var response = await _connect.get(
        '$baseUrl/admin/complaints',
        query: queryParams,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (!response.status.isOk) {
        response = await _connect.get(
          '$fallbackBaseUrl/admin/complaints',
          query: queryParams,
          headers: {
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.status.isOk && response.body != null) {
        dynamic rawData = response.body;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }

        if (rawData is Map<String, dynamic>) {
          // Parse data list
          final dataWrapper = rawData['data'];
          if (dataWrapper is Map<String, dynamic>) {
            final list = dataWrapper['data'] as List?;
            if (list != null) {
              complaintsList.value = list
                  .map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
                  .toList();
            } else {
              complaintsList.clear();
            }

            final meta = dataWrapper['meta'] as Map<String, dynamic>?;
            if (meta != null) {
              currentPage.value = meta['current_page'] as int? ?? page;
              totalPages.value = meta['last_page'] as int? ?? 1;
              totalComplaints.value = meta['total'] as int? ?? complaintsList.length;
            }
          } else if (dataWrapper is List) {
            complaintsList.value = dataWrapper
                .map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }

          // Parse summary
          final summary = rawData['summary'] as Map<String, dynamic>?;
          if (summary != null) {
            final parsedSummary = ComplaintSummary.fromJson(summary);
            totalComplaints.value = parsedSummary.totalComplaints;
            pendingComplaints.value = parsedSummary.pendingComplaints;
            inProgressComplaints.value = parsedSummary.inProgressComplaints;
            resolvedComplaints.value = parsedSummary.resolvedComplaints;
            rejectedComplaints.value = parsedSummary.rejectedComplaints;
          }
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load complaints: ${response.statusText ?? "Unknown error"}',
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

  Future<bool> updateComplaintStatus(
    int complaintId,
    String status, {
    String? adminNote,
  }) async {
    isUpdatingStatus.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final body = <String, dynamic>{
        'status': status,
        if (adminNote != null && adminNote.trim().isNotEmpty)
          'admin_note': adminNote.trim(),
      };

      // Primary patch url: /admin/complaints/{id}/status
      var response = await _connect.patch(
        '$baseUrl/admin/complaints/$complaintId/status',
        body,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      // Fallback 1: without /status suffix on https
      if (!response.status.isOk) {
        response = await _connect.patch(
          '$baseUrl/admin/complaints/$complaintId',
          body,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      }

      // Fallback 2: with fallbackBaseUrl (http)
      if (!response.status.isOk) {
        response = await _connect.patch(
          '$fallbackBaseUrl/admin/complaints/$complaintId/status',
          body,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.status.isOk) {
        String msg = 'Complaint status updated successfully.';
        if (response.body is Map && response.body['message'] != null) {
          msg = response.body['message'].toString();
        }

        // Update local item immediately for instant responsiveness
        final index = complaintsList.indexWhere((c) => c.id == complaintId);
        if (index != -1) {
          final old = complaintsList[index];
          old.status = status;
          old.statusLabel = status == 'in_progress'
              ? 'In Progress'
              : (status.length > 1
                  ? '${status[0].toUpperCase()}${status.substring(1)}'
                  : status.toUpperCase());
          if (adminNote != null && adminNote.trim().isNotEmpty) {
            old.adminNote = adminNote.trim();
          }
          complaintsList[index] = old;
          complaintsList.refresh();
        }

        Get.snackbar(
          'Success',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: const Color(0xFF2E7D32),
        );

        // Refresh list and summary metrics
        await fetchComplaints(page: currentPage.value);
        return true;
      } else {
        String errorMsg = 'Failed to update status';
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
      isUpdatingStatus.value = false;
    }
  }

  Future<bool> deleteComplaint(int complaintId) async {
    isDeleting.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      var response = await _connect.delete(
        '$baseUrl/admin/complaints/$complaintId',
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (!response.status.isOk) {
        response = await _connect.delete(
          '$fallbackBaseUrl/admin/complaints/$complaintId',
          headers: {
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.status.isOk) {
        // Remove locally immediately for instant UX
        complaintsList.removeWhere((c) => c.id == complaintId);
        complaintsList.refresh();

        Get.snackbar(
          'Success',
          'Complaint deleted successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: const Color(0xFF2E7D32),
        );

        // If this was the only item on the page and page > 1, go to previous page
        if (complaintsList.length <= 1 && currentPage.value > 1) {
          await fetchComplaints(page: currentPage.value - 1);
        } else {
          await fetchComplaints(page: currentPage.value);
        }
        return true;
      } else {
        String errorMsg = 'Failed to delete complaint';
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
      isDeleting.value = false;
    }
  }
}

