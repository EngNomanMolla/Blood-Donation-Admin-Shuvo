import 'package:get/get.dart';
import '../models/volunteer_profile_model.dart';
import '../models/recharge_model.dart';

class VolunteerProfileController extends GetxController {
  final profile = Rx<VolunteerProfileModel>(
    const VolunteerProfileModel(
      name: "Miraj Ahmed",
      email: "mirajahmed3540@gmail.com",
      phone: "+880 1234 567890",
      bloodGroup: "A-",
      level: "A",
      totalRegistration: "1,250",
      totalEarning: "1,500",
      totalWithdraw: "1,000",
      currentBalance: "500",
      isBlocked: false,
    ),
  );

  final transactions = <RechargeModel>[
    const RechargeModel(
      id: 'TRX001',
      amount: '৳500',
      date: '12 Apr 2026',
      time: '10:30 AM',
      method: 'Cash Out',
      status: 'success',
    ),
    const RechargeModel(
      id: 'TRX002',
      amount: '৳200',
      date: '10 Apr 2026',
      time: '02:15 PM',
      method: 'Cash In',
      status: 'success',
    ),
    const RechargeModel(
      id: 'TRX003',
      amount: '৳300',
      date: '08 Apr 2026',
      time: '11:45 AM',
      method: 'Cash Out',
      status: 'pending',
    ),
  ].obs;

  void toggleBlock() {
    profile.value = profile.value.copyWith(isBlocked: !profile.value.isBlocked);
  }
}
