import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/Login/registerPage.dart';
import 'package:password_manager/themes/darkTheme.dart';
import 'package:password_manager/userMenu/userMenu.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Login/loginPage.dart';
import 'globals.dart' as Globals;
import 'userMenu/websiteNotifier.dart';
import 'websites.dart';
import 'sql/databaseHandler.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await loadGlobals();
  FirebaseAuth.instance.userChanges().listen((User user) {
    if (user == null) {
      print("User is currently logged out.");
    } else {
      print("User is currently logged in.");
      print(user.email);
    }
  });
  runApp(MyApp());
}

Future<void> loadGlobals() async {
  Directory appDir = await getApplicationDocumentsDirectory();
  Globals.appDir = appDir;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider<User>(
          //     create: (_) => FirebaseAuthHelper().getCurrentUser()),
          ChangeNotifierProvider<UsedWebsiteListNotifier>(
              create: (_) => UsedWebsiteListNotifier([])),
          ChangeNotifierProvider<UnusedWebsiteListNotifier>(
              create: (_) =>
                  UnusedWebsiteListNotifier([UnusedWebsite("sample", 0)]))
        ],
        builder: (context, _) => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Password Manager',
              theme: darkTheme,
              home: RegisterPage(), //WebsiteClose(Website("Google", 0)),
            ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
