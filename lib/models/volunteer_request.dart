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
    if (upa != null && upa.isNotEmpty && upa.toLowerCase() != 'null') parts.add(upa);
    if (dist != null && dist.isNotEmpty && dist.toLowerCase() != 'null') parts.add(dist);
    if (div != null && div.isNotEmpty && div.toLowerCase() != 'null') parts.add(div);
    
    String locationDisplay = parts.join(', ');
    if (locationDisplay.isEmpty) {
      locationDisplay = locationJson?['display'] as String? ?? 
                        locationJson?['full'] as String? ?? 
                        userJson?['address'] as String? ?? 
                        'Bangladesh';
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
      amount: (json['amount'] as num?)?.toDouble(),
      method: json['method'] as String?,
      transactionId: json['transaction_id'] as String?,
      senderNumber: json['sender_number'] as String?,
      paymentStatus: json['payment_status'] as String?,
      adminNote: json['admin_note'] as String?,
    );
  }
}
