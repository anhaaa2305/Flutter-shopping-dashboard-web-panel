import "dart:async";
import "dart:io";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:dotted_border/dotted_border.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_iconly/flutter_iconly.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";
import "package:shopping_dashboard_screen/controllers/MenuController.dart";
import "package:shopping_dashboard_screen/responsive.dart";
import "package:shopping_dashboard_screen/services/utils.dart";
import "package:shopping_dashboard_screen/widgets/header.dart";
import "package:shopping_dashboard_screen/widgets/loading_manager/loading_manager.dart";
import "package:shopping_dashboard_screen/widgets/side_menu.dart";
import "package:shopping_dashboard_screen/widgets/text_widget.dart";
import "package:uuid/uuid.dart";
import "../services/global_method.dart";
import "../widgets/buttons.dart";

class UploadProductForm extends StatefulWidget {
  static const routeName = "/UploadProductForm";
  const UploadProductForm({super.key});
  @override
  State<UploadProductForm> createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = "Vegetables";
  late final TextEditingController _titleController, _priceController;
  int _groupValue = 1;
  bool isPiece = false;
  File? _pickImage;
  Uint8List webImage = Uint8List(8);


  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _pickImage == null) {
      return false;
    }
    return true;
  }

  bool _isLoading = false;
  void _uploadForm(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    String? imageUrl;
    FocusScope.of(context).unfocus();
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    if (isValid) {
      _formKey.currentState!.save();
      if (_pickImage == null) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethods.errorDialog(
            subtitle: "Please pick up an image", context: context);
        return;
      }
      final uid = const Uuid().v4();
      try {
        // Store image with Firebase
        final ref = FirebaseStorage.instance
            .ref()
            .child("productImages")
            .child("$uid.jpg");
        if (kIsWeb) {
          await ref.putData(webImage);
        } else {
          await ref.putFile(_pickImage!);
        }
        imageUrl = await ref.getDownloadURL();
        // Using Cloud FireStore to Store data
        await FirebaseFirestore.instance.collection("products").doc(uid).set({
          "id": uid,
          "title": _titleController.text.trim(),
          "price": _priceController.text,
          "salePrice": 0.1,
          "imageUrl": imageUrl,
          "productCategoryName": _catValue,
          "isOnSale": false,
          "isPiece": isPiece,
          "createAt": Timestamp.now(),
        });
        _clearForm();
        Fluttertoast.showToast(
            msg: "Product uploaded successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      } on FirebaseException catch (error) {
        setState(() {
          _isLoading = false;
        });
        if (context.mounted) {
          GlobalMethods.errorDialog(
              subtitle: "Has occured when saving product: ${error.message}",
              context: context);
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        if (context.mounted) {
          GlobalMethods.errorDialog(
              subtitle: "Has occured when saving product: $error",
              context: context);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() async {
    _priceController.clear();
    _titleController.clear();
    _groupValue = 1;
    _catValue = "Vegetables";
    isPiece = false;
    setState(() {
      _pickImage = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;
    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: scaffoldColor,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    return Scaffold(
      key: context.read<CustomMenuController>().getAddProductscaffoldKey,
      drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Header(
                        fct: () {
                          context
                              .read<CustomMenuController>()
                              .controlAddProductsMenu();
                        },
                        title: "Add product",
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: size.width > 650 ? 650 : size.width,
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextWidget(
                              text: "Product title*",
                              color: color,
                              isTitle: true,
                              textSize: 20,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 600,
                              child: TextFormField(
                                controller: _titleController,
                                key: const ValueKey("Title"),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter a Title";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: color
                                ),
                                decoration: inputDecoration,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: "Price in \$*",
                                          color: color,
                                          isTitle: true,
                                          textSize: 20,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                            controller: _priceController,
                                            key: const ValueKey("Price \$"),
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Price is missed";
                                              }
                                              return null;
                                            },
                                            style: TextStyle(
                                                color: color,
                                              fontSize: 20,
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r"[0-9.]")),
                                            ],
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextWidget(
                                          text: "Product category*",
                                          color: color,
                                          isTitle: true,
                                          textSize: 20,
                                        ),
                                        const SizedBox(height: 10),
                                        // Drop down menu code here
                                        _categoryDropDown(),

                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextWidget(
                                          text: "Measure unit*",
                                          color: color,
                                          isTitle: true,
                                          textSize: 20,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // Radio button code here
                                        Row(
                                          children: [
                                            TextWidget(
                                              text: "KG",
                                              color: color,
                                            ),
                                            Radio(
                                              value: 1,
                                              groupValue: _groupValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  _groupValue = 1;
                                                  isPiece = false;
                                                });
                                              },
                                              activeColor: Colors.green,
                                            ),
                                            TextWidget(
                                              text: "Piece",
                                              color: color,
                                              textSize: 20,
                                            ),
                                            Radio(
                                              value: 2,
                                              groupValue: _groupValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  _groupValue = 2;
                                                  isPiece = true;
                                                });
                                              },
                                              activeColor: Colors.green,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // Image to be picked code is here
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: size.width > 650
                                          ? 350
                                          : size.width * 0.45,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: _pickImage == null
                                          ? dottedBorder(color: color)
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: kIsWeb
                                                  ? Image.memory(
                                                      webImage,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.file(_pickImage!,
                                                      fit: BoxFit.fill),
                                            ),
                                    ),
                                  ),
                                ),

                                // Delete & Update image
                                Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ButtonsWidget(
                                            onPressed: () {
                                              setState(() {
                                                _pickImage = null;
                                                webImage = Uint8List(8);
                                              });
                                            },
                                            text: "Delete image",
                                            icon: CupertinoIcons.trash,
                                            backgroundColor: Colors.red,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ButtonsWidget(
                                            onPressed: () {
                                              _uploadForm(context);
                                            },
                                            text: "Update image",
                                            icon: Icons.update,
                                            backgroundColor: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ))),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonsWidget(
                                    onPressed: () {
                                      _clearForm();
                                    },
                                    text: "Clear form",
                                    icon: IconlyBold.danger,
                                    backgroundColor: Colors.red.shade300,
                                  ),
                                  ButtonsWidget(
                                    onPressed: () {
                                      _uploadForm(context);
                                    },
                                    text: "Upload",
                                    icon: IconlyBold.upload,
                                    backgroundColor: Colors.blue,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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

  // Configure image picker
  Future<void> imagePicker() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickImage = selected;
        });
      } else {
        Fluttertoast.showToast(msg: "No image has been picked");
      }
    } else if (kIsWeb) {
      final ImagePicker picker0 = ImagePicker();
      XFile? image = await picker0.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickImage = File("a");
        });
      } else {
        Fluttertoast.showToast(msg: "No image has been picked");
      }
    } else {
      Fluttertoast.showToast(msg: "Something went wrong!!!");
    }
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      imagePicker();
                    },
                    child: TextWidget(
                      text: "Choose an image",
                      color: Colors.blue,
                    ))
              ],
            ),
          )),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          value: _catValue,
          onChanged: (value) {
            setState(() {
              _catValue = value!;
            });
          },
          hint: const Text("Select a category"),
          items: const [
            DropdownMenuItem(
              value: "Vegetables",
              child: Text(
                "Vegetables",
              ),
            ),
            DropdownMenuItem(
              value: "Fruits",
              child: Text(
                "Fruits",
              ),
            ),
            DropdownMenuItem(
              value: "Grains",
              child: Text(
                "Grains",
              ),
            ),
            DropdownMenuItem(
              value: "Nuts",
              child: Text(
                "Nuts",
              ),
            ),
            DropdownMenuItem(
              value: "Herbs",
              child: Text(
                "Herbs",
              ),
            ),
            DropdownMenuItem(
              value: "Spices",
              child: Text(
                "Spices",
              ),
            )
          ],
        )),
      ),
    );
  }
}
