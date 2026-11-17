class ComplaintUser {
  final int id;
  final String? name;
  final String? phone;
  final String? email;

  ComplaintUser({
    required this.id,
    this.name,
    this.phone,
    this.email,
  });

  factory ComplaintUser.fromJson(Map<String, dynamic> json) {
    return ComplaintUser(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}

class ComplaintReviewer {
  final int id;
  final String? name;

  ComplaintReviewer({
    required this.id,
    this.name,
  });

  factory ComplaintReviewer.fromJson(Map<String, dynamic> json) {
    return ComplaintReviewer(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ComplaintModel {
  final int id;
  final int? userId;
  final ComplaintUser? user;
  final String? name;
  final String? phone;
  final String? address;
  final String message;
  String status;
  String statusLabel;
  String? adminNote;
  int? reviewedBy;
  ComplaintReviewer? reviewer;
  String? reviewedAt;
  final String createdAt;
  final String updatedAt;

  ComplaintModel({
    required this.id,
    this.userId,
    this.user,
    this.name,
    this.phone,
    this.address,
    required this.message,
    required this.status,
    required this.statusLabel,
    this.adminNote,
    this.reviewedBy,
    this.reviewer,
    this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayName {
    if (name != null && name!.trim().isNotEmpty) return name!.trim();
    if (user?.name != null && user!.name!.trim().isNotEmpty) return user!.name!.trim();
    return 'User #$id';
  }

  String get displayPhone {
    if (phone != null && phone!.trim().isNotEmpty) return phone!.trim();
    if (user?.phone != null && user!.phone!.trim().isNotEmpty) return user!.phone!.trim();
    return 'N/A';
  }

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int?,
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? ComplaintUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      statusLabel: json['status_label'] as String? ?? 'Pending',
      adminNote: json['admin_note'] as String?,
      reviewedBy: json['reviewed_by'] as int?,
      reviewer: json['reviewer'] != null && json['reviewer'] is Map<String, dynamic>
          ? ComplaintReviewer.fromJson(json['reviewer'] as Map<String, dynamic>)
          : null,
      reviewedAt: json['reviewed_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user': user?.toJson(),
      'name': name,
      'phone': phone,
      'address': address,
      'message': message,
      'status': status,
      'status_label': statusLabel,
      'admin_note': adminNote,
      'reviewed_by': reviewedBy,
      'reviewer': reviewer?.toJson(),
      'reviewed_at': reviewedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ComplaintSummary {
  final int totalComplaints;
  final int pendingComplaints;
  final int inProgressComplaints;
  final int resolvedComplaints;
  final int rejectedComplaints;

  ComplaintSummary({
    this.totalComplaints = 0,
    this.pendingComplaints = 0,
    this.inProgressComplaints = 0,
    this.resolvedComplaints = 0,
    this.rejectedComplaints = 0,
  });

  factory ComplaintSummary.fromJson(Map<String, dynamic> json) {
    return ComplaintSummary(
      totalComplaints: json['total_complaints'] as int? ?? 0,
      pendingComplaints: json['pending_complaints'] as int? ?? 0,
      inProgressComplaints: json['in_progress_complaints'] as int? ?? 0,
      resolvedComplaints: json['resolved_complaints'] as int? ?? 0,
      rejectedComplaints: json['rejected_complaints'] as int? ?? 0,
    );
  }
}

