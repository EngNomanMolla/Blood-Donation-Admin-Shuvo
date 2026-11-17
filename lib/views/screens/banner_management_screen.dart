import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/banner_controller.dart';
import '../../models/banner_model.dart';
import '../widgets/banner_card.dart';

class BannerManagementScreen extends GetView<BannerController> {
  const BannerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.bannersList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0891B2),
                      strokeWidth: 3,
                    ),
                  );
                }

                if (controller.bannersList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.view_carousel_rounded,
                            color: Color(0xFF0284C7),
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Banners Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Create and manage promotional banners for users.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => _showBannerSheet(context),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Add First Banner'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0891B2),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFF0891B2),
                  onRefresh: () => controller.fetchBanners(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: controller.bannersList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final banner = controller.bannersList[index];
                      return BannerCard(
                        banner: banner,
                        onEdit: () => _showBannerSheet(context, banner: banner),
                        onDelete: () => _showDeleteConfirmation(context, banner),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBannerSheet(context),
        backgroundColor: const Color(0xFF0891B2),
        elevation: 4,
        icon: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        label: const Text(
          'Add Banner',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ── Top Header ─────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF1A1A2E),
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Banner Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Manage home screen promotions',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => controller.fetchBanners(),
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0891B2)),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  // ── Create / Edit Banner BottomSheet ────────────────────────────────────────

  void _showBannerSheet(BuildContext context, {BannerModel? banner}) {
    final isEditing = banner != null;
    final titleController = TextEditingController(text: banner?.title ?? '');
    final linkController = TextEditingController(text: banner?.link ?? '');
    final orderController = TextEditingController(text: (banner?.order ?? 1).toString());
    final isActiveRx = (banner?.isActive ?? 1).obs;

    controller.clearSelectedImage();

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Drag Handle
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sheet Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Banner' : 'Create New Banner',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Form Inputs
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Selector Area
                    _buildSectionLabel('Banner Image *'),
                    const SizedBox(height: 8),
                    _buildImagePickerBox(banner?.image),
                    const SizedBox(height: 20),

                    // Title Field
                    _buildSectionLabel('Banner Title *'),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: titleController,
                      hint: 'e.g. Summer Campaign',
                      icon: Icons.title_rounded,
                    ),
                    const SizedBox(height: 16),

                    // Link Field
                    _buildSectionLabel('Action Link (Optional)'),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: linkController,
                      hint: 'e.g. https://example.com',
                      icon: Icons.link_rounded,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),

                    // Order Field & Active Toggle
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel('Display Order'),
                              const SizedBox(height: 8),
                              _buildInputField(
                                controller: orderController,
                                hint: '1',
                                icon: Icons.format_list_numbered_rounded,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel('Status'),
                              const SizedBox(height: 8),
                              Obx(() => Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F9FA),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isActiveRx.value == 1 ? 'Active' : 'Inactive',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: isActiveRx.value == 1
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFF94A3B8),
                                          ),
                                        ),
                                        Switch(
                                          value: isActiveRx.value == 1,
                                          activeTrackColor: const Color(0xFF10B981),
                                          onChanged: (val) {
                                            isActiveRx.value = val ? 1 : 0;
                                          },
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Submit Button
                    Obx(() => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: controller.isSubmitting.value
                                ? null
                                : () async {
                                    final title = titleController.text.trim();
                                    final link = linkController.text.trim();
                                    final order = int.tryParse(orderController.text.trim()) ?? 1;
                                    final isActive = isActiveRx.value;

                                    if (title.isEmpty) {
                                      Get.snackbar(
                                        'Validation',
                                        'Please enter a banner title',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.orange.withValues(alpha: 0.1),
                                        colorText: Colors.orange.shade800,
                                      );
                                      return;
                                    }

                                    if (!isEditing && controller.selectedImage.value == null) {
                                      Get.snackbar(
                                        'Validation',
                                        'Please select a banner image file',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.orange.withValues(alpha: 0.1),
                                        colorText: Colors.orange.shade800,
                                      );
                                      return;
                                    }

                                    bool success = false;
                                    if (isEditing) {
                                      success = await controller.updateBanner(
                                        banner.id!,
                                        title: title,
                                        newImageFile: controller.selectedImage.value,
                                        link: link.isNotEmpty ? link : null,
                                        isActive: isActive,
                                        order: order,
                                      );
                                    } else {
                                      success = await controller.createBanner(
                                        title: title,
                                        imageFile: controller.selectedImage.value!,
                                        link: link.isNotEmpty ? link : null,
                                        isActive: isActive,
                                        order: order,
                                      );
                                    }

                                    if (success) {
                                      Get.back();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0891B2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: controller.isSubmitting.value
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isEditing ? 'Save Changes' : 'Create Banner',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ── Image Picker Box ───────────────────────────────────────────────────────

  Widget _buildImagePickerBox(String? existingImageUrl) {
    return Obx(() {
      final selected = controller.selectedImage.value;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected != null
                ? const Color(0xFF0891B2)
                : Colors.grey.shade300,
            width: selected != null ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            if (selected != null) ...[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 16 / 7,
                  child: FutureBuilder<Uint8List>(
                    future: selected.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ] else if (existingImageUrl != null && existingImageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 16 / 7,
                  child: Image.network(
                    existingImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image_rounded, size: 36)),
                  ),
                ),
              ),
            ],

            // Action Buttons to pick
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_rounded, size: 16),
                      label: Text(
                        selected != null || existingImageUrl != null
                            ? 'Change Image'
                            : 'Pick from Gallery',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0891B2),
                        side: const BorderSide(color: Color(0xFF0891B2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => controller.pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_rounded, color: Color(0xFF0891B2)),
                    tooltip: 'Take Photo',
                  ),
                  if (selected != null) ...[
                    IconButton(
                      onPressed: () => controller.clearSelectedImage(),
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                      tooltip: 'Remove Selected',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Form Helpers ───────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: const Color(0xFF0891B2), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // ── Delete Confirmation ────────────────────────────────────────────────────

  void _showDeleteConfirmation(BuildContext context, BannerModel banner) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_rounded, color: Color(0xFFEF4444), size: 28),
              ),
              const SizedBox(height: 14),
              const Text(
                'Delete Banner',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete "${banner.title ?? 'this banner'}"? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        if (banner.id != null) {
                          await controller.deleteBanner(banner.id!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
