import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/registerPage.dart';
import 'package:password_manager/userMenu/userMenu.dart';

class RegisterLoadingScreen extends StatefulWidget {
  RegisterLoadingScreen({Key key}) : super(key: key);

  @override
  _RegisterLoadingScreenState createState() => _RegisterLoadingScreenState();
}

class _RegisterLoadingScreenState extends State<RegisterLoadingScreen> {
  Future<void> _future;

  
  @override
  void initState() {
    super.initState();
    this._future = register();
  }

  Future<void> register() async {
    await signUpSuccessful();
  }

  // final Future<String> _calculation = Future<String>.delayed(
  //   const Duration(seconds: 2),
  //   () => 'Data Loaded',
  // );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this._future,
        builder: (BuildContext coontext, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return UserMenu();
          }
          if (snapshot.hasError) {
            //
          }
          return _loadingScreen();
        });
  }

  Widget _loadingScreen() {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(radius: 20),
            SizedBox(
              height: 30,
            ),
            Text(
              "Logging in",
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
    ));
  }
}
