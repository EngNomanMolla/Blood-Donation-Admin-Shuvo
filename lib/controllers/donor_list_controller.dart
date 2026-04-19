import 'package:get/get.dart';
import '../models/user_model.dart';

class DonorListController extends GetxController {
  final selectedDivision = Rxn<String>();
  final selectedDistrict = Rxn<String>();
  final selectedUpazila = Rxn<String>();
  
  final searchQuery = ''.obs;

  final divisions = ['Dhaka', 'Chittagong', 'Rajshahi', 'Khulna'];
  final districts = ['Dhaka', 'Gazipur', 'Narayanganj'];
  final upazilas = ['Dhanmondi', 'Mirpur', 'Gulshan'];

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

  void selectDivision(String? v) => selectedDivision.value = v;
  void selectDistrict(String? v) => selectedDistrict.value = v;
  void selectUpazila(String? v) => selectedUpazila.value = v;
}
