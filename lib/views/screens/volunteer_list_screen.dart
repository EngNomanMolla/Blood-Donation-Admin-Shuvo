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
                    _buildSectionTitle('Verified Volunteers'),
                    const SizedBox(height: 12),
                    Obx(() => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.volunteers.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return VolunteerItemCard(
                                volunteer: controller.volunteers[index]);
                          },
                        )),
                    const SizedBox(height: 24),
                    _buildVolunteerRequestSection(),
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
                  'Volunteer List',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(() => Text(
                      '${controller.volunteers.length} active volunteers',
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
              Icons.medical_services_rounded,
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
            hintText: 'Search by name, blood group...',
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
              const SizedBox(width: 8),
              FilterDropdown(
                hint: 'Thana',
                value: controller.selectedThana.value,
                items: controller.thanas,
                onChanged: controller.selectThana,
              ),
            ],
          )),
    );
  }

  // ── Section Title ──────────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title, {int? newCount}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.5,
            ),
          ),
        ),
        if (newCount != null && newCount > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '($newCount New)',
              style: const TextStyle(
                color: Color(0xFFE91E63),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── Volunteer Request Section ──────────────────────────────────────────────

  Widget _buildVolunteerRequestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => _buildSectionTitle('Active Requests',
            newCount: controller.newCount)),
        const SizedBox(height: 16),
        Obx(() => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.requests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return VolunteerRequestCard(
                  request: controller.requests[index],
                  onAccept: () => controller.accept(index),
                  onSuspend: () => controller.suspend(index),
                );
              },
            )),
      ],
    );
  }
}
