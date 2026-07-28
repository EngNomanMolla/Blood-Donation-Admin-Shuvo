class AdminSubscriptionModel {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final String? currency;
  final int durationDays;
  final int callMinutes;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  AdminSubscriptionModel({
    this.id,
    required this.name,
    this.description,
    required this.price,
    this.currency,
    required this.durationDays,
    required this.callMinutes,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminSubscriptionModel.fromJson(Map<String, dynamic> json) {
    // Robust parsing for price (can be double, int, or String representation)
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      parsedPrice = double.tryParse(json['price'].toString()) ?? 0.0;
    }

    // Robust parsing for durationDays
    int parsedDuration = 0;
    if (json['duration_days'] != null) {
      parsedDuration = int.tryParse(json['duration_days'].toString()) ?? 0;
    }

    // Robust parsing for callMinutes
    int parsedMinutes = 0;
    if (json['call_minutes'] != null) {
      parsedMinutes = int.tryParse(json['call_minutes'].toString()) ?? 0;
    }

    // Robust parsing for isActive (supports bool, int (0/1), or String)
    bool parsedActive = false;
    if (json['is_active'] != null) {
      final activeVal = json['is_active'];
      if (activeVal is bool) {
        parsedActive = activeVal;
      } else if (activeVal is int) {
        parsedActive = activeVal == 1;
      } else {
        parsedActive = activeVal.toString().toLowerCase() == 'true' || activeVal.toString() == '1';
      }
    }

    return AdminSubscriptionModel(
      id: json['id'] as int?,
      name: (json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      price: parsedPrice,
      currency: json['currency']?.toString(),
      durationDays: parsedDuration,
      callMinutes: parsedMinutes,
      isActive: parsedActive,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      if (currency != null) 'currency': currency,
      'duration_days': durationDays,
      'call_minutes': callMinutes,
      'is_active': isActive,
    };
  }
}
