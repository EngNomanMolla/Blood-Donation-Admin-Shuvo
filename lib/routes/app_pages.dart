import 'package:get/get.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/admin_panel_screen.dart';
import '../views/screens/user_list_screen.dart';
import '../views/screens/donor_list_screen.dart';
import '../views/screens/volunteer_list_screen.dart';
import '../views/screens/volunteer_profile_screen.dart';
import '../views/screens/send_notification_screen.dart';
import '../views/screens/user_details_screen.dart';
import '../views/screens/donor_details_screen.dart';
import '../controllers/home_controller.dart';
import '../controllers/admin_controller.dart';
import '../controllers/user_list_controller.dart';
import '../controllers/donor_list_controller.dart';
import '../controllers/volunteer_list_controller.dart';
import '../controllers/volunteer_profile_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/user_details_controller.dart';
import '../controllers/donor_details_controller.dart';
import '../controllers/recharge_controller.dart';
import '../views/screens/recharge_requests_screen.dart';
import '../controllers/subscription_controller.dart';
import '../views/screens/subscription_plans_screen.dart';
import '../controllers/auth_controller.dart';
import '../views/screens/login_screen.dart';
import '../views/screens/register_screen.dart';
import '../views/screens/withdrawal_list_screen.dart';
import '../controllers/withdrawal_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
      name: _Paths.ADMIN_PANEL,
      page: () => const AdminPanelScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminController>(() => AdminController());
      }),
    ),
    GetPage(
      name: _Paths.USER_LIST,
      page: () => const UserListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UserListController>(() => UserListController());
      }),
    ),
    GetPage(
      name: _Paths.DONOR_LIST,
      page: () => const DonorListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DonorListController>(() => DonorListController());
      }),
    ),
    GetPage(
      name: _Paths.VOLUNTEER_LIST,
      page: () => const VolunteerListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VolunteerListController>(() => VolunteerListController());
      }),
    ),
    GetPage(
      name: _Paths.VOLUNTEER_PROFILE,
      page: () => const VolunteerProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VolunteerProfileController>(
          () => VolunteerProfileController(),
        );
      }),
    ),
    GetPage(
      name: _Paths.SEND_NOTIFICATION,
      page: () => const SendNotificationScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NotificationController>(() => NotificationController());
      }),
    ),
    GetPage(
      name: _Paths.USER_DETAILS,
      page: () => const UserDetailsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UserDetailsController>(() => UserDetailsController());
      }),
    ),
    GetPage(
      name: _Paths.DONOR_DETAILS,
      page: () => const DonorDetailsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DonorDetailsController>(() => DonorDetailsController());
      }),
    ),
    GetPage(
      name: _Paths.RECHARGE_REQUESTS,
      page: () => const RechargeRequestsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<RechargeController>(() => RechargeController());
      }),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTION_PLANS,
      page: () => const SubscriptionPlansScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SubscriptionController>(() => SubscriptionController());
      }),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: _Paths.WITHDRAWAL_LIST,
      page: () => const WithdrawalListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WithdrawalController>(() => WithdrawalController());
      }),
    ),
  ];
}
