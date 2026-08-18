import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_details_controller.dart';
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
              image: (user.avatarAsset != null && user.avatarAsset!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(user.avatarAsset!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (user.avatarAsset != null && user.avatarAsset!.isNotEmpty)
                ? null
                : Center(
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? const Color(0xFF1A1A2E),
                ),
              ),
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



  // ── Block / Unblock Button ──────────────────────────────────────────────────

  Widget _buildBlockButton(user) {
    return Obx(() {
      final isBlocked = controller.user.value.isBlocked;
      final loading = controller.isLoading.value;
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: loading ? null : () => controller.toggleBlock(),
          icon: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
                  size: 20,
                ),
          label: Text(
            loading
                ? 'Updating...'
                : (isBlocked ? 'Unblock User' : 'Block User'),
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
    });
  }
}
