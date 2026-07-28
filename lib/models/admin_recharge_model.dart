class AdminRechargeModel {
  final int id;
  final int userId;
  final String userName;
  final String? userPhone;
  final String method;
  final String methodLabel;
  final double amount;
  final String currency;
  final String? transactionId;
  final String? senderNumber;
  final String? note;
  String status;
  String statusLabel;
  final String? rechargedAtLabel;
  final String createdAt;

  AdminRechargeModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhone,
    required this.method,
    required this.methodLabel,
    required this.amount,
    required this.currency,
    this.transactionId,
    this.senderNumber,
    this.note,
    required this.status,
    required this.statusLabel,
    this.rechargedAtLabel,
    required this.createdAt,
  }
  );

  factory AdminRechargeModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    return AdminRechargeModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      userName: userJson?['name'] as String? ?? 'Unknown User',
      userPhone: userJson?['phone'] as String?,
      method: json['method'] as String? ?? '',
      methodLabel: json['method_label'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'BDT',
      transactionId: json['transaction_id'] as String?,
      senderNumber: json['sender_number'] as String?,
      note: json['note'] as String?,
      status: json['status'] as String? ?? 'pending',
      statusLabel: json['status_label'] as String? ?? 'Pending',
      rechargedAtLabel: json['recharged_at_label'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
