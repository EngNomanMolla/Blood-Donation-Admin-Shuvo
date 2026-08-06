import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/volunteer_list_controller.dart';
import '../../models/volunteer_model.dart';
import '../widgets/volunteer_item_card.dart';
import '../widgets/volunteer_request_card.dart';

class VolunteerListScreen extends GetView<VolunteerListController> {
  const VolunteerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFFE91E63),
                onRefresh: () => controller.fetchVolunteerRequests(1),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildTabBar(),
                      const SizedBox(height: 16),
                      _buildListSection(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

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
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1A1A2E),
                size: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Volunteer Panel',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Manage volunteer applications and profiles',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ────────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Obx(() {
      final currentFilter = controller.selectedStatusFilter.value;
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTabItem(
                label: 'Volunteers',
                isSelected: currentFilter == 'Volunteers',
                onTap: () => controller.setStatusFilter('Volunteers'),
              ),
            ),
            Expanded(
              child: _buildTabItem(
                label: 'Requests',
                isSelected: currentFilter == 'Requests',
                onTap: () => controller.setStatusFilter('Requests'),
              ),
            ),
            Expanded(
              child: _buildTabItem(
                label: 'Rejected',
                isSelected: currentFilter == 'Rejected',
                onTap: () => controller.setStatusFilter('Rejected'),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE91E63) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── List Section ───────────────────────────────────────────────────────────

  Widget _buildListSection() {
    return Obx(() {
      if (controller.isLoadingRequests.value) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFE91E63),
              strokeWidth: 3,
            ),
          ),
        );
      }

      if (controller.requests.isEmpty) {
        final currentFilter = controller.selectedStatusFilter.value;
        String emptyMessage = 'No verified volunteers found';
        if (currentFilter == 'Requests') {
          emptyMessage = 'No pending requests found';
        } else if (currentFilter == 'Rejected') {
          emptyMessage = 'No rejected requests found';
        }
        return _buildEmptyState(emptyMessage);
      }

      final currentFilter = controller.selectedStatusFilter.value;

      return Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.requests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.requests[index];
              if (currentFilter == 'Volunteers') {
                return VolunteerItemCard(
                  volunteer: VolunteerModel(
                    name: item.userName ?? 'Unknown User',
                    age: item.userAge != null ? '${item.userAge} Years' : 'Age N/A',
                    gender: item.userGender ?? 'Unknown',
                    location: item.userLocation ?? 'Bangladesh',
                    bloodGroup: item.userBloodGroup ?? 'N/A',
                    isActive: true,
                  ),
                );
              } else {
                return VolunteerRequestCard(
                  request: item,
                  onAccept: () => controller.accept(item.id),
                  onSuspend: () => controller.suspend(item.id),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          _buildPaginationControls(),
        ],
      );
    });
  }

  // ── Empty State ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(String message) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_alt_rounded,
              color: Colors.grey.shade300,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Pagination Controls ────────────────────────────────────────────────────

  Widget _buildPaginationControls() {
    return Obx(() {
      final current = controller.currentPage.value;
      final total = controller.totalPages.value;

      if (total <= 1) return const SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Prev Button
          InkWell(
            onTap: current > 1 ? () => controller.fetchVolunteerRequests(current - 1) : null,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: current > 1 ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: current > 1 ? Colors.grey.shade300 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_left_rounded,
                    color: current > 1 ? const Color(0xFF1A1A2E) : Colors.grey.shade400,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Prev',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: current > 1 ? const Color(0xFF1A1A2E) : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Page Indicator
          Text(
            'Page $current of $total',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          // Next Button
          InkWell(
            onTap: current < total ? () => controller.fetchVolunteerRequests(current + 1) : null,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: current < total ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: current < total ? Colors.grey.shade300 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: current < total ? const Color(0xFF1A1A2E) : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: current < total ? const Color(0xFF1A1A2E) : Colors.grey.shade400,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
