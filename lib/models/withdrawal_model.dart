class WithdrawalModel {
  final int id;
  final int userId;
  final String userName;
  final String? userPhone;
  final String? userEmail;
  final double amount;
  final String method;
  final String accountNumber;
  final String? note;
  String status;
  final String? adminNote;
  final String? reviewedAt;
  final String createdAt;

  WithdrawalModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhone,
    this.userEmail,
    required this.amount,
    required this.method,
    required this.accountNumber,
    this.note,
    required this.status,
    this.adminNote,
    this.reviewedAt,
    required this.createdAt,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    return WithdrawalModel(
      id: json['id'] as int,
      userId: json['user_id'] as int? ?? 0,
      userName: userJson?['name'] as String? ?? 'Unknown User',
      userPhone: userJson?['phone'] as String?,
      userEmail: userJson?['email'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      method: json['method'] as String? ?? '',
      accountNumber: json['account_number'] as String? ?? '',
      note: json['note'] as String?,
      status: json['status'] as String? ?? 'pending',
      adminNote: json['admin_note'] as String?,
      reviewedAt: json['reviewed_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
