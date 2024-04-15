import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_dashboard_screen/inner_screens/edit_product.dart';
import 'package:shopping_dashboard_screen/widgets/loading_manager/loading_manager.dart';
import 'package:shopping_dashboard_screen/widgets/text_widget.dart';
import '../services/global_method.dart';
import '../services/utils.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.id,
  });

  // Access product by ID
  final String id;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  // Declare variable
  String title = "";
  String productCategory = "";
  String? imageUrl = "";
  String price = "0.0";
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;

  // Loading product data
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductsData(context);
  }

  bool _isLoading = false;

  // Get product data
  Future<void> getProductsData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // get product with collection "products"
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      // Add if mounted here
      if (mounted) {
        // Fetch data & Store data into product
        setState(() {
          title = productsDoc.get('title');
          productCategory = productsDoc.get('productCategoryName');
          imageUrl = productsDoc.get('imageUrl');
          price = productsDoc.get('price');
          salePrice = productsDoc.get('salePrice');
          isOnSale = productsDoc.get('isOnSale');
          isPiece = productsDoc.get('isPiece');
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return LoadingManager(
      isLoading: _isLoading,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor.withOpacity(0.6),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProductScreen(
                      id: widget.id,
                      title: title,
                      price: price,
                      salePrice: salePrice,
                      productCat: productCategory,
                      imageUrl: imageUrl == null
                          ? "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"
                          : imageUrl!,
                      isOnSale: isOnSale,
                      isPiece: isPiece)));
            },
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
                          imageUrl == null
                              ? "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"
                              : imageUrl!,
                          fit: BoxFit.fill,
                          // width: screenWidth * 0.12,
                          height: size.width * 0.12,
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => EditProductScreen(
                                            id: widget.id,
                                            title: title,
                                            price: price,
                                            salePrice: salePrice,
                                            productCat: productCategory,
                                            imageUrl: imageUrl == null
                                                ? "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"
                                                : imageUrl!,
                                            isOnSale: isOnSale,
                                            isPiece: isPiece)));
                                  },
                                  value: 1,
                                  child: const Text("Edit"),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    GlobalMethods.warningDialog(
                                        title: "Delete?",
                                        subtitle: "Press okay to confirm",
                                        fct: () async {
                                          await FirebaseFirestore.instance
                                              .collection("products")
                                              .doc(widget.id)
                                              .delete();
                                          await Fluttertoast.showToast(
                                            msg: "Product has been deleted",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                          );
                                          if (context.mounted){
                                            while (Navigator.canPop(context)) {
                                              Navigator.pop(context);
                                            }
                                          }
                                        },
                                        context: context);
                                  },
                                  value: 2,
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
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
                        text: isOnSale
                            ? '\$${salePrice.toStringAsFixed(2)}'
                            : '\$$price',
                        color: color,
                        textSize: 18,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Visibility(
                          visible: isOnSale,
                          child: Text(
                            '\$$price',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: color),
                          )),
                      const Spacer(),
                      TextWidget(
                        text: isPiece ? 'Piece' : '1Kg',
                        color: color,
                        textSize: 18,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextWidget(
                    text: title,
                    color: color,
                    textSize: 20,
                    isTitle: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
