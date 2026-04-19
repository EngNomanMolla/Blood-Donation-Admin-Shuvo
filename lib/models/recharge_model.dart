class RechargeModel {
  final String id;
  final String amount;
  final String date;
  final String time;
  final String method;
  final String status; // 'success', 'pending', 'failed'

  const RechargeModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.time,
    required this.method,
    required this.status,
  });
}
