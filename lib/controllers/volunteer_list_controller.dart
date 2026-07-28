import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/volunteer_model.dart';
import '../models/volunteer_request.dart';

class VolunteerListController extends GetxController {
  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  // Filter state
  final selectedDivision = Rxn<String>();
  final selectedDistrict = Rxn<String>();
  final selectedUpazila = Rxn<String>();

  // Dynamic filter lists from API initialized with default fallbacks
  final divisions = <String>[
    'Dhaka',
    'Chattogram',
    'Rajshahi',
    'Khulna',
    'Barishal',
    'Sylhet',
    'Rangpur',
    'Mymensingh'
  ].obs;
  
  final districts = <String>['Dhaka', 'Gazipur', 'Narayanganj'].obs;
  final upazilas = <String>['Dhanmondi', 'Mirpur', 'Gulshan'].obs;

  final searchQuery = ''.obs;

  // Pagination & requests data
  final requests = <VolunteerRequest>[].obs;
  final isLoadingRequests = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;

  // Cache variables for locations
  List<Map<String, dynamic>> _rawDivisions = [];
  List<Map<String, dynamic>> _rawDistricts = [];
  List<Map<String, dynamic>> _rawUpazilas = [];

  @override
  void onInit() {
    super.onInit();
    // Preload all location lists on start
    fetchDivisions();
    fetchDistrictsData();
    fetchUpazilasData();
    
    fetchVolunteerRequests(1);
  }

  // Filtered computed lists for View
  List<VolunteerRequest> get pendingRequests {
    return requests.where((r) => r.status.toLowerCase() == 'pending').toList();
  }

  List<VolunteerRequest> get suspendedRequests {
    return requests.where((r) => r.status.toLowerCase() == 'suspended').toList();
  }

  List<VolunteerModel> get volunteers {
    return requests
        .where((r) => r.status.toLowerCase() == 'accepted')
        .map((r) => VolunteerModel(
              name: r.userName ?? 'Unknown User',
              age: r.userAge != null ? '${r.userAge} Years' : 'Age N/A',
              gender: r.userGender ?? 'Unknown',
              location: r.userLocation ?? 'Bangladesh',
              bloodGroup: r.userBloodGroup ?? 'N/A',
              isActive: true,
            ))
        .toList();
  }

  int get newCount => pendingRequests.length;

  void onChangeSearch(String query) {
    searchQuery.value = query;
    fetchVolunteerRequests(1);
  }

  // ── Location Fetching ──────────────────────────────────────────────────────

  Future<void> fetchDivisions() async {
    try {
      final response = await _connect.get('https://raw.githubusercontent.com/ifahimreza/bangladesh-geojson/master/src/data/bd-divisions.json');
      if (response.status.isOk && response.body != null) {
        dynamic decoded;
        if (response.body is String) {
          decoded = jsonDecode(response.body);
        } else {
          decoded = response.body;
        }

        final Map<String, dynamic> data = decoded is Map ? Map<String, dynamic>.from(decoded) : {};
        if (data['divisions'] is List) {
          _rawDivisions = List<Map<String, dynamic>>.from(data['divisions'].map((e) => Map<String, dynamic>.from(e)));
          divisions.value = _rawDivisions.map((e) => e['name']?.toString() ?? '').where((e) => e.isNotEmpty).toList();
        }
      }
    } catch (e) {
      // Keep fallbacks
    }
  }

  Future<void> fetchDistrictsData() async {
    try {
      final response = await _connect.get('https://raw.githubusercontent.com/ifahimreza/bangladesh-geojson/master/src/data/bd-districts.json');
      if (response.status.isOk && response.body != null) {
        dynamic decoded;
        if (response.body is String) {
          decoded = jsonDecode(response.body);
        } else {
          decoded = response.body;
        }

        final Map<String, dynamic> data = decoded is Map ? Map<String, dynamic>.from(decoded) : {};
        if (data['districts'] is List) {
          _rawDistricts = List<Map<String, dynamic>>.from(data['districts'].map((e) => Map<String, dynamic>.from(e)));
        }
      }
    } catch (e) {
      // Keep fallbacks
    }
  }

  Future<void> fetchUpazilasData() async {
    try {
      final response = await _connect.get('https://raw.githubusercontent.com/ifahimreza/bangladesh-geojson/master/src/data/bd-upazilas.json');
      if (response.status.isOk && response.body != null) {
        dynamic decoded;
        if (response.body is String) {
          decoded = jsonDecode(response.body);
        } else {
          decoded = response.body;
        }

        final Map<String, dynamic> data = decoded is Map ? Map<String, dynamic>.from(decoded) : {};
        if (data['upazilas'] is List) {
          _rawUpazilas = List<Map<String, dynamic>>.from(data['upazilas'].map((e) => Map<String, dynamic>.from(e)));
        }
      }
    } catch (e) {
      // Keep fallbacks
    }
  }

  void selectDivision(String? v) {
    selectedDivision.value = v;
    selectedDistrict.value = null;
    selectedUpazila.value = null;
    districts.clear();
    upazilas.clear();
    
    if (v != null && _rawDivisions.isNotEmpty) {
      final divObj = _rawDivisions.firstWhere(
        (d) => d['name']?.toString().toLowerCase() == v.toLowerCase(),
        orElse: () => {},
      );
      final String? divId = divObj['id']?.toString();
      if (divId != null) {
        districts.value = _rawDistricts
            .where((d) => d['division_id']?.toString() == divId)
            .map((d) => d['name']?.toString() ?? '')
            .where((d) => d.isNotEmpty)
            .toList();
      }
    } else if (v != null) {
      // Fallback districts if API failed
      districts.value = ['Dhaka', 'Gazipur', 'Narayanganj'];
    }
    fetchVolunteerRequests(1);
  }

  void selectDistrict(String? v) {
    selectedDistrict.value = v;
    selectedUpazila.value = null;
    upazilas.clear();
    
    if (v != null && _rawDistricts.isNotEmpty) {
      final distObj = _rawDistricts.firstWhere(
        (d) => d['name']?.toString().toLowerCase() == v.toLowerCase(),
        orElse: () => {},
      );
      final String? distId = distObj['id']?.toString();
      if (distId != null) {
        upazilas.value = _rawUpazilas
            .where((u) => u['district_id']?.toString() == distId)
            .map((u) => u['name']?.toString() ?? '')
            .where((u) => u.isNotEmpty)
            .toList();
      }
    } else if (v != null) {
      // Fallback upazilas if API failed
      upazilas.value = ['Dhanmondi', 'Mirpur', 'Gulshan'];
    }
    fetchVolunteerRequests(1);
  }

  void selectUpazila(String? v) {
    selectedUpazila.value = v;
    fetchVolunteerRequests(1);
  }

  // ── Volunteer Requests API ─────────────────────────────────────────────────

  Future<void> fetchVolunteerRequests(int page) async {
    isLoadingRequests.value = true;
    currentPage.value = page;

    final Map<String, String> queryParams = {
      'page': page.toString(),
    };

    if (searchQuery.value.isNotEmpty) {
      queryParams['search'] = searchQuery.value;
    }
    if (selectedDivision.value != null) {
      queryParams['division'] = selectedDivision.value!;
    }
    if (selectedDistrict.value != null) {
      queryParams['district'] = selectedDistrict.value!;
    }
    if (selectedUpazila.value != null) {
      queryParams['upazila'] = selectedUpazila.value!;
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
