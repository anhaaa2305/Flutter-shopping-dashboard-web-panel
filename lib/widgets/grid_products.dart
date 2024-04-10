import 'package:flutter/material.dart';
import 'package:shopping_dashboard_screen/widgets/products_widget.dart';

import '../consts/constants.dart';
import '../services/utils.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key,this.crossAxisCount = 4,this.childAspectRatio = 1,this.isInMain = true});
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return GridView.builder(
      itemCount: isInMain ? 4 : 20,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding),
      itemBuilder: (context, index) {
        return const ProductWidget();
      },
    );
  }
}
