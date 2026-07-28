import 'dart:convert';
import 'package:get/get.dart';
import '../models/user_model.dart';

class DonorListController extends GetxController {
  final GetConnect _connect = GetConnect();

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

  final allDonors = [
    UserModel(
      name: 'Emili Dash',
      age: '24 Years',
      gender: 'Female',
      location: 'Dhaka, Bangladesh',
      bloodGroup: 'B+',
      phone: '+880 1234 567890',
      isActive: true,
    ),
    UserModel(
      name: 'Rujayen Ahnaf',
      age: '24 Years',
      gender: 'Female',
      location: 'Dhaka, Bangladesh',
      bloodGroup: 'B+',
      phone: '+880 1234 567891',
      isActive: true,
    ),
    UserModel(
      name: 'Rufayed Ahnaf',
      age: '24 Years',
      gender: 'Female',
      location: 'Dhaka, Bangladesh',
      bloodGroup: 'B+',
      phone: '+880 1234 567892',
      isActive: true,
    ),
    UserModel(
      name: 'Emili Dash',
      age: '24 Years',
      gender: 'Female',
      location: 'Dhaka, Bangladesh',
      bloodGroup: 'B+',
      phone: '+880 1234 567893',
      isActive: true,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Preload location data
    fetchDivisions();
    fetchDistrictsData();
    fetchUpazilasData();
  }

  List<UserModel> get donors {
    if (searchQuery.value.isEmpty) return allDonors;
    return allDonors.where((donor) {
      final query = searchQuery.value.toLowerCase();
      return donor.name.toLowerCase().contains(query) ||
             donor.phone.toLowerCase().contains(query) ||
             donor.bloodGroup.toLowerCase().contains(query);
    }).toList();
  }

  void onChangeSearch(String query) => searchQuery.value = query;

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
  }

  void selectUpazila(String? v) => selectedUpazila.value = v;
}
