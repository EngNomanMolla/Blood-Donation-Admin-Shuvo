enum VolunteerStatus { none, accepted, suspended }

class VolunteerRequest {
  final String name;
  final String role;
  VolunteerStatus status;

  VolunteerRequest({
    required this.name,
    required this.role,
    this.status = VolunteerStatus.none,
  });
}
