// To parse this JSON data, do
//
//     final dataModel = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

DataModel dataModelFromJson(String str) => DataModel.fromSnapshot(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  final String id;
  String amount;
  String currency;
  String from;
  String description;
  String reference;
  String external_reference;
  String externalUser;

  DataModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.from,
    required this.description,
    required this.reference,
    required this.external_reference,
    required this.externalUser,
  });


  static DataModel empty() => DataModel(id: '', amount: '',currency: '', from: '', description: '', reference: '', external_reference: '',externalUser: '',);


  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory DataModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return DataModel(
        id: document.id,
        amount: data["amount"],
        currency: data["currency"],
        from: data["from"],
        description: data["description"],
        reference: data["reference"],
        external_reference: data["external_reference"],
        externalUser: data["external_user"],
      );
    } else {
      return DataModel.empty();
    }
  }






  Map<String, dynamic> toJson() => {
    "amount": amount,
    "currency": currency,
    "from": from,
    "description": description,
    "reference": reference,
    "external_reference": external_reference,
    "external_user": externalUser,
  };
}
