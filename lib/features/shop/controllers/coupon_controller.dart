import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/coupon_model.dart';

class CouponController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List of coupons fetched from Firestore
  var coupons = <CouponModel>[].obs;
  var isLoading = true.obs; // Loading state to show loading indicator
  var errorMessage = ''.obs; // For error handling

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  // Fetch coupons from Firestore
  void fetchCoupons() async {
    try {
      isLoading(true); // Set loading state to true
      final snapshot = await _firestore.collection('coupons').get();
      // Convert Firestore documents to CouponModel
      coupons.assignAll(snapshot.docs
          .map((doc) => CouponModel.fromJson(doc.data(), doc.id))
          .toList());
      errorMessage(''); // Clear any previous errors
    } catch (e) {
      errorMessage('Error fetching coupons: $e'); // Update error message
      print('Error fetching coupons: $e');
    } finally {
      isLoading(false); // Set loading state to false once done
    }
  }

  // Method to apply the coupon by code
  void applyCoupon(String couponCode) {
    final coupon = coupons.firstWhere(
            (coupon) => coupon.code == couponCode,
        orElse: () => CouponModel(code: '', id: '', discountType: '', discountValue: 0, startDate: DateTime.fromMillisecondsSinceEpoch(1675123200000), endDate: DateTime.fromMillisecondsSinceEpoch(1675123200000), usageLimit: 0, minOrderValue: 0, isActive: true));

    if (coupon.code.isNotEmpty) {
      // Logic to apply coupon, e.g., update the cart total or notify the user
      print('Coupon Applied: $couponCode');
      // Add more functionality here (e.g., updating the total price)
    } else {
      print('Invalid coupon code');
      Get.snackbar('Error', 'Invalid coupon code', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Add a new coupon to Firestore
  Future<void> addCoupon(CouponModel coupon) async {
    try {
      await _firestore.collection('coupons').add(coupon.toJson());
      fetchCoupons(); // Refresh the list after adding the coupon
    } catch (e) {
      errorMessage('Error adding coupon: $e'); // Update error message
      print('Error adding coupon: $e');
    }
  }
}
