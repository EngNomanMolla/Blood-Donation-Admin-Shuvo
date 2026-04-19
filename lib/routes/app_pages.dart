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

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ADMIN_PANEL;

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
  ];
}
