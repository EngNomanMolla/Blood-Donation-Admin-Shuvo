import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/withdrawal_controller.dart';
import '../widgets/withdrawal_request_card.dart';

class WithdrawalListScreen extends GetView<WithdrawalController> {
  const WithdrawalListScreen({super.key});

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
                onRefresh: () => controller.fetchWithdrawals(1),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildSummaryMetrics(),
                      const SizedBox(height: 24),
                      _buildTabBar(),
                      const SizedBox(height: 20),
                      _buildListSection(context),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Withdrawal Panel',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(() => Text(
                      '${controller.pendingWithdrawals.value} requests pending approval',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.payments_rounded,
              color: Color(0xFF8B5CF6),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary Cards ─────────────────────────────────────────────────────────

  Widget _buildSummaryMetrics() {
    return Obx(() {
      final total = controller.totalWithdrawals.value;
      final pending = controller.pendingWithdrawals.value;
      final approved = controller.approvedWithdrawals.value;

      return Row(
        children: [
          Expanded(
            child: _buildMetricCard(
              title: 'Pending',
              value: '$pending',
              color: const Color(0xFFFFF8E1),
              textColor: const Color(0xFFE65100),
              icon: Icons.hourglass_empty_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildMetricCard(
              title: 'Approved',
              value: '$approved',
              color: const Color(0xFFE8F5E9),
              textColor: const Color(0xFF2E7D32),
              icon: Icons.check_circle_outline_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildMetricCard(
              title: 'Total Requests',
              value: '$total',
              color: const Color(0xFFECEFF1),
              textColor: const Color(0xFF37474F),
              icon: Icons.payments_rounded,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required Color color,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor.withValues(alpha: 0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
                label: 'Pending',
                isSelected: currentFilter == 'Pending',
                onTap: () => controller.setStatusFilter('Pending'),
              ),
            ),
            Expanded(
              child: _buildTabItem(
                label: 'Approved',
                isSelected: currentFilter == 'Approved',
                onTap: () => controller.setStatusFilter('Approved'),
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

  Widget _buildListSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingWithdrawals.value && controller.withdrawalList.isEmpty) {
        return const SizedBox(
          height: 250,
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFE91E63),
              strokeWidth: 3,
            ),
          ),
        );
      }

      if (controller.withdrawalList.isEmpty) {
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
                  Icons.payments_outlined,
                  color: Colors.grey.shade300,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'No withdrawals found for ${controller.selectedStatusFilter.value}',
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

      return Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.withdrawalList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.withdrawalList[index];
              return WithdrawalRequestCard(
                withdrawal: item,
                onApprove: () => _showNoteDialog(context, item.id, true),
                onReject: () => _showNoteDialog(context, item.id, false),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildPaginationControls(),
        ],
      );
    });
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
            onTap: current > 1 ? () => controller.fetchWithdrawals(current - 1) : null,
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
            onTap: current < total ? () => controller.fetchWithdrawals(current + 1) : null,
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

  void _showNoteDialog(BuildContext context, int id, bool isApprove) {
    final noteController = TextEditingController(
      text: isApprove 
        ? 'Withdrawal request approved and processed.' 
        : 'Invalid request or incorrect account details.',
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isApprove ? 'Approve Withdrawal' : 'Reject Withdrawal',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isApprove 
                  ? 'Confirm that this withdrawal has been processed.' 
                  : 'Specify the reason for rejection.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                maxLines: 3,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Enter admin note...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isApprove ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      final note = noteController.text.trim();
                      Get.back();
                      if (isApprove) {
                        controller.approveWithdrawal(id, note);
                      } else {
                        controller.rejectWithdrawal(id, note);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isApprove ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text(
                      isApprove ? 'Confirm' : 'Reject',
                      style: const TextStyle(
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
