import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donor_list_controller.dart';
import '../widgets/filter_dropdown.dart';
import '../widgets/user_card.dart';

class DonorListScreen extends GetView<DonorListController> {
  const DonorListScreen({super.key});

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
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildFilterRow(),
                    const SizedBox(height: 24),
                    _buildDonorListSection(),
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
                  'Donor List',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(() => Text(
                      '${controller.donors.length} active donors',
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
              color: const Color(0xFFE91E63).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Color(0xFFE91E63),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          onChanged: controller.onChangeSearch,
          decoration: InputDecoration(
            hintText: 'Search by name, phone, blood group...',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            border: InputBorder.none,
            isDense: true,
            icon: Icon(
              Icons.search,
              color: Colors.grey.shade500,
              size: 20,
            ),
          ),
        ),
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

  // ── Donor List Section ──────────────────────────────────────────────────────

  Widget _buildDonorListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Text(
                'All Donors',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controller.donors.length}',
                      style: const TextStyle(
                        color: Color(0xFFE91E63),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.donors.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return UserCard(
                  user: controller.donors[index],
                  onTap: () => Get.toNamed('/donor-details', arguments: controller.donors[index]),
                );
              },
            )),
      ],
    );
  }
}
