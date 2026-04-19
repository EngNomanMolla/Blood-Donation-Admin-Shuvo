import 'package:get/get.dart';
import '../models/volunteer_model.dart';
import '../models/volunteer_request.dart';

class VolunteerListController extends GetxController {
  // Filter state
  final selectedDivision = Rxn<String>();
  final selectedDistrict = Rxn<String>();
  final selectedUpazila = Rxn<String>();
  final selectedThana = Rxn<String>();

  final divisions = ['Dhaka', 'Chittagong', 'Rajshahi', 'Khulna'];
  final districts = ['Dhaka', 'Gazipur', 'Narayanganj'];
  final upazilas = ['Dhanmondi', 'Mirpur', 'Gulshan'];
  final thanas = ['Dhanmondi', 'Kalabagan', 'Hazaribagh'];

  final searchQuery = ''.obs;

  final allVolunteers = const [
    VolunteerModel(
      name: 'Emili Dash',
      age: '24 Years',
      gender: 'Female',
      location: 'Dhaka, Bangladesh',
      bloodGroup: 'B+',
    ),
    VolunteerModel(
      name: 'Rujayen Ahnaf',
      age: '24 Years',
      gender: 'Female',
      location: 'Dhaka, Bangladesh',
      bloodGroup: 'B+',
    ),
    VolunteerModel(
      name: 'Rufayed Ahnaf',
      age: '24 Years',
      gender: 'Female',
      location: 'Dhaka, Bangladesh',
      bloodGroup: 'B+',
    ),
  ];

  List<VolunteerModel> get volunteers {
    if (searchQuery.value.isEmpty) return allVolunteers;
    return allVolunteers.where((v) {
      final query = searchQuery.value.toLowerCase();
      return v.name.toLowerCase().contains(query) ||
             v.bloodGroup.toLowerCase().contains(query);
    }).toList();
  }

  void onChangeSearch(String query) => searchQuery.value = query;

  // Requests data
  final requests = [
    VolunteerRequest(name: 'Emili Dash', role: 'Paramedic'),
    VolunteerRequest(name: 'Emili Dash', role: 'Paramedic', status: VolunteerStatus.suspended),
    VolunteerRequest(name: 'Emili Dash', role: 'Paramedic', status: VolunteerStatus.accepted),
  ].obs;

  void selectDivision(String? v) => selectedDivision.value = v;
  void selectDistrict(String? v) => selectedDistrict.value = v;
  void selectUpazila(String? v) => selectedUpazila.value = v;
  void selectThana(String? v) => selectedThana.value = v;

  int get newCount => requests.where((r) => r.status == VolunteerStatus.none).length;

  void accept(int index) {
    requests[index].status = VolunteerStatus.accepted;
    requests.refresh();
  }

  void suspend(int index) {
    requests[index].status = VolunteerStatus.suspended;
    requests.refresh();
  }
}
