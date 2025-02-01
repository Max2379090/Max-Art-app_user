import 'package:get/get.dart';

import '../../../../data/repositories/banners2/banner_repository2.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/banner_model2.dart';

class BannerController2 extends GetxController {
  final bannersLoading = false.obs;
  final carousalCurrentIndex = 0.obs;
  final RxList<BannerModel2> banners2 = <BannerModel2>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  /// Fetch banners from Firestore and update the 'banners' list
  Future<void> fetchBanners() async {
    try {
      // Start Loading
      bannersLoading.value = true;

      // Fetch Banners
      final bannerRepo = Get.put(BannerRepository2());
      final banners2 = await bannerRepo.fetchBanners();

      // Assign banners
      this.banners2.assignAll(banners2);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!'.tr, message: e.toString());
    } finally {
      bannersLoading.value = false;
    }
  }
}
