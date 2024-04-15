import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:shopping_dashboard_screen/widgets/grid_products.dart";
import "package:shopping_dashboard_screen/widgets/header.dart";
import "../controllers/MenuController.dart";
import "../responsive.dart";
import "../services/utils.dart";
import "../widgets/side_menu.dart";


class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});
  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<CustomMenuController>().getgridscaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Header(
                        title: "All products",
                        fct: () {
                          context
                              .read<CustomMenuController>()
                              .controlProductsMenu();
                        },
                      ),
                      Responsive(
                        mobile: ProductGrid(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                          size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          isInMain: false,
                        ),
                        desktop: ProductGrid(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          isInMain: false,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
