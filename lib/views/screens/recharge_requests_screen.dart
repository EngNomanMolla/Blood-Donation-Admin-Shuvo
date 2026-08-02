import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/recharge_controller.dart';
import '../widgets/recharge_request_card.dart';

class RechargeRequestsScreen extends GetView<RechargeController> {
  const RechargeRequestsScreen({super.key});

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
                    _buildSummaryMetrics(),
                    const SizedBox(height: 24),
                    _buildListSection(),
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
                  'Recharge Requests',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(() => Text(
                      '${controller.pendingRecharges.value} requests require review',
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
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFF2E7D32),
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
      final total = controller.totalRecharges.value;
      final pending = controller.pendingRecharges.value;
      final success = controller.successfulRecharges.value;

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
              title: 'Successful',
              value: '$success',
              color: const Color(0xFFE8F5E9),
              textColor: const Color(0xFF2E7D32),
              icon: Icons.check_circle_outline_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildMetricCard(
              title: 'Total',
              value: '$total',
              color: const Color(0xFFFDF2F4),
              textColor: const Color(0xFFE91E63),
              icon: Icons.history_rounded,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: textColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: textColor.withValues(alpha: 0.7), size: 18),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  // ── Recharge Request List ──────────────────────────────────────────────────

  Widget _buildListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transactions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        _buildTabBar(),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoadingRecharges.value) {
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

          if (controller.rechargeList.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text(
                  'No recharge requests found',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.rechargeList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.rechargeList[index];
                  return RechargeRequestCard(
                    recharge: item,
                    onApprove: () => _showNoteDialog(context, item.id, true),
                    onReject: () => _showNoteDialog(context, item.id, false),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildPaginationControls(),
            ],
          );
        }),
      ],
    );
  }

  // ── Pagination Controls ────────────────────────────────────────────────────

  Widget _buildPaginationControls() {
    final current = controller.currentPage.value;
    final total = controller.totalPages.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Prev Button
        InkWell(
          onTap: current > 1 ? () => controller.fetchRecharges(current - 1) : null,
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
          onTap: current < total ? () => controller.fetchRecharges(current + 1) : null,
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
  }

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
                isSelected: currentFilter == 'Success',
                onTap: () => controller.setStatusFilter('Success'),
              ),
            ),
            Expanded(
              child: _buildTabItem(
                label: 'Rejected',
                isSelected: currentFilter == 'Failed',
                onTap: () => controller.setStatusFilter('Failed'),
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

  void _showNoteDialog(BuildContext context, int id, bool isApprove) {
    final noteController = TextEditingController(
      text: isApprove 
        ? 'Payment verified successfully.' 
        : 'Invalid transaction details.',
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
                isApprove ? 'Approve Recharge' : 'Reject Recharge',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isApprove 
                  ? 'Please add a note to confirm payment verification.' 
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
                        controller.approveRecharge(id, note);
                      } else {
                        controller.rejectRecharge(id, note);
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
