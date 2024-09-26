import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionModel {
  final String userId;
  final String conversionData;
  final DateTime conversionDate;
  final String imageUrl;

  ConversionModel({
    required this.userId,
    required this.conversionData,
    required this.conversionDate,
    required this.imageUrl,
  });

  factory ConversionModel.fromJson(Map<String, dynamic> json) {
    return ConversionModel(
        userId: json["userid"],
        conversionData: json["conversionData"],
        conversionDate: (json["conversionDate"] as Timestamp).toDate(),
        imageUrl: json["imgeUrl"]);
  }

  Map<String, dynamic> toJson(){
    return {
      "userId":userId,
      "conversionData": conversionData,
      "conversionDate": conversionDate,
      "imgeUrl":imageUrl,    

    };
  }
}
