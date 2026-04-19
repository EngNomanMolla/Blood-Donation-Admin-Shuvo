import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_details_controller.dart';
import '../../models/recharge_model.dart';
import '../widgets/blood_group_badge.dart';

class UserDetailsScreen extends GetView<UserDetailsController> {
  const UserDetailsScreen({super.key});

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
                padding: const EdgeInsets.all(20),
                child: Obx(() {
                  final user = controller.user.value;
                  return Column(
                    children: [
                      _buildProfileCard(user),
                      const SizedBox(height: 20),
                      _buildInfoSection(user),
                      const SizedBox(height: 20),
                      _buildRechargeHistory(),
                      const SizedBox(height: 20),
                      _buildBlockButton(user),
                      const SizedBox(height: 30),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF1A1A2E), size: 14),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'User Details',
              style: TextStyle(
                color: Color(0xFF1A1A2E),
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile Card ────────────────────────────────────────────────────────────

  Widget _buildProfileCard(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFDF2F4),
              border: Border.all(
                color: const Color(0xFFE91E63).withValues(alpha: 0.15),
                width: 2.5,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.person_rounded,
                size: 32,
                color: const Color(0xFFE91E63).withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.age} · ${user.gender}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          BloodGroupBadge(group: user.bloodGroup),
        ],
      ),
    );
  }

  // ── Info Section ────────────────────────────────────────────────────────────

  Widget _buildInfoSection(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          _infoRow(Icons.phone_rounded, 'Phone', user.phone),
          _divider(),
          _infoRow(Icons.location_on_rounded, 'Location', user.location),
          _divider(),
          _infoRow(Icons.cake_rounded, 'Age', user.age),
          _divider(),
          _infoRow(Icons.person_outline_rounded, 'Gender', user.gender),
          _divider(),
          _infoRow(Icons.bloodtype_rounded, 'Blood Group', user.bloodGroup),
          _divider(),
          _infoRow(
            Icons.shield_rounded,
            'Status',
            user.isBlocked ? 'Blocked' : 'Active',
            valueColor: user.isBlocked ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFE91E63), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor ?? const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade100,
      height: 1,
    );
  }

  // ── Recharge History ────────────────────────────────────────────────────────

  Widget _buildRechargeHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Recharge History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${controller.rechargeHistory.length}',
                      style: const TextStyle(
                        color: Color(0xFFE91E63),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.rechargeHistory.length,
                separatorBuilder: (_, __) => Divider(
                  color: Colors.grey.shade100,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  return _rechargeCard(controller.rechargeHistory[index]);
                },
              )),
        ],
      ),
    );
  }

  Widget _rechargeCard(RechargeModel recharge) {
    Color statusColor;
    IconData statusIcon;
    switch (recharge.status) {
      case 'success':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_rounded;
        break;
      default:
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recharge.method,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${recharge.date} · ${recharge.time}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                recharge.amount,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                recharge.status[0].toUpperCase() + recharge.status.substring(1),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Block / Unblock Button ──────────────────────────────────────────────────

  Widget _buildBlockButton(user) {
    final isBlocked = user.isBlocked as bool;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => controller.toggleBlock(),
        icon: Icon(
          isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
          size: 20,
        ),
        label: Text(
          isBlocked ? 'Unblock User' : 'Block User',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isBlocked ? Colors.green : Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
