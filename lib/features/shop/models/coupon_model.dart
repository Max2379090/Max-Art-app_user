import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  final String id;
  final String code;
  final String discountType;
  final double discountValue;
  final DateTime startDate;
  final DateTime endDate;
  final int usageLimit;
  final double minOrderValue;
  final bool isActive;

  CouponModel({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    required this.usageLimit,
    required this.minOrderValue,
    required this.isActive,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json, String id) => CouponModel(
    id: json['id'] ?? '',
    code: json['code'] ?? '',
    discountType: json['discountType'] ?? 'fixed',
    discountValue: (json['discountValue'] ?? 0).toDouble(),
    startDate: (json['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    endDate: (json['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    usageLimit: json['usageLimit'] ?? 1,
    minOrderValue: (json['minOrderValue'] ?? 0).toDouble(),
    isActive: json['isActive'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'discountType': discountType,
    'discountValue': discountValue,
    'startDate': startDate,
    'endDate': endDate,
    'usageLimit': usageLimit,
    'minOrderValue': minOrderValue,
    'isActive': isActive,
  };
}
