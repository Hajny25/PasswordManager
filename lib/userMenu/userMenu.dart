import 'package:firebase_auth/firebase_auth.dart';
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
  UsedWebsiteListNotifier websiteListNotifier = UsedWebsiteListNotifier([]);
  UsedWebsiteListNotifier favoritesListNotifier = UsedWebsiteListNotifier([]);
  UnusedWebsiteListNotifier unusedWebsiteListNotifier = UnusedWebsiteListNotifier([]);

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
      List<UserWebsite> websiteList, List<Website> unusedWebsiteList) {
    websiteListNotifier.value = websiteList;
    favoritesListNotifier.value =
        websiteList.where((element) => element.isFavorite == true).toList();
    unusedWebsiteListNotifier.value = unusedWebsiteList;
    print("Notifier Setter");
    print(websiteListNotifier.value);
    print(favoritesListNotifier.value);
    print(unusedWebsiteListNotifier.value);
  }

  void setUnusedWebsites(List<Website> websiteList) {
    this.unusedWebsitesList = websiteList;
  }

  @override
  Widget build(BuildContext context) {
    final _currentName = this.tabNames[this._currentIndex];

    return
        // MultiProvider(
        //   providers: [
        //     // ChangeNotifierProvider<User>(
        //     //     create: (_) => FirebaseAuthHelper().getCurrentUser()),
        //     ChangeNotifierProvider<UsedWebsiteListNotifier>(
        //         create: (_) => UsedWebsiteListNotifier([])),
        //     ChangeNotifierProvider<UnusedWebsiteListNotifier>(
        //         create: (_) => UnusedWebsiteListNotifier([Website("sample", 0)]))
        //   ],
        //   child:
        Container(
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
            bottomNavigationBar: NavigationBar(this._currentIndex, updateTab),
            floatingActionButton: isLoaded && _currentIndex == 0
                ? floatingActionButton(context, unusedWebsiteListNotifier)
                : null,
            body: UserMenuBody(
                widget.user,
                this._currentIndex,
                this.websiteListNotifier,
                this.favoritesListNotifier,
                this.unusedWebsiteListNotifier,
                this.setIsLoaded,
                setUnusedWebsites,
                this.setWebsiteListNotifiers)),
      ),
    );
  }
}

class UserMenuBody extends StatefulWidget {
  final user;
  final int currentIndex;
  final UsedWebsiteListNotifier websiteListNotifier;
  final UsedWebsiteListNotifier favoritesListNotifier;
  final UnusedWebsiteListNotifier unusedWebsiteListNotifier;
  final Function isLoadedSetter;
  final Function unusedWebsitesSetter;
  final Function setWebsiteNotifiers;
  UserMenuBody(
      this.user,
      this.currentIndex,
      this.websiteListNotifier,
      this.favoritesListNotifier,
      this.unusedWebsiteListNotifier,
      this.isLoadedSetter,
      this.unusedWebsitesSetter,
      this.setWebsiteNotifiers);

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
      "My Vault": () => VaultPage(this.widget.websiteListNotifier),
      "Favorites": () => FavoritesPage(this.widget.favoritesListNotifier),
      "Password Generator": () => GeneratorPage()
    };
    super.initState();
  }

  Future<void> fetchData() async {
    this.websiteList = await getUsedWebsites(widget.user);
    final unusedWebsitesList = await getUnusedWebsites(widget.user);
    this.widget.unusedWebsitesSetter(unusedWebsitesList);
    this.favoriteWebsiteList = getFavorites();
    this.widget.isLoadedSetter();
    //print("Going to set");
    //this.setWebsiteListNotifiers(this.websiteList, this.favoriteWebsiteList);
    //print("Notifiers:");
    //print(Provider.of<UnusedWebsiteListNotifier>(context).value);
    this.widget.setWebsiteNotifiers(this.websiteList, unusedWebsitesList);
    print("Fetching data completed.");
  }

  // void setWebsiteListNotifiers(
  //     List<UserWebsite> usedWebsites, List<Website> unusedWebsites) {
  //   print("Entered setter");
  //   print(Provider.of<UnusedWebsiteListNotifier>(context).value);
  //   Provider.of<UsedWebsiteListNotifier>(context).value = usedWebsites;
  //   print("First checkpoint");
  //   Provider.of<UnusedWebsiteListNotifier>(context).value = unusedWebsites;
  // }

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
    // print("Test: ${Provider.of<UnusedWebsiteListNotifier>(context).value[0].websiteName}");

    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Widget> children;
        if (snapshot.connectionState == ConnectionState.done) {//} && snapshot.data != null) {
          print(snapshot.data == null);
          Widget currentTab =
              this.tabs.values.toList()[this.widget.currentIndex]();
          print("build?");
          print(snapshot.data);
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
