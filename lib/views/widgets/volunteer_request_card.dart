import 'package:flutter/material.dart';
import '../../models/volunteer_request.dart';
import 'action_button.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with ring
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFE0E6), width: 1),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFFDF2F4),
              child: Icon(
                Icons.person_rounded,
                color: const Color(0xFFE91E63).withValues(alpha: 0.6),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name, Role & Buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  request.role,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ThemeActionButton(
                      label: 'Accept',
                      isActive: request.status == VolunteerStatus.accepted,
                      activeColor: const Color(0xFF2E7D32),
                      onTap: onAccept,
                    ),
                    const SizedBox(width: 8),
                    ThemeActionButton(
                      label: 'Suspend',
                      isActive: request.status == VolunteerStatus.suspended,
                      activeColor: const Color(0xFFE91E63),
                      onTap: onSuspend,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
