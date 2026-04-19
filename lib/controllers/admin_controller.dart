import 'package:get/get.dart';
import '../models/volunteer_request.dart';

class AdminController extends GetxController {
  final requests = <VolunteerRequest>[
    VolunteerRequest(name: 'Emili Dash', role: 'Paramedic'),
    VolunteerRequest(
        name: 'Emili Dash', role: 'Paramedic', status: VolunteerStatus.suspended),
    VolunteerRequest(
        name: 'Emili Dash', role: 'Paramedic', status: VolunteerStatus.accepted),
  ].obs;

  int get newCount =>
      requests.where((r) => r.status == VolunteerStatus.none).length;

  void accept(int index) {
    requests[index].status = VolunteerStatus.accepted;
    requests.refresh();
  }

  void suspend(int index) {
    requests[index].status = VolunteerStatus.suspended;
    requests.refresh();
  }
}
