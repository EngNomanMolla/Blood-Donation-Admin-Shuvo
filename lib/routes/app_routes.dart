part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const ADMIN_PANEL = _Paths.ADMIN_PANEL;
  static const USER_LIST = _Paths.USER_LIST;
  static const DONOR_LIST = _Paths.DONOR_LIST;
  static const DONOR_DETAILS = _Paths.DONOR_DETAILS;
  static const VOLUNTEER_LIST = _Paths.VOLUNTEER_LIST;
  static const VOLUNTEER_PROFILE = _Paths.VOLUNTEER_PROFILE;
  static const SEND_NOTIFICATION = _Paths.SEND_NOTIFICATION;
  static const USER_DETAILS = _Paths.USER_DETAILS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const ADMIN_PANEL = '/admin-panel';
  static const USER_LIST = '/user-list';
  static const DONOR_LIST = '/donor-list';
  static const DONOR_DETAILS = '/donor-details';
  static const VOLUNTEER_LIST = '/volunteer-list';
  static const VOLUNTEER_PROFILE = '/volunteer-profile';
  static const SEND_NOTIFICATION = '/send-notification';
  static const USER_DETAILS = '/user-details';
}
