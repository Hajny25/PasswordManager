import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/userMenu/passwordGenerator.dart';
import 'package:password_manager/userMenu/websiteNotifier.dart';
import 'package:password_manager/websites.dart';
import 'package:password_manager/cupertinoHelpers.dart';
import 'package:provider/provider.dart';
import '../sql/databaseHandler.dart';

class AddWebsitePopUp extends StatefulWidget {
  AddWebsitePopUp();
  @override
  _AddWebsitePopUpState createState() => _AddWebsitePopUpState();
}

class _AddWebsitePopUpState extends State<AddWebsitePopUp> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final scrollController = FixedExtentScrollController();
  List<UnusedWebsite> websitesToDisplay;

  @override
  void initState() {
    this.websitesToDisplay =
        Provider.of<WebsiteListNotifier<UnusedWebsite>>(context, listen: false)
            .value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<UnusedWebsite> websitesList =
        Provider.of<WebsiteListNotifier<UnusedWebsite>>(context).value;
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("Add website",
              style: Theme.of(context).appBarTheme.titleTextStyle),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            height: 600,
            margin: EdgeInsets.fromLTRB(20, 25, 20, 40), //20
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: CupertinoSearchTextField(
                    onChanged: (text) {
                      setState(() {
                        websitesToDisplay = websitesList
                            .where((element) => element.websiteName
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                            .toList();
                      });
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: 250,
                  //width: 300,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30)),
                  child: CupertinoPicker.builder(
                    scrollController: scrollController,
                    diameterRatio: 2,
                    backgroundColor: Colors.black,
                    childCount: this.websitesToDisplay.length,
                    itemExtent: 40,
                    onSelectedItemChanged:
                        (index) {}, // intended, no change needed
                    itemBuilder: (context, index) {
                      var website = this.websitesToDisplay[index];
                      return Center(
                          child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 8),
                            child: website.getImage(width: 20, height: 20),
                          ),
                          Text(
                            website.websiteName,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ));
                    },
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Your username:",
                          style: Theme.of(context).textTheme.bodyText1))),
              cupertinoTextField(context, usernameController,
                  CupertinoIcons.person_alt_circle_fill, "Username"),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Your password:",
                          style: Theme.of(context).textTheme.bodyText1))),
              cupertinoTextField(context, passwordController,
                  CupertinoIcons.lock_circle_fill, "Password"),
              CupertinoButton(
                child: Text("Generate Password"),
                onPressed: () {
                  String password = getPassword(20);
                  setState(() {
                    passwordController.text = password;
                  });
                },
              ),
              ElevatedButton(
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Theme.of(context).cardColor),
                  ),
                  style: Theme.of(context).elevatedButtonTheme.style,
                  onPressed: () async => await onConfirm())
            ]),
          ),
        ),
      )),
    );
  }

  Future<void> onConfirm() async {
    if (this.websitesToDisplay.isNotEmpty) {
      UnusedWebsite unusedWebsite =
          this.websitesToDisplay[this.scrollController.selectedItem];
      String username = usernameController.text;
      String password = passwordController.text;
      print(unusedWebsite.websiteName);
      print(username);
      print(password);
      await this.addWebsite(unusedWebsite, username, password);
      Get.back();
    } else {
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text("No website provided."),
                content: Text("Please select a website."),
                actions: [
                  CupertinoDialogAction(
                    child: Text("Cancel"),
                    isDestructiveAction: true,
                    onPressed: () => Get.back(),
                  )
                ],
              ));
    }
  }

  Future<void> addWebsite(
      UnusedWebsite unusedWebsite, String username, String password) async {
    UserWebsite userWebsite =
        UserWebsite.fromUnusedWebsite(unusedWebsite, username, password);
    await DatabaseHandler.addPasswordEntry(unusedWebsite,
        userWebsite); //addWebsitePassword(user, website, username, password);
    Provider.of<WebsiteListNotifier<UserWebsite>>(context, listen: false)
        .addWebsite(userWebsite);
    print(Provider.of<WebsiteListNotifier<UserWebsite>>(context, listen: false)
        .value);
  }
}
