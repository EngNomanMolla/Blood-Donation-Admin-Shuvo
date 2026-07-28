class VolunteerRequest {
  final int id;
  final String profession;
  final String? message;
  final String status;
  final String? createdAt;
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final String? userAvatar;
  final String? userGender;
  final int? userAge;
  final String? userBloodGroup;
  final String? userLocation;

  // Compatibility getter aliases for older widget structures
  String get name => userName ?? 'Unknown User';
  String get role => profession;

  VolunteerRequest({
    required this.id,
    required this.profession,
    this.message,
    required this.status,
    this.createdAt,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.userAvatar,
    this.userGender,
    this.userAge,
    this.userBloodGroup,
    this.userLocation,
  });

  factory VolunteerRequest.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    final locationJson = userJson?['location'] as Map<String, dynamic>?;
    
    // Fallback location formatting
    String? locationDisplay = locationJson?['display'] as String? ?? locationJson?['full'] as String?;
    if (locationDisplay == null) {
      final div = locationJson?['division']?.toString();
      final dist = locationJson?['district']?.toString();
      final upa = locationJson?['upazila']?.toString();
      if (div != null && dist != null && upa != null) {
        locationDisplay = '$upa, $dist, $div';
      } else if (div != null && dist != null) {
        locationDisplay = '$dist, $div';
      } else {
        locationDisplay = div ?? userJson?['address']?.toString() ?? 'Bangladesh';
      }
    }

    return VolunteerRequest(
      id: json['id'] as int? ?? 0,
      profession: json['profession'] as String? ?? 'Volunteer',
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] as String?,
      userName: userJson?['name'] as String? ?? 'Unknown User',
      userEmail: userJson?['email'] as String?,
      userPhone: userJson?['phone'] as String?,
      userAvatar: userJson?['avatar'] as String?,
      userGender: userJson?['gender_label'] as String? ?? userJson?['gender'] as String? ?? 'Unknown',
      userAge: (userJson != null && userJson['age'] is int)
          ? userJson['age'] as int
          : int.tryParse(userJson?['age']?.toString() ?? ''),
      userBloodGroup: userJson?['blood_group'] as String? ?? 'N/A',
      userLocation: locationDisplay,
    );
  }
}
