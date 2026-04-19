import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/volunteer_model.dart';
import 'blood_group_badge.dart';
import '../../routes/app_pages.dart';

class VolunteerItemCard extends StatelessWidget {
  final VolunteerModel volunteer;

  const VolunteerItemCard({super.key, required this.volunteer});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.VOLUNTEER_PROFILE),
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar with ring
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFDF2F4),
                          border: Border.all(
                            color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.medical_services_rounded,
                            size: 30,
                            color: const Color(0xFFE91E63).withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              volunteer.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1A1A2E),
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${volunteer.age} · ${volunteer.gender}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded,
                                    size: 12, color: Colors.grey[400]),
                                const SizedBox(width: 4),
                                Text(
                                  volunteer.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Blood Group Badge
                      BloodGroupBadge(group: volunteer.bloodGroup),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ),
        );
      },
    );
  }
}
