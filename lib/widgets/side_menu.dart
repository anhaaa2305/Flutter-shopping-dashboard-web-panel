import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shopping_dashboard_screen/inner_screens/all_orders.dart';
import 'package:shopping_dashboard_screen/inner_screens/all_products.dart';
import 'package:shopping_dashboard_screen/widgets/text_widget.dart';

import '../providers/dark_theme_provider.dart';
import '../screens/main_screen.dart';
import '../services/utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = Utils(context).color;
    return Drawer(
      backgroundColor: theme ? Colors.black : Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              "images/10061684.png",
            ),
          ),
          DrawerListTile(
            title: "Main",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
            icon: Icons.home_filled,
          ),
          DrawerListTile(
            title: "View all product",
            press: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const AllProductsScreen()));
            },
            icon: Icons.store,
          ),
          DrawerListTile(
            title: "View all order",
            press: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const AllOrderScreen()));
            },
            icon: IconlyBold.bag2,
          ),
          SwitchListTile(
              title:Text('Theme',
              style: TextStyle(
                color: theme ? Colors.white : Colors.black,
              ),),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: theme ? Colors.white : Colors.black,),
              value: theme,
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              })
        ],
      ),
    );
  }
}
class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
    required this.icon,
  });

  final String title;
  final VoidCallback press;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          size: 18,
          color: theme ? Colors.white : Colors.black,
        ),
        title: TextWidget(
          text: title,
          color:theme ? Colors.white : Colors.black,
        ));
  }
}
