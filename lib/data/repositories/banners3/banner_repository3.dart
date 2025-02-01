import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

import '../../../features/shop/models/banner_model3.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../services/cloud_storage/firebase_storage_service.dart';

class BannerRepository3 extends GetxController {
  static BannerRepository3 get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  /* ---------------------------- FUNCTIONS ---------------------------------*/

  /// Get all order related to current User
  Future<List<BannerModel3>> fetchBanners() async {
    try {
      final result = await _db.collection('Banners3').where('active', isEqualTo: true).limit(3).get();
      return result.docs.map((documentSnapshot) => BannerModel3.fromSnapshot(documentSnapshot)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching Banners.';
    }
  }


  /// Upload Banners to the Cloud Firebase
  Future<void> uploadBannersDummyData(List<BannerModel3> banners3) async {
    try {
      // Upload all the Categories along with their Images
      final storage = Get.put(TFirebaseStorageService());
      // Loop through each category
      for (var entry in banners3) {
        // Get ImageData link from the local assets
        final thumbnail = await storage.getImageDataFromAssets(entry.imageUrl);

        // Upload Image and Get its URL
        final url = await storage.uploadImageData('Banners3', thumbnail, path.basename(entry.imageUrl), MediaCategory.banners3.name);

        // Assign URL to Brand.image attribute
        entry.imageUrl = url;

        // Store Category in Firestore
        await _db.collection("Banners3").doc().set(entry.toJson());
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
}
