import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionModel {
  final String? userId;
  final String? conversionData;
  final DateTime? conversionDate;
  final String? imageUrl;

  ConversionModel({
    this.userId,
    this.conversionData,
    this.conversionDate,
    this.imageUrl,
  });

  factory ConversionModel.fromJson(Map<String, dynamic> json) {
    return ConversionModel(
      userId: json["userId"] as String?,
      conversionData: json["conversionData"] as String?,
      conversionDate: (json["conversionDate"] as Timestamp?)?.toDate(),
      imageUrl: json["imageUrl"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId ?? "",
      "conversionData": conversionData ?? "",
      "conversionDate": conversionDate ?? DateTime.now(),
      "imageUrl": imageUrl ?? "",
    };
  }
}
