import 'package:flutter/material.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class AppGradientBar extends StatelessWidget {
  const AppGradientBar({super.key, this.height = AppSizes.gradientBarHeight});
  final double height;

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandColors>()!;
    return Container(
      height: height,
      decoration: BoxDecoration(gradient: brand.brandGradient),
    );
  }
}
