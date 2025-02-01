import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coupon_uikit/coupon_uikit.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/coupon_controller.dart';
import '../../models/coupon_model.dart'; // Import coupon_uikit
 // Assuming you have a CouponModel for the coupon data

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CouponController controller = Get.put(CouponController());
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: isDark ?TColors.light : TColors.black,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:  Text('Available Coupons'.tr, style: TextStyle(color: isDark ? TColors.light : TColors.black,),),
        centerTitle: true,
        backgroundColor: isDark ? TColors.black : TColors.light,
      ),
      body: Obx(
            () {
          if (controller.coupons.isEmpty) {
            return Center(child: Text('No coupons available'.tr));
          }

          return ListView.builder(
            itemCount: controller.coupons.length,
            itemBuilder: (context, index) {
              CouponModel coupon = controller.coupons[index];

              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: CouponCard(
                    height: 170,
                    width: double.infinity,
                    curveAxis: Axis.vertical,
                    borderRadius: 20,
                    backgroundColor: Colors.white,
                    curvePosition: 150,
                    curveRadius: 10,
                    shadow: const Shadow(
                      color: Colors.black26,
                      offset: Offset(4, 6),
                      blurRadius: 8,
                    ),
                    firstChild: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          coupon.code,
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    secondChild: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.local_offer, color: Colors.blueAccent),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${coupon.discountValue}${coupon.discountType == 'percentage' ? '%' : ' off'}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Row for isActive
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: coupon.isActive ? Colors.green[50] : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  coupon.isActive ? Icons.check_circle : Icons.cancel,
                                  color: coupon.isActive ? Colors.greenAccent : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                coupon.isActive ? 'Active' : 'Inactive', // Display 'Active' or 'Inactive'
                                style: TextStyle(
                                  fontSize: 16,
                                  color: coupon.isActive ? Colors.greenAccent : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.access_time, color: Colors.redAccent),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Expires on: ${coupon.endDate.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  )
              );
            },
          );
        },
      ),
    );
  }
}
