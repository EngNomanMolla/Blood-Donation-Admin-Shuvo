class BannerModel {
  final int? id;
  final String? title;
  final String? image;
  final String? link;
  final int isActive; // 1 for active, 0 for inactive
  final int? order;
  final String? createdAt;
  final String? updatedAt;

  BannerModel({
    this.id,
    this.title,
    this.image,
    this.link,
    this.isActive = 1,
    this.order = 1,
    this.createdAt,
    this.updatedAt,
  });

  bool get active => isActive == 1;

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    int parsedIsActive = 1;
    if (json['is_active'] != null) {
      if (json['is_active'] is bool) {
        parsedIsActive = json['is_active'] == true ? 1 : 0;
      } else if (json['is_active'] is num) {
        parsedIsActive = (json['is_active'] as num).toInt();
      } else if (json['is_active'] is String) {
        parsedIsActive = int.tryParse(json['is_active']) ?? 1;
      }
    }

    int? parsedOrder;
    if (json['order'] != null) {
      if (json['order'] is num) {
        parsedOrder = (json['order'] as num).toInt();
      } else if (json['order'] is String) {
        parsedOrder = int.tryParse(json['order']);
      }
    }

    int? parsedId;
    if (json['id'] != null) {
      if (json['id'] is num) {
        parsedId = (json['id'] as num).toInt();
      } else if (json['id'] is String) {
        parsedId = int.tryParse(json['id']);
      }
    }

    return BannerModel(
      id: parsedId,
      title: json['title'] as String?,
      image: json['image'] as String? ?? json['image_url'] as String?,
      link: json['link'] as String?,
      isActive: parsedIsActive,
      order: parsedOrder ?? 1,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (image != null) 'image': image,
      if (link != null) 'link': link,
      'is_active': isActive,
      if (order != null) 'order': order,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  BannerModel copyWith({
    int? id,
    String? title,
    String? image,
    String? link,
    int? isActive,
    int? order,
    String? createdAt,
    String? updatedAt,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      link: link ?? this.link,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
