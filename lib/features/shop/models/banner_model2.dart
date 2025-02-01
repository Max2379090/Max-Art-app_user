import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel2 {
  String imageUrl;
  final String targetScreen;
  final bool active;

  BannerModel2({required this.imageUrl, required this.targetScreen, required this.active});

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'targetScreen': targetScreen,
      'active': active,
    };
  }

  factory BannerModel2.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BannerModel2(
      imageUrl: data['imageUrl'] ?? '',
      targetScreen: data['targetScreen'] ?? '',
      active: data['active'] ?? false,
    );
  }
}