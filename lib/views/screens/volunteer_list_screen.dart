import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/volunteer_list_controller.dart';
import '../widgets/filter_dropdown.dart';
import '../widgets/volunteer_item_card.dart';
import '../widgets/volunteer_request_card.dart';

class VolunteerListScreen extends GetView<VolunteerListController> {
  const VolunteerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildFilterRow(),
              ),
              const SizedBox(height: 16),
              _buildTabBar(),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildVolunteersTab(),
                    _buildRequestsTab(),
                    _buildRejectedTab(),
                  ],
                ),
              ),
            ],
          ),
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
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF1A1A2E), size: 14),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Volunteer Panel',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(() => Text(
                      '${controller.volunteers.length} active volunteers · ${controller.newCount} pending requests',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter Row ─────────────────────────────────────────────────────────────

  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Obx(() => Row(
            children: [
              FilterDropdown(
                hint: 'Division',
                value: controller.selectedDivision.value,
                items: controller.divisions,
                onChanged: controller.selectDivision,
              ),
              const SizedBox(width: 8),
              FilterDropdown(
                hint: 'District',
                value: controller.selectedDistrict.value,
                items: controller.districts,
                onChanged: controller.selectDistrict,
              ),
              const SizedBox(width: 8),
              FilterDropdown(
                hint: 'Upazila',
                value: controller.selectedUpazila.value,
                items: controller.upazilas,
                onChanged: controller.selectUpazila,
              ),
            ],
          )),
    );
  }

  // ── Tab Bar ────────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        labelColor: const Color(0xFFE91E63),
        unselectedLabelColor: Colors.grey.shade500,
        indicatorColor: Colors.transparent,
        indicator: const UnderlineTabIndicator(borderSide: BorderSide.none),
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: 'Volunteers'),
          Tab(text: 'Requests'),
          Tab(text: 'Rejected'),
        ],
      ),
    );
  }

  // ── Tab 1: Volunteers ──────────────────────────────────────────────────────

  Widget _buildVolunteersTab() {
    return Obx(() {
      if (controller.isLoadingRequests.value && controller.volunteers.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE91E63),
            strokeWidth: 3,
          ),
        );
      }
      if (controller.volunteers.isEmpty) {
        return _buildEmptyState('No verified volunteers found');
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: controller.volunteers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return VolunteerItemCard(volunteer: controller.volunteers[index]);
        },
      );
    });
  }

  // ── Tab 2: Requests ────────────────────────────────────────────────────────

  Widget _buildRequestsTab() {
    return Obx(() {
      if (controller.isLoadingRequests.value && controller.pendingRequests.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE91E63),
            strokeWidth: 3,
          ),
        );
      }
      if (controller.pendingRequests.isEmpty) {
        return _buildEmptyState('No pending requests found');
      }

      return Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.pendingRequests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = controller.pendingRequests[index];
                return VolunteerRequestCard(
                  request: item,
                  onAccept: () => controller.accept(item.id),
                  onSuspend: () => controller.suspend(item.id),
                );
              },
            ),
          ),
          _buildPaginationControls(),
          const SizedBox(height: 16),
        ],
      );
    });
  }

  // ── Tab 3: Rejected ────────────────────────────────────────────────────────

  Widget _buildRejectedTab() {
    return Obx(() {
      if (controller.isLoadingRequests.value && controller.suspendedRequests.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE91E63),
            strokeWidth: 3,
          ),
        );
      }
      if (controller.suspendedRequests.isEmpty) {
        return _buildEmptyState('No rejected requests found');
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: controller.suspendedRequests.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = controller.suspendedRequests[index];
          return VolunteerRequestCard(
            request: item,
            onAccept: () => controller.accept(item.id),
            onSuspend: () => controller.suspend(item.id),
          );
        },
      );
    });
  }

  // ── Empty State ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(String message) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
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

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
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
        ),
      );
    });
  }
}
