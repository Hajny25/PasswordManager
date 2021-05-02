import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/Firebase/authentication.dart';
import 'package:password_manager/Firebase/database.dart';
import 'package:password_manager/userMenu/generatorPage.dart';
import 'package:password_manager/themes/colors.dart';
import 'package:password_manager/userMenu/vaultPage.dart';
import 'package:password_manager/userMenu/websiteNotifier.dart';
import 'package:password_manager/websites.dart';
import 'package:provider/provider.dart';

import 'fab.dart';
import 'favorites.dart';
import 'navBar.dart';

class UserMenu extends StatefulWidget {
  final user = FirebaseAuthHelper().getCurrentUser();

  // final List<UserWebsite> websiteList = [
  //   UserWebsite("Google", 0, "test", "123"),
  //   UserWebsite("Snapchat", 0, "", ""),
  //   UserWebsite("Twitter", 0, "", ""),
  //   UserWebsite("Moodle", 0, "", ""),
  //   UserWebsite("Microsoft", 0, "", ""),
  //   UserWebsite("Instagram", 0, "", ""),
  //   UserWebsite("Pinterest", 0, "", ""),
  //   UserWebsite("PayPal", 0, "", ""),
  //   UserWebsite("Netflix", 0, "", ""),
  // ];
  // final List<UserWebsite> favoritesList = [
  //   UserWebsite("Google", 0, "test", "123"),
  //   UserWebsite("Snapchat", 0, "", ""),
  //   UserWebsite("Twitter", 0, "", ""),
  //   UserWebsite("Moodle", 0, "", "")
  // ];
  // final List<Website> unusedWebsitesList = [
  //   UserWebsite("TikTok", 0, "", ""),
  //   UserWebsite("Disney+", 0, "", ""),
  //   UserWebsite("Spotify", 0, "", ""),
  //   UserWebsite("Amazon", 0, "", "")
  // ];

  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  bool isLoaded = false;
  int _currentIndex = 0;
  List<String> tabNames = ["My Vault", "Favorites", "Generate Password"];

  void updateTab(int newIndex) {
    setState(() {
      this._currentIndex = newIndex;
    });
  }

  void setIsLoaded() {
    setState(() {
      this.isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _currentName = this.tabNames[this._currentIndex];

    return Provider<User>(
        create: (_) => FirebaseAuthHelper().getCurrentUser(),
        // ChangeNotifierProvider<UsedWebsiteListNotifier>(
        //     create: (_) => UsedWebsiteListNotifier([])),
        // ChangeNotifierProvider<UnusedWebsiteListNotifier>(
        //     create: (_) => UnusedWebsiteListNotifier([Website("sample", 0)]))

        builder: (context, _) => Container(
            color: MyColors.barDark,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: MyColors.backgroundDark,
                appBar: AppBar(
                    backgroundColor: MyColors.barDark,
                    centerTitle: true,
                    title: Text(
                      _currentName,
                      style: Theme.of(context).textTheme.headline6,
                    )),
                bottomNavigationBar:
                    NavigationBar(this._currentIndex, updateTab),
                floatingActionButton: isLoaded && _currentIndex == 0
                    ? floatingActionButton(context)
                    : null,
                body: UserMenuBody(
                  widget.user,
                  this._currentIndex,
                  this.setIsLoaded,
                ),
              ),
            )));
  }
}

class UserMenuBody extends StatefulWidget {
  final user;
  final int currentIndex;
  final Function isLoadedSetter;

  UserMenuBody(this.user, this.currentIndex, this.isLoadedSetter);

  @override
  _UserMenuBodyState createState() => _UserMenuBodyState();
}

class _UserMenuBodyState extends State<UserMenuBody> {
  Future<void> _future;
  Map<String, Function> tabs;

  @override
  void initState() {
    this._future = fetchData();
    this.tabs = {
      "My Vault": () => VaultPage(),
      "Favorites": () => FavoritesPage(),
      "Password Generator": () => GeneratorPage()
    };
    super.initState();
  }

  Future<void> fetchData() async {
    final websiteList = await getUsedWebsites(widget.user); //DatabaseHandler.getUsedWebsites
    final unusedWebsitesList = await getUnusedWebsites(widget.user); //DatabaseHandler.getUnusedWebsites
    this.widget.isLoadedSetter();
    this.setWebsiteListNotifiers(websiteList, unusedWebsitesList);
    print("Fetching data completed.");
  }

  void setWebsiteListNotifiers(
      List<UserWebsite> usedWebsites, List<UnusedWebsite> unusedWebsites) {
    Provider.of<UsedWebsiteListNotifier>(context, listen: false).value =
        usedWebsites;
    Provider.of<UnusedWebsiteListNotifier>(context, listen: false).value =
        unusedWebsites;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Widget> children;
        if (snapshot.connectionState == ConnectionState.done) {
          //} && snapshot.data != null) {
          print(snapshot.data == null);
          Widget currentTab =
              this.tabs.values.toList()[this.widget.currentIndex]();
          print("FutureBuilder build?");
          return currentTab;
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text("Logged in."))); // TODO snackbar after login?
        }
        if (snapshot.hasError) {
          children = [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          print(snapshot.connectionState);
          children = [
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Loading...'),
            )
          ];
        }
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children));
      },
    );
  }
}
