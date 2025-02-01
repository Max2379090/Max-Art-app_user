import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class TShadowStyle {
  static final verticalProductShadow = BoxShadow(
      color: TColors.black.withOpacity(0.3),
      blurRadius: 10,
      spreadRadius: 1,
      offset: const Offset(0, 2)
  );
  static final horizontalProductShadow = BoxShadow(
      color: TColors.black.withOpacity(0.3),
      blurRadius: 10,
      spreadRadius: 1,
      offset: const Offset(0, 2)
  );
}

