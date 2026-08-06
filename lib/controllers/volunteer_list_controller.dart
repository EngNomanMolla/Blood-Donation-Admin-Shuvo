import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/volunteer_request.dart';

class VolunteerListController extends GetxController {
  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  final searchQuery = ''.obs;
  final selectedStatusFilter = 'Volunteers'.obs;

  // Pagination & requests data
  final requests = <VolunteerRequest>[].obs;
  final isLoadingRequests = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVolunteerRequests(1);
  }

  void setStatusFilter(String filter) {
    selectedStatusFilter.value = filter;
    fetchVolunteerRequests(1);
  }

  void onChangeSearch(String query) {
    searchQuery.value = query;
    fetchVolunteerRequests(1);
  }

  // ── Volunteer Requests API ─────────────────────────────────────────────────

  Future<void> fetchVolunteerRequests(int page) async {
    isLoadingRequests.value = true;
    currentPage.value = page;

    final filter = selectedStatusFilter.value;
    String status = 'accepted';
    if (filter == 'Requests') {
      status = 'pending';
    } else if (filter == 'Rejected') {
      status = 'suspended';
    }

    final Map<String, String> queryParams = {
      'page': page.toString(),
      'status': status,
    };

    if (searchQuery.value.isNotEmpty) {
      queryParams['search'] = searchQuery.value;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.get(
        '$baseUrl/admin/volunteer-requests',
        query: queryParams,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.status.isOk && response.body != null) {
        final Map<String, dynamic> responseData = response.body as Map<String, dynamic>;
        
        List? listData;
        if (responseData['data'] is List) {
          listData = responseData['data'] as List;
        }

        if (listData != null) {
          requests.value = listData
              .map((e) => VolunteerRequest.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          requests.clear();
        }

        // Parse meta pagination
        final meta = responseData['meta'] as Map<String, dynamic>?;
        if (meta != null) {
          currentPage.value = meta['current_page'] as int? ?? page;
          totalPages.value = meta['last_page'] as int? ?? 1;
        } else {
          totalPages.value = 1;
        }
      }
    } catch (e) {
      //
    } finally {
      isLoadingRequests.value = false;
    }
  }

  Future<void> updateRequestStatus(int id, String status) async {
    isLoadingRequests.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      // Try /status path pattern first, fallback to direct resource path
      var response = await _connect.patch(
        '$baseUrl/admin/volunteer-requests/$id/status',
        {
          'status': status,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (!response.status.isOk) {
        response = await _connect.patch(
          '$baseUrl/admin/volunteer-requests/$id',
          {
            'status': status,
          },
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.status.isOk) {
        // Refresh list
        await fetchVolunteerRequests(currentPage.value);
      } else {
        Get.snackbar(
          'Error',
          'Failed to update volunteer status: ${response.statusText}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFFECEF),
          colorText: const Color(0xFFEF4444),
        );
      }
    } catch (e) {
      //
    } finally {
      isLoadingRequests.value = false;
    }
  }

  Future<void> accept(int id) async {
    await updateRequestStatus(id, 'accepted');
  }

  Future<void> suspend(int id) async {
    await updateRequestStatus(id, 'suspended');
  }
}
