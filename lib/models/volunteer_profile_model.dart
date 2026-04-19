class VolunteerProfileModel {
  final String name;
  final String email;
  final String phone;
  final String bloodGroup;
  final String level;
  final String totalRegistration;
  final String totalEarning;
  final String totalWithdraw;
  final String currentBalance;
  final bool isBlocked;

  const VolunteerProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.bloodGroup,
    required this.level,
    required this.totalRegistration,
    required this.totalEarning,
    required this.totalWithdraw,
    required this.currentBalance,
    this.isBlocked = false,
  });

  VolunteerProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? bloodGroup,
    String? level,
    String? totalRegistration,
    String? totalEarning,
    String? totalWithdraw,
    String? currentBalance,
    bool? isBlocked,
  }) {
    return VolunteerProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      level: level ?? this.level,
      totalRegistration: totalRegistration ?? this.totalRegistration,
      totalEarning: totalEarning ?? this.totalEarning,
      totalWithdraw: totalWithdraw ?? this.totalWithdraw,
      currentBalance: currentBalance ?? this.currentBalance,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}
