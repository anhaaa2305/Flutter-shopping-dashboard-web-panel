import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_dashboard_screen/inner_screens/add_product.dart';
import 'package:shopping_dashboard_screen/responsive.dart';
import 'package:shopping_dashboard_screen/services/global_method.dart';
import 'package:shopping_dashboard_screen/services/utils.dart';
import 'package:shopping_dashboard_screen/widgets/buttons.dart';
import 'package:shopping_dashboard_screen/widgets/grid_products.dart';
import 'package:shopping_dashboard_screen/widgets/text_widget.dart';
import '../consts/constants.dart';
import '../controllers/MenuController.dart';
import '../widgets/header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: "Dashboard",
              fct: () {
                context.read<CustomMenuController>().controlDashboarkMenu();
              },
            ),
            const SizedBox(height: 20,),
            TextWidget(text: "Latest Product", color: color),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ButtonsWidget(
                      onPressed: () {},
                      text: "View All",
                      icon: Icons.store,
                      backgroundColor: Colors.blue
                  ),
                  const Spacer(),
                  ButtonsWidget(
                      onPressed: () {
                        GlobalMethods.navigateTo(ctx: context, routeName: UploadProductForm.routeName);
                      },
                      text: "Add product",
                      icon: Icons.add,
                      backgroundColor: Colors.green
                  ),

                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  //flex: 5,
                  child: Column(
                    children: [
                      Responsive(
                        mobile: ProductGrid(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProductGrid(
                            childAspectRatio: size.width < 1400 ? 0.8 : 1.08),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
