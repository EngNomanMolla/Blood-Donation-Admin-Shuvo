import 'package:get/get.dart';
import '../models/volunteer_request.dart';

class AdminController extends GetxController {
  final requests = <VolunteerRequest>[
    VolunteerRequest(id: 1, profession: 'Paramedic', status: 'pending', userName: 'Emili Dash'),
    VolunteerRequest(
        id: 2, profession: 'Paramedic', status: 'suspended', userName: 'Emili Dash'),
    VolunteerRequest(
        id: 3, profession: 'Paramedic', status: 'accepted', userName: 'Emili Dash'),
  ].obs;

  int get newCount =>
      requests.where((r) => r.status.toLowerCase() == 'pending').length;

  void accept(int index) {
    final item = requests[index];
    requests[index] = VolunteerRequest(
      id: item.id,
      profession: item.profession,
      message: item.message,
      status: 'accepted',
      userName: item.userName,
      userEmail: item.userEmail,
      userPhone: item.userPhone,
      userAvatar: item.userAvatar,
      userGender: item.userGender,
      userAge: item.userAge,
      userBloodGroup: item.userBloodGroup,
      userLocation: item.userLocation,
    );
  }

  void suspend(int index) {
    final item = requests[index];
    requests[index] = VolunteerRequest(
      id: item.id,
      profession: item.profession,
      message: item.message,
      status: 'suspended',
      userName: item.userName,
      userEmail: item.userEmail,
      userPhone: item.userPhone,
      userAvatar: item.userAvatar,
      userGender: item.userGender,
      userAge: item.userAge,
      userBloodGroup: item.userBloodGroup,
      userLocation: item.userLocation,
    );
  }
}
