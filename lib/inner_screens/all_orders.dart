import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_dashboard_screen/controllers/MenuController.dart';
import 'package:shopping_dashboard_screen/responsive.dart';
import 'package:shopping_dashboard_screen/widgets/header.dart';
import 'package:shopping_dashboard_screen/widgets/orders/orders_list.dart';
import 'package:shopping_dashboard_screen/widgets/side_menu.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  @override
  Widget build(BuildContext context) {
    //Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<CustomMenuController>().getOrdersScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(child: SideMenu()),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Header(
                      fct: () {
                        context.read<CustomMenuController>().controlAllOrder();
                      },
                      title: "All Order",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: OrdersList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
