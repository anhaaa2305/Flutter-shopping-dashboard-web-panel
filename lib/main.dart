import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_dashboard_screen/inner_screens/add_product.dart';
import 'package:shopping_dashboard_screen/screens/main_screen.dart';
import 'consts/theme_data.dart';
import 'controllers/MenuController.dart';
import 'providers/dark_theme_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyCQGleWVKICh-Rn32SiIJef4VpsEd3QPHc",
      appId: "1:821726272760:web:7575d8beec8f34eb616f0d",
      messagingSenderId: "821726272760",
      projectId: "flutter-grocery-app-df567",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => CustomMenuController(),
            ),
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Admin web portal',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const MainScreen(),
                routes: {
                  UploadProductForm.routeName: (context) =>
                      const UploadProductForm(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
