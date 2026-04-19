import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../widgets/menu_card.dart';
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
                    _buildMenuGrid(),
                    const SizedBox(height: 24),
                    _buildVolunteerSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage blood donation system',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Color(0xFFE91E63),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // ── Menu Grid ─────────────────────────────────────────────────────────────

  Widget _buildMenuGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MenuCard(
                label: 'USER\nLIST',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE0E6), Color(0xFFFFB3C1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.people_alt_outlined,
                iconColor: const Color(0xFFE91E63),
                onTap: () => Get.toNamed(Routes.USER_LIST),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MenuCard(
                label: 'DONOR\nLIST',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE0E6), Color(0xFFFFB3C1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.volunteer_activism_outlined,
                iconColor: const Color(0xFFE91E63),
                onTap: () => Get.toNamed(Routes.DONOR_LIST),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        MenuCard(
          label: 'VOLUNTEER\nLIST',
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE0E6), Color(0xFFFFB3C1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icon: Icons.medical_services_outlined,
          iconColor: const Color(0xFFE91E63),
          isWide: true,
          onTap: () => Get.toNamed(Routes.VOLUNTEER_LIST),
        ),
        const SizedBox(height: 12),
        MenuCard(
          label: 'SEND\nNOTIFICATION',
          gradient: const LinearGradient(
            colors: [Color(0xFFE0E8FF), Color(0xFFB3C8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icon: Icons.notification_add_outlined,
          iconColor: const Color(0xFF3F51B5),
          isWide: true,
          onTap: () => Get.toNamed(Routes.SEND_NOTIFICATION),
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
              'Volunteer Request',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
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
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() => ListView.separated(
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
            )),
      ],
    );
  }
}
