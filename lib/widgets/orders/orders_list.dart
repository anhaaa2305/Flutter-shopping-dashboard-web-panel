import 'package:flutter/material.dart';
import 'package:shopping_dashboard_screen/consts/constants.dart';
import 'package:shopping_dashboard_screen/widgets/orders/orders_widget.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(10),),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index){
            return const Column(
              children: [
                OrdersWidget(),
                Divider(thickness: 3,),
              ],
            );
          }),
    );
  }
}
