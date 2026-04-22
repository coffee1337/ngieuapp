class AppGradientBar extends StatelessWidget {
  const AppGradientBar({super.key, this.height = 4});
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