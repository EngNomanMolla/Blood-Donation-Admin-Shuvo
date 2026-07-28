import 'package:flutter/material.dart';
import '../../models/admin_recharge_model.dart';

class RechargeRequestCard extends StatelessWidget {
  final AdminRechargeModel recharge;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const RechargeRequestCard({
    super.key,
    required this.recharge,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending = recharge.status.toLowerCase() == 'pending';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row: User Avatar, Name, Phone & Amount ───────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFFDF2F4),
                  child: Text(
                    recharge.userName.isNotEmpty ? recharge.userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // User Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recharge.userName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      recharge.userPhone ?? 'No Phone',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount Tag
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '৳${recharge.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                  Text(
                    recharge.currency,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F3F5)),
          const SizedBox(height: 12),

          // ── Middle Row: Method, Status, Tx ID, Sender No ─────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Method Badge
              _buildMethodBadge(recharge.method, recharge.methodLabel),
              // Status Badge
              _buildStatusBadge(recharge.status, recharge.statusLabel),
            ],
          ),
          const SizedBox(height: 10),

          // Transaction Details Block
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoDetail(
                  label: 'TxID',
                  value: recharge.transactionId ?? 'N/A',
                  icon: Icons.vpn_key_outlined,
                ),
                if (recharge.senderNumber != null) ...[
                  const SizedBox(height: 6),
                  _buildInfoDetail(
                    label: 'Sender',
                    value: recharge.senderNumber!,
                    icon: Icons.phone_android_rounded,
                  ),
                ],
                if (recharge.note != null && recharge.note!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _buildInfoDetail(
                    label: 'Note',
                    value: recharge.note!,
                    icon: Icons.sticky_note_2_outlined,
                    italicValue: true,
                  ),
                ],
                const SizedBox(height: 6),
                _buildInfoDetail(
                  label: 'Requested',
                  value: recharge.rechargedAtLabel ?? _formatDate(recharge.createdAt),
                  icon: Icons.calendar_today_outlined,
                ),
              ],
            ),
          ),

          // ── Bottom Action Row: Approve / Reject ──────────────────────────────
          if (isPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                // Approve Button
                Expanded(
                  child: InkWell(
                    onTap: onApprove,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline_rounded, color: Color(0xFF2E7D32), size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Approve',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Reject Button
                Expanded(
                  child: InkWell(
                    onTap: onReject,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD32F2F).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel_outlined, color: Color(0xFFD32F2F), size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Reject',
                            style: TextStyle(
                              color: Color(0xFFD32F2F),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildMethodBadge(String method, String label) {
    Color bgColor;
    Color textColor;

    switch (method.toLowerCase()) {
      case 'bkash':
        bgColor = const Color(0xFFE2125B).withValues(alpha: 0.1);
        textColor = const Color(0xFFE2125B);
        break;
      case 'nagad':
        bgColor = const Color(0xFFF7941D).withValues(alpha: 0.1);
        textColor = const Color(0xFFF7941D);
        break;
      case 'rocket':
        bgColor = const Color(0xFF8C3494).withValues(alpha: 0.1);
        textColor = const Color(0xFF8C3494);
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, String label) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = const Color(0xFFFFB300).withValues(alpha: 0.1);
        textColor = const Color(0xFFE65100);
        break;
      case 'success':
      case 'approved':
        bgColor = const Color(0xFF2E7D32).withValues(alpha: 0.1);
        textColor = const Color(0xFF2E7D32);
        break;
      case 'failed':
      case 'rejected':
        bgColor = const Color(0xFFD32F2F).withValues(alpha: 0.1);
        textColor = const Color(0xFFD32F2F);
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: textColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDetail({
    required String label,
    required String value,
    required IconData icon,
    bool italicValue = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: Colors.grey[400]),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[800],
              fontWeight: italicValue ? FontWeight.w400 : FontWeight.w600,
              fontStyle: italicValue ? FontStyle.italic : FontStyle.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final day = dateTime.day;
      final month = months[dateTime.month - 1];
      final year = dateTime.year;
      
      int hour = dateTime.hour;
      final ampm = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$day $month $year · $hour:$minute $ampm';
    } catch (_) {
      return isoString;
    }
  }
}
