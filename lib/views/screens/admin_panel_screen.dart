import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/recharge_controller.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/dashboard_menu_card.dart';
import '../../routes/app_pages.dart';

class AdminPanelScreen extends GetView<AdminController> {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Management Grid',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuGrid(context),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Premium App Bar Greeting Header ────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final authController = Get.put(AuthController());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Color(0xFF1A1A2E),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '👋',
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _getFormattedDate(),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          // Logout Action Button
          GestureDetector(
            onTap: () => _showLogoutConfirmation(context, authController),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF2F4),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE91E63).withValues(alpha: 0.15),
                  width: 1.2,
                ),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFE91E63),
                size: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 2-Column Menu Grid ─────────────────────────────────────────────────────

  Widget _buildMenuGrid(BuildContext context) {
    // Inject/Find RechargeController to listen to dynamic pending requests count
    final rechargeController = Get.put(RechargeController());

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DashboardMenuCard(
                label: 'USER LIST',
                subtitle: 'Manage system users',
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.people_alt_rounded,
                onTap: () => Get.toNamed(Routes.USER_LIST),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardMenuCard(
                label: 'DONOR LIST',
                subtitle: 'View blood donors',
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFFD946EF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.volunteer_activism_rounded,
                onTap: () => Get.toNamed(Routes.DONOR_LIST),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Obx(() => DashboardMenuCard(
                    label: 'VOLUNTEERS',
                    subtitle: 'Join requests',
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.medical_services_rounded,
                    badgeCount: controller.newCount,
                    onTap: () => Get.toNamed(Routes.VOLUNTEER_LIST),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => DashboardMenuCard(
                    label: 'RECHARGES',
                    subtitle: 'Frontend deposits',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.account_balance_wallet_rounded,
                    badgeCount: rechargeController.pendingRecharges.value,
                    onTap: () => Get.toNamed(Routes.RECHARGE_REQUESTS),
                  )),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DashboardMenuCard(
                label: 'SUBSCRIPTIONS',
                subtitle: 'Manage subscription plans',
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.card_membership_rounded,
                onTap: () => Get.toNamed(Routes.SUBSCRIPTION_PLANS),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardMenuCard(
                label: 'NOTIFICATIONS',
                subtitle: 'Send global push alerts',
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.notification_add_rounded,
                onTap: () => Get.toNamed(Routes.SEND_NOTIFICATION),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Helper: Get Dynamic Formatted Date ─────────────────────────────────────

  String _getFormattedDate() {
    final dateTime = DateTime.now();
    final weekDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final dayOfWeek = weekDays[dateTime.weekday % 7];
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    
    return '$dayOfWeek, $month $day, $year';
  }

  void _showLogoutConfirmation(BuildContext context, AuthController authController) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm Logout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to log out from the admin dashboard?',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      authController.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
