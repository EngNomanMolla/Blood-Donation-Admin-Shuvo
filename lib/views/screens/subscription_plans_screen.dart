import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/subscription_controller.dart';
import '../../models/admin_subscription_model.dart';
import '../widgets/subscription_plan_card.dart';

class SubscriptionPlansScreen extends GetView<SubscriptionController> {
  const SubscriptionPlansScreen({super.key});

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
                if (controller.isLoading.value && controller.plansList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE91E63),
                      strokeWidth: 3,
                    ),
                  );
                }

                if (controller.plansList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECEF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.card_membership_rounded,
                            color: Color(0xFFE91E63),
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Subscription Plans Yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tap the button below to create your first plan.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFFE91E63),
                  onRefresh: () => controller.fetchPlans(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: controller.plansList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return SubscriptionPlanCard(
                        plan: controller.plansList[index],
                        onEdit: () => _showEditPlanSheet(context, controller.plansList[index]),
                        onDelete: () => _showDeleteConfirmation(context, controller.plansList[index]),
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
        onPressed: () => _showCreatePlanSheet(context),
        backgroundColor: const Color(0xFFF59E0B),
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Create Plan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  // ── Header Widget ──────────────────────────────────────────────────────────

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
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
                  'Subscription Plans',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(() => Text(
                      '${controller.plansList.length} plans configured for users',
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
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.card_membership_rounded,
              color: Color(0xFFF59E0B),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Sheet Plan Form ──────────────────────────────────────────────────

  void _showCreatePlanSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final durationController = TextEditingController();
    final callMinutesController = TextEditingController();
    final isActive = true.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Subscription Plan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.4,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.cancel_rounded, color: Colors.grey[400]),
                    )
                  ],
                ),
                const SizedBox(height: 18),
                
                // Name Field
                _buildFormLabel('Plan Name'),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: _buildInputDecoration('e.g., Monthly Premium Plan'),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter plan name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Description Field
                _buildFormLabel('Description'),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  decoration: _buildInputDecoration('Detail of what users will unlock...'),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter plan description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Price, Duration, Calls Grid Fields
                Row(
                  children: [
                    // Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormLabel('Price (৳)'),
                          TextFormField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            decoration: _buildInputDecoration('20'),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Required';
                              }
                              if (double.tryParse(val) == null) {
                                return 'Invalid num';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Duration
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormLabel('Duration (Days)'),
                          TextFormField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            decoration: _buildInputDecoration('30'),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Required';
                              }
                              if (int.tryParse(val) == null) {
                                return 'Invalid days';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Call Minutes
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormLabel('App Calls (Mins)'),
                          TextFormField(
                            controller: callMinutesController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            decoration: _buildInputDecoration('20'),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Required';
                              }
                              if (int.tryParse(val) == null) {
                                return 'Invalid mins';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Active Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Is Active Plan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Active plans are immediately visible to users',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Obx(() => Switch.adaptive(
                          value: isActive.value,
                          onChanged: (val) => isActive.value = val,
                          activeThumbColor: const Color(0xFFF59E0B),
                          activeTrackColor: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                        )),
                  ],
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  final newPlan = AdminSubscriptionModel(
                                    name: nameController.text.trim(),
                                    description: descriptionController.text.trim(),
                                    price: double.parse(priceController.text),
                                    durationDays: int.parse(durationController.text),
                                    callMinutes: int.parse(callMinutesController.text),
                                    isActive: isActive.value,
                                  );
                                  
                                  final success = await controller.createPlan(newPlan);
                                  if (success && context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Create & Publish Plan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  void _showDeleteConfirmation(BuildContext context, AdminSubscriptionModel plan) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delete Plan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete the plan "${plan.name}"? This action cannot be undone.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
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
                      Get.back();
                      controller.deletePlan(plan.id!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
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

  void _showEditPlanSheet(BuildContext context, AdminSubscriptionModel plan) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: plan.name);
    final descriptionController = TextEditingController(text: plan.description);
    final priceController = TextEditingController(text: plan.price.toStringAsFixed(0));
    final durationController = TextEditingController(text: plan.durationDays.toString());
    final callMinutesController = TextEditingController(text: plan.callMinutes.toString());
    final isActive = plan.isActive.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Subscription Plan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.4,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.cancel_rounded, color: Colors.grey[400]),
                    )
                  ],
                ),
                const SizedBox(height: 18),
                
                // Name Field
                _buildFormLabel('Plan Name'),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: _buildInputDecoration('e.g., Monthly Basic Plan'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter plan name';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Description Field
                _buildFormLabel('Description'),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  decoration: _buildInputDecoration('Brief description of benefits...'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter description';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Pricing Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormLabel('Price (BDT)'),
                          TextFormField(
                            controller: priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            decoration: _buildInputDecoration('e.g., 20'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Enter price';
                              if (double.tryParse(value) == null) return 'Invalid number';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormLabel('Duration (Days)'),
                          TextFormField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            decoration: _buildInputDecoration('e.g., 30'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Enter days';
                              if (int.tryParse(value) == null) return 'Invalid number';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Call Minutes
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormLabel('Call Minutes'),
                          TextFormField(
                            controller: callMinutesController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            decoration: _buildInputDecoration('e.g., 20'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Enter minutes';
                              if (int.tryParse(value) == null) return 'Invalid number';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Active Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Is Active Plan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Active plans are immediately visible to users',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Obx(() => Switch.adaptive(
                          value: isActive.value,
                          onChanged: (val) => isActive.value = val,
                          activeThumbColor: const Color(0xFFF59E0B),
                          activeTrackColor: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                        )),
                  ],
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  final updatedPlan = AdminSubscriptionModel(
                                    id: plan.id,
                                    name: nameController.text.trim(),
                                    description: descriptionController.text.trim(),
                                    price: double.parse(priceController.text),
                                    durationDays: int.parse(durationController.text),
                                    callMinutes: int.parse(callMinutesController.text),
                                    isActive: isActive.value,
                                    currency: plan.currency ?? 'BDT',
                                    createdAt: plan.createdAt,
                                    updatedAt: plan.updatedAt,
                                  );
                                  
                                  final success = await controller.updatePlan(plan.id!, updatedPlan);
                                  if (success && context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save & Publish Changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.normal),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFF59E0B),
          width: 1.5,
        ),
      ),
      errorStyle: const TextStyle(height: 0.8, fontSize: 10),
    );
  }
}
