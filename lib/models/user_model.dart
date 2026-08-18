class UserModel {
  final int id;
  final String name;
  final String age;
  final String gender;
  final String location;
  final String bloodGroup;
  final String phone;
  final bool isActive;
  bool isBlocked;
  final String? avatarAsset;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.location,
    required this.bloodGroup,
    required this.phone,
    this.isActive = true,
    this.isBlocked = false,
    this.avatarAsset,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final locationJson = json['location'] as Map<String, dynamic>?;
    
    final div = json['division']?.toString() ?? locationJson?['division']?.toString();
    final dist = json['district']?.toString() ?? locationJson?['district']?.toString();
    final upa = json['upazila']?.toString() ?? locationJson?['upazila']?.toString();
    
    final List<String> parts = [];
    if (div != null && div.isNotEmpty && div.toLowerCase() != 'null') parts.add(div);
    if (dist != null && dist.isNotEmpty && dist.toLowerCase() != 'null') parts.add(dist);
    if (upa != null && upa.isNotEmpty && upa.toLowerCase() != 'null') parts.add(upa);
    
    String locationDisplay = parts.join(', ');
    if (locationDisplay.isEmpty) {
      final fallbackLocation = locationJson?['display'] as String? ?? 
                               locationJson?['full'] as String? ?? 
                               json['address'] as String?;
      if (fallbackLocation != null && fallbackLocation.isNotEmpty && fallbackLocation.toLowerCase() != 'null') {
        locationDisplay = fallbackLocation;
      } else {
        locationDisplay = '-';
      }
    }

    String ageStr = '-';
    if (json['age'] != null && json['age'].toString().toLowerCase() != 'null') {
      ageStr = '${json['age']} Years';
    }

    // fallback mapping for gender
    String genderVal = json['gender_label']?.toString() ?? json['gender']?.toString() ?? '';
    if (genderVal.isEmpty || genderVal.toLowerCase() == 'null') {
      genderVal = '-';
    }

    // fallback mapping for name
    String nameVal = json['name']?.toString() ?? '';
    if (nameVal.isEmpty || nameVal.toLowerCase() == 'null') {
      nameVal = '-';
    }

    // fallback mapping for phone
    String phoneVal = json['phone']?.toString() ?? '';
    if (phoneVal.isEmpty || phoneVal.toLowerCase() == 'null') {
      phoneVal = '-';
    }

    // fallback mapping for blood group
    String bgVal = json['blood_group']?.toString() ?? '';
    if (bgVal.isEmpty || bgVal.toLowerCase() == 'null') {
      bgVal = '-';
    }

    return UserModel(
      id: json['id'] as int? ?? 0,
      name: nameVal,
      age: ageStr,
      gender: genderVal,
      location: locationDisplay,
      bloodGroup: bgVal,
      phone: phoneVal,
      isActive: json['status'] == 'active',
      isBlocked: json['is_blocked'] == true || json['is_blocked'] == 1 || json['is_blocked'] == '1',
      avatarAsset: json['avatar'] as String?,
    );
  }
}
