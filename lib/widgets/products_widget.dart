import 'package:flutter/material.dart';
import 'package:shopping_dashboard_screen/widgets/text_widget.dart';

import '../services/utils.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
  });
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}
class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.network(
                        'https://myphambachlien.vn/uploads/News/KIEN-THUC-LAM-DEP/lam-dep-bang-trai-xoai.jpg',
                        fit: BoxFit.fill,
                        // width: screenWidth * 0.12,
                        height: size.width * 0.12,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {},
                            value: 1,
                            child:const Text('Edit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                          PopupMenuItem(
                            onTap: () {},
                            value: 2,
                            child:const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red,
                              fontStyle: FontStyle.italic),
                            ),
                          ),
                        ])
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: '\$1.99',
                      color: color,
                      textSize: 18,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Visibility(
                        visible: true,
                        child: Text(
                          '\$3.89',
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: color),
                        )),
                    const Spacer(),
                    TextWidget(
                      text: '1Kg',
                      color: color,
                      textSize: 18,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                TextWidget(
                  text: 'Product Title',
                  color: color,
                  textSize: 20,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
