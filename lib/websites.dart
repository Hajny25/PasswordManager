import 'package:flutter/material.dart';
import 'package:password_manager/imageUpdatesHandler.dart';
import 'dart:io';
import 'globals.dart' as Globals;

abstract class Website {
  String websiteName;
  int update; // 0: from beginning, n: added with update no. n

  Website(this.websiteName, this.update);

  factory Website.fromMap(Map<String, dynamic> map) => null;

  Widget getImage({double width, double height}) {
    if (this.update == 0) {
      return Image.asset(
        "assets/images/logos/logo_${websiteName.toLowerCase()}.png",
        width: width,
        height: height,
      );
    } else {
      return Image.file(
          File(
              "${Globals.appDir}/Update${this.update}/logo_${websiteName.toLowerCase()}.png"),
          width: width,
          height: height);
    }
  }
}

class UnusedWebsite extends Website {
  String websiteName;
  int update; // 0: from beginning, n: added with update no. n

  UnusedWebsite(this.websiteName, this.update) : super(websiteName, update);

  factory UnusedWebsite.fromMap(Map<String, dynamic> map) {
    return UnusedWebsite(map["websiteName"], map["update"]);
  }

  factory UnusedWebsite.fromUserWebsite(UserWebsite userWebsite) {
    return UnusedWebsite(userWebsite.websiteName, userWebsite.update);
  }
}

class UserWebsite extends Website {
  String username;
  String password;
  bool isFavorite;

  UserWebsite(websiteName, update, this.username, this.password,
      [this.isFavorite = false])
      : super(websiteName, update);

  @override
  factory UserWebsite.fromMap(Map<String, dynamic> map) {
    return UserWebsite(map["websiteName"], map["update"], map["username"],
        map["password"], map["isFavorite"]);
  }

  factory UserWebsite.fromUnusedWebsite(
      UnusedWebsite website, String username, String password,
      [bool isFavorite = false]) {
    return UserWebsite(
        website.websiteName, website.update, username, password, isFavorite);
  }

  void toggleFavorite() {
    this.isFavorite = !this.isFavorite;
  }
}
