import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/Firebase/authentication.dart';
import 'package:password_manager/Firebase/database.dart';
import 'package:password_manager/userMenu/generator.dart';
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
  List<Website>
      unusedWebsitesList; // for adding new entries, as fab is in this widget
  WebsiteListNotifier websiteListNotifier;
  WebsiteListNotifier unusedWebsiteListNotifier;

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

  void setWebsiteListNotifiers(
      List<UserWebsite> userWebsites, List<Website> unusedWebsites) {
    this.websiteListNotifier = WebsiteListNotifier(userWebsites);
    this.unusedWebsiteListNotifier = WebsiteListNotifier(unusedWebsites);
  }

  void setUnusedWebsites(List<Website> websiteList) {
    this.unusedWebsitesList = websiteList;
  }

  @override
  Widget build(BuildContext context) {
    final _currentName = this.tabNames[this._currentIndex];

    return Provider(
      create: (_) => FirebaseAuthHelper().getCurrentUser(),
      child: Container(
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
                    ? floatingActionButton(context, unusedWebsitesList)
                    : null,
                body: UserMenuBody(widget.user, this._currentIndex, setIsLoaded,
                    setUnusedWebsites, setWebsiteListNotifiers)),
          )),
    );
  }
}

class UserMenuBody extends StatefulWidget {
  final user;
  final int currentIndex;
  final Function isLoadedSetter;
  final Function unusedWebsitesSetter;
  final Function setWebsiteNotifiers;
  UserMenuBody(this.user, this.currentIndex, this.isLoadedSetter,
      this.unusedWebsitesSetter, this.setWebsiteNotifiers);

  @override
  _UserMenuBodyState createState() => _UserMenuBodyState();
}

class _UserMenuBodyState extends State<UserMenuBody> {
  Future<void> _future;
  List<UserWebsite> websiteList;
  List<UserWebsite> favoriteWebsiteList;
  Map<String, Function> tabs;

  @override
  void initState() {
    this._future = fetchData();
    this.tabs = {
      "My Vault": () => VaultPage(this.websiteList),
      "Favorites": () => FavoritesPage(this.favoriteWebsiteList),
      "Password Generator": () => GeneratorPage()
    };
    super.initState();
  }

  Future<void> fetchData() async {
    print("Entered");
    this.websiteList = await getUsedWebsites(widget.user);
    print("Checkpoint 1: ${this.websiteList}");
    final unusedWebsitesList = await getUnusedWebsites(widget.user);
    this.widget.unusedWebsitesSetter(unusedWebsitesList);
    print("Checkpoint 2");
    this.favoriteWebsiteList = getFavorites();
    print("Updating tabs...");
    print("WebsiteList: ${this.websiteList}");
    print("unusedWebsites: $unusedWebsitesList");
    this.widget.isLoadedSetter();
    this.widget.setWebsiteNotifiers(this.websiteList, this.favoriteWebsiteList);
    print("Fetching data completed.");
  }

  void updateWebsites(UserWebsite website) {
    setState(() {
      this.websiteList.add(website);
      this.favoriteWebsiteList = getFavorites();
    });
  }

  List<UserWebsite> getFavorites() {
    return this
        .websiteList
        .where((element) => element.isFavorite == true)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Widget> children;
        if (snapshot.connectionState == ConnectionState.done) {
          Widget currentTab =
              this.tabs.values.toList()[this.widget.currentIndex]();
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
