import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class DonorListController extends GetxController {
  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  final selectedDivision = Rxn<String>();
  final selectedDistrict = Rxn<String>();
  final selectedUpazila = Rxn<String>();
  
  final searchQuery = ''.obs;

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

  // Cache variables for locations
  List<Map<String, dynamic>> _rawDivisions = [];
  List<Map<String, dynamic>> _rawDistricts = [];
  List<Map<String, dynamic>> _rawUpazilas = [];

  // Dynamic donors data from API
  final donors = <UserModel>[].obs;
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    // Preload location data
    fetchDivisions();
    fetchDistrictsData();
    fetchUpazilasData();
    // Initial fetch of donors
    fetchDonors(1);
  }

  // ── Fetch Donors from Backend API ──────────────────────────────────────────

  Future<void> fetchDonors(int page) async {
    isLoading.value = true;
    currentPage.value = page;

    final Map<String, String> queryParams = {
      'page': page.toString(),
      'per_page': '15',
    };

    if (searchQuery.value.isNotEmpty) {
      queryParams['search'] = searchQuery.value;
    }
    if (selectedDivision.value != null && selectedDivision.value!.isNotEmpty) {
      queryParams['division'] = selectedDivision.value!;
    }
    if (selectedDistrict.value != null && selectedDistrict.value!.isNotEmpty) {
      queryParams['district'] = selectedDistrict.value!;
    }
    if (selectedUpazila.value != null && selectedUpazila.value!.isNotEmpty) {
      queryParams['upazila'] = selectedUpazila.value!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.get(
        '$baseUrl/admin/donors',
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
          donors.value = listData
              .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          donors.clear();
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
      // Keep existing values or empty
    } finally {
      isLoading.value = false;
    }
  }

  void onChangeSearch(String query) {
    searchQuery.value = query;
    fetchDonors(1);
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
      districts.value = ['Dhaka', 'Gazipur', 'Narayanganj'];
    }
    fetchDonors(1);
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
      upazilas.value = ['Dhanmondi', 'Mirpur', 'Gulshan'];
    }
    fetchDonors(1);
  }

  void selectUpazila(String? v) {
    selectedUpazila.value = v;
    fetchDonors(1);
  }
}
