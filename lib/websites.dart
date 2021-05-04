import 'package:flutter/material.dart';
import 'dart:io';
import 'globals.dart' as Globals;

abstract class Website {
  String websiteName;
  int imageGroup; // 0: from beginning, n: added with update no. n

  Website(this.websiteName, this.imageGroup);

  factory Website.fromMap(Map<String, dynamic> map) => null;

  Widget getImage({double width, double height}) {
    if (this.imageGroup == 0) {
      return Image.asset(
        "assets/images/logos/logo_${websiteName.toLowerCase()}.png",
        width: width,
        height: height,
      );
    } else {
      return Image.file(
          File(
              "${Globals.appDir}/Update${this.imageGroup}/logo_${websiteName.toLowerCase()}.png"),
          width: width,
          height: height);
    }
  }
}

class UnusedWebsite extends Website {
  String websiteName;
  int imageGroup; // 0: from beginning, n: added with update no. n

  UnusedWebsite(this.websiteName, this.imageGroup)
      : super(websiteName, imageGroup);

  factory UnusedWebsite.fromMap(Map<String, dynamic> map) {
    return UnusedWebsite(map["websiteName"], map["imageGroup"]);
  }

  factory UnusedWebsite.fromUserWebsite(UserWebsite userWebsite) {
    return UnusedWebsite(userWebsite.websiteName, userWebsite.imageGroup);
  }
}

class UserWebsite extends Website {
  String username;
  String password;
  bool isFavorite;

  UserWebsite(websiteName, imageGroup, this.username, this.password,
      [this.isFavorite = false])
      : super(websiteName, imageGroup);

  @override
  factory UserWebsite.fromMap(Map<String, dynamic> map) {
    var isFavorite = map["isFavorite"];
    return UserWebsite(
      map["websiteName"],
      map["imageGroup"],
      map["username"],
      map["password"],
      isFavorite is bool ? isFavorite : isFavorite == 1
    );
  }

  factory UserWebsite.fromUnusedWebsite(
      UnusedWebsite website, String username, String password,
      [bool isFavorite = false]) {
    return UserWebsite(website.websiteName, website.imageGroup, username,
        password, isFavorite);
  }

  void toggleFavorite() {
    this.isFavorite = !this.isFavorite;
  }
}
