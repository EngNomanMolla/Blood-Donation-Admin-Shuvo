import 'package:flutter/material.dart';
 
class FilterDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final bool isDisabled;
 
  const FilterDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isDisabled = false,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDisabled
            ? Colors.grey.shade200
            : (value != null 
                ? const Color(0xFFE91E63).withValues(alpha: 0.3) 
                : Colors.grey.shade200)
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: isDisabled ? null : value,
          hint: Row(
            children: [
              Text(
                hint,
                style: TextStyle(
                  fontSize: 13,
                  color: isDisabled ? Colors.grey.shade400 : const Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: isDisabled ? Colors.grey.shade400 : const Color(0xFFE91E63)),
          style: TextStyle(
            fontSize: 13,
            color: isDisabled ? Colors.grey.shade400 : const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w500,
          ),
          isDense: true,
          items: isDisabled
              ? null
              : items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: isDisabled ? null : onChanged,
        ),
      ),
    );
  }
}
