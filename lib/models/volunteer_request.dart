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
  final String? dateOfBirth;
  
  // Payment info
  final double? amount;
  final String? method;
  final String? transactionId;
  final String? senderNumber;
  final String? paymentStatus;
  final String? adminNote;

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
    this.dateOfBirth,
    this.amount,
    this.method,
    this.transactionId,
    this.senderNumber,
    this.paymentStatus,
    this.adminNote,
  });

  factory VolunteerRequest.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    final locationJson = userJson?['location'] as Map<String, dynamic>?;
    
    final div = locationJson?['division']?.toString() ?? userJson?['division']?.toString();
    final dist = locationJson?['district']?.toString() ?? userJson?['district']?.toString();
    final upa = locationJson?['upazila']?.toString() ?? userJson?['upazila']?.toString();
    
    final List<String> parts = [];
    if (div != null && div.isNotEmpty && div.toLowerCase() != 'null') parts.add(div);
    if (dist != null && dist.isNotEmpty && dist.toLowerCase() != 'null') parts.add(dist);
    if (upa != null && upa.isNotEmpty && upa.toLowerCase() != 'null') parts.add(upa);
    
    String locationDisplay = parts.join(', ');
    if (locationDisplay.isEmpty) {
      final fallbackLocation = locationJson?['display'] as String? ?? 
                               locationJson?['full'] as String? ?? 
                               userJson?['address'] as String?;
      if (fallbackLocation != null && fallbackLocation.isNotEmpty && fallbackLocation.toLowerCase() != 'null') {
        locationDisplay = fallbackLocation;
      } else {
        locationDisplay = '-';
      }
    }

    // Gender fallback checking
    String genderVal = userJson?['gender_label']?.toString() ?? userJson?['gender']?.toString() ?? '';
    if (genderVal.isEmpty || genderVal.toLowerCase() == 'null') {
      genderVal = '-';
    }

    // Name fallback checking
    String nameVal = userJson?['name']?.toString() ?? '';
    if (nameVal.isEmpty || nameVal.toLowerCase() == 'null') {
      nameVal = '-';
    }

    // Phone fallback checking
    String phoneVal = userJson?['phone']?.toString() ?? '';
    if (phoneVal.isEmpty || phoneVal.toLowerCase() == 'null') {
      phoneVal = '-';
    }

    // Email fallback checking
    String emailVal = userJson?['email']?.toString() ?? '';
    if (emailVal.isEmpty || emailVal.toLowerCase() == 'null') {
      emailVal = '-';
    }

    // Blood group fallback checking
    String bgVal = userJson?['blood_group']?.toString() ?? '';
    if (bgVal.isEmpty || bgVal.toLowerCase() == 'null') {
      bgVal = '-';
    }

    // Date of birth fallback checking
    String dobVal = userJson?['date_of_birth']?.toString() ?? userJson?['dob']?.toString() ?? '';
    if (dobVal.isEmpty || dobVal.toLowerCase() == 'null') {
      dobVal = '-';
    }

    // Profession fallback checking
    String profVal = json['profession']?.toString() ?? '';
    if (profVal.isEmpty || profVal.toLowerCase() == 'null') {
      profVal = '-';
    }

    return VolunteerRequest(
      id: json['id'] as int? ?? 0,
      profession: profVal,
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] as String?,
      userName: nameVal,
      userEmail: emailVal,
      userPhone: phoneVal,
      userAvatar: userJson?['avatar'] as String?,
      userGender: genderVal,
      userAge: (userJson != null && userJson['age'] is int)
          ? userJson['age'] as int
          : int.tryParse(userJson?['age']?.toString() ?? ''),
      userBloodGroup: bgVal,
      userLocation: locationDisplay,
      dateOfBirth: dobVal,
      amount: (json['amount'] as num?)?.toDouble(),
      method: json['method'] as String?,
      transactionId: json['transaction_id'] as String?,
      senderNumber: json['sender_number'] as String?,
      paymentStatus: json['payment_status'] as String?,
      adminNote: json['admin_note'] as String?,
    );
  }
}
