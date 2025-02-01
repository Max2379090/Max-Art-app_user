import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel3 {
  String imageUrl;
  final String targetScreen;
  final bool active;

  BannerModel3({required this.imageUrl, required this.targetScreen, required this.active});

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'targetScreen': targetScreen,
      'active': active,
    };
  }

  factory BannerModel3.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BannerModel3(
      imageUrl: data['imageUrl'] ?? '',
      targetScreen: data['targetScreen'] ?? '',
      active: data['active'] ?? false,
    );
  }
}