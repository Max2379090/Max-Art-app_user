import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import 'widgets/orders_list.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// -- AppBar
      appBar: TAppBar(title: Text('My Orders'.tr, style: Theme.of(context).textTheme.headlineSmall), showBackArrow: true),
      body: const Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),

        /// -- Orders
        child: TOrderListItems(),
      ),
    );
  }
}