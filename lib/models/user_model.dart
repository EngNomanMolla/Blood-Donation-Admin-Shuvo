class UserModel {
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
}
