import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/volunteer_request.dart';
import 'blood_group_badge.dart';

class VolunteerRequestCard extends StatelessWidget {
  final VolunteerRequest request;
  final VoidCallback onAccept;
  final VoidCallback onSuspend;

  const VolunteerRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onSuspend,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar with premium gradient border
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFE91E63), Color(0xFFFF8A80)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFFFF0F3),
                      child: Icon(
                        Icons.person_rounded,
                        color: const Color(0xFFE91E63).withValues(alpha: 0.7),
                        size: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Name & Location Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              request.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color(0xFF1A1A2E),
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                          if (request.userBloodGroup != null && request.userBloodGroup != 'N/A')
                            Transform.scale(
                              scale: 0.85,
                              child: BloodGroupBadge(group: request.userBloodGroup!),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        request.role,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFF1F3F5)),
            
            // Details summary (Location, payment)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[400]),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    request.userLocation ?? 'Bangladesh',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (request.amount != null || request.transactionId != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFE0E6), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wallet_giftcard_rounded, size: 14, color: Color(0xFFE91E63)),
                    const SizedBox(width: 6),
                    Text(
                      'Payment: ৳${request.amount?.toStringAsFixed(0) ?? '0'} via ${request.method?.toUpperCase() ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Elegant Buttons (Accept - Green, Reject - Red)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildActionButton(
                  label: 'Accept',
                  icon: Icons.check_circle_outline_rounded,
                  color: const Color(0xFF2E7D32),
                  onTap: onAccept,
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  label: 'Reject',
                  icon: Icons.highlight_off_rounded,
                  color: const Color(0xFFD32F2F),
                  onTap: onSuspend,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pull handle
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFFFDF2F4),
                      child: Icon(
                        Icons.person_rounded,
                        color: const Color(0xFFE91E63).withValues(alpha: 0.6),
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          Text(
                            request.role,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (request.userBloodGroup != null && request.userBloodGroup != 'N/A')
                      BloodGroupBadge(group: request.userBloodGroup!),
                  ],
                ),
                const Divider(height: 32),

                // Personal Info Section
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.email_outlined, 'Email', request.userEmail ?? 'No Email'),
                _buildInfoRow(Icons.phone_android_rounded, 'Phone', request.userPhone ?? 'No Phone', copyable: request.userPhone != null),
                _buildInfoRow(Icons.location_on_outlined, 'Location', request.userLocation ?? 'Bangladesh'),
                _buildInfoRow(Icons.cake_outlined, 'Age', request.userAge != null ? '${request.userAge} Years' : 'Age N/A'),
                _buildInfoRow(Icons.face_unlock_rounded, 'Gender', request.userGender ?? 'Unknown'),

                if (request.message != null && request.message!.isNotEmpty) ...[
                  const Divider(height: 32),
                  const Text(
                    'Application Message',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(
                      request.message!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],

                // Payment Info Section
                if (request.amount != null || request.transactionId != null) ...[
                  const Divider(height: 32),
                  const Text(
                    'Payment / Recharge Information',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.account_balance_wallet_outlined,
                    'Amount',
                    '৳${request.amount?.toStringAsFixed(0) ?? '0'}',
                  ),
                  _buildInfoRow(
                    Icons.payment_rounded,
                    'Payment Method',
                    request.method?.toUpperCase() ?? 'N/A',
                  ),
                  _buildInfoRow(
                    Icons.tag_rounded,
                    'Transaction ID',
                    request.transactionId ?? 'N/A',
                    copyable: request.transactionId != null,
                  ),
                  _buildInfoRow(
                    Icons.phone_android_rounded,
                    'Sender Number',
                    request.senderNumber ?? 'N/A',
                    copyable: request.senderNumber != null,
                  ),
                  _buildInfoRow(
                    Icons.check_circle_outline_rounded,
                    'Payment Status',
                    request.paymentStatus?.toUpperCase() ?? 'PENDING',
                    valueColor: _getStatusColor(request.paymentStatus),
                  ),
                  if (request.adminNote != null && request.adminNote!.isNotEmpty)
                    _buildInfoRow(
                      Icons.note_alt_outlined,
                      'Admin Note',
                      request.adminNote!,
                    ),
                ],

                const SizedBox(height: 24),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          onAccept();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Accept Application',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          onSuspend();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Suspend / Reject',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey.shade200, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Close Details',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool copyable = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[400]),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: valueColor ?? const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (copyable && value != 'N/A') ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      Get.snackbar(
                        'Copied',
                        '$label copied to clipboard!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFE91E63).withValues(alpha: 0.1),
                        colorText: const Color(0xFFE91E63),
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.copy_rounded, size: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return const Color(0xFFE65100);
    switch (status.toLowerCase()) {
      case 'success':
      case 'approved':
      case 'accepted':
        return const Color(0xFF2E7D32);
      case 'failed':
      case 'rejected':
      case 'suspended':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFFE65100); // pending
    }
  }
}
