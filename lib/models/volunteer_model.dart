class VolunteerModel {
  final String name;
  final String age;
  final String gender;
  final String location;
  final String bloodGroup;
  final bool isActive;

  const VolunteerModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.location,
    required this.bloodGroup,
    this.isActive = true,
  });
}
