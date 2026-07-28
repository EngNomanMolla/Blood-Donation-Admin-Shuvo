import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/recharge_controller.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/dashboard_menu_card.dart';
import '../widgets/volunteer_request_card.dart';
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
                    _buildMetricsRow(),
                    const SizedBox(height: 24),
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
                    _buildVolunteerSection(),
                    const SizedBox(height: 28),
                    _buildActivityFeed(),
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

  // ── Glassmorphic Metrics Row ───────────────────────────────────────────────

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricItem(
            label: 'Users',
            value: '1,248',
            bgColor: const Color(0xFFE0F2FE),
            textColor: const Color(0xFF0369A1),
            icon: Icons.group_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricItem(
            label: 'Donors',
            value: '482',
            bgColor: const Color(0xFFFCE7F3),
            textColor: const Color(0xFFBE185D),
            icon: Icons.favorite_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricItem(
            label: 'Funds',
            value: '৳8,500',
            bgColor: const Color(0xFFDCFCE7),
            textColor: const Color(0xFF15803D),
            icon: Icons.payments_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required Color bgColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: textColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: textColor.withValues(alpha: 0.6), size: 16),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor.withValues(alpha: 0.85),
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

  // ── Volunteer Section ─────────────────────────────────────────────────────

  Widget _buildVolunteerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Volunteer Requests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            Obx(() {
              final count = controller.newCount;
              if (count > 0) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '($count New)',
                    style: const TextStyle(
                      color: Color(0xFFE91E63),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.requests.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'No volunteer requests found',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.requests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return VolunteerRequestCard(
                request: controller.requests[index],
                onAccept: () => controller.accept(index),
                onSuspend: () => controller.suspend(index),
              );
            },
          );
        }),
      ],
    );
  }

  // ── Recent Activity Timeline Feed ─────────────────────────────────────────

  Widget _buildActivityFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Activity Log',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                message: 'Recharge Request approved for User SzGSt (৳50)',
                time: '10m ago',
                icon: Icons.check_circle_outline_rounded,
                color: const Color(0xFF10B981),
              ),
              const Divider(height: 20, color: Color(0xFFF1F3F5)),
              _buildActivityItem(
                message: 'New Volunteer request received from Emili Dash',
                time: '1h ago',
                icon: Icons.person_add_alt_1_rounded,
                color: const Color(0xFFF59E0B),
              ),
              const Divider(height: 20, color: Color(0xFFF1F3F5)),
              _buildActivityItem(
                message: 'Global push notification broadcasted successfully',
                time: 'Yesterday',
                icon: Icons.campaign_rounded,
                color: const Color(0xFF0EA5E9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String message,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
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
