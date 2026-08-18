import 'package:get/get.dart';
import '../models/volunteer_request.dart';

class AdminController extends GetxController {
  final requests = <VolunteerRequest>[
    VolunteerRequest(
      id: 1,
      profession: 'Paramedic',
      status: 'pending',
      userName: 'Emili Dash',
      userEmail: 'emili.dash@gmail.com',
      userPhone: '+880 1712 345678',
      userLocation: 'Dhaka, Dhaka, Dhanmondi',
      dateOfBirth: '1998-05-12',
      userGender: 'Female',
      userBloodGroup: 'B+',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      message: 'I want to help register non-donor users and manage local camps.',
    ),
    VolunteerRequest(
      id: 2,
      profession: 'Paramedic',
      status: 'suspended',
      userName: 'Rujayen Ahnaf',
      userEmail: 'rujayen.ahnaf@gmail.com',
      userPhone: '+880 1812 345678',
      userLocation: 'Chattogram, Chattogram, Halishahar',
      dateOfBirth: '2000-08-25',
      userGender: 'Male',
      userBloodGroup: 'O+',
      userAvatar: 'https://i.pravatar.cc/150?img=8',
      message: 'Interested in clinical support during blood collection campaigns.',
    ),
    VolunteerRequest(
      id: 3,
      profession: 'Paramedic',
      status: 'accepted',
      userName: 'Rufayed Ahnaf',
      userEmail: 'rufayed.ahnaf@gmail.com',
      userPhone: '+880 1912 345678',
      userLocation: 'Rajshahi, Rajshahi, Boalia',
      dateOfBirth: '1995-11-03',
      userGender: 'Male',
      userBloodGroup: 'AB+',
      userAvatar: 'https://i.pravatar.cc/150?img=11',
      message: 'Dedicated medical professional looking to volunteer weekly.',
    ),
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
      dateOfBirth: item.dateOfBirth,
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
      dateOfBirth: item.dateOfBirth,
    );
  }
}
