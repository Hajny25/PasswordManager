import 'package:flutter/material.dart';
import 'package:password_manager/userMenu/websiteListWidget.dart';
import 'package:password_manager/userMenu/websiteNotifier.dart';
import 'package:password_manager/websites.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage();

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  
  @override
  Widget build(BuildContext context) {
    List<UserWebsite> websiteList = Provider.of<UsedWebsiteListNotifier>(context).value;
    List<UserWebsite> favoritesList = websiteList
      .where((element) => element.isFavorite)
      .toList();
    return WebsiteList(favoritesList);
  }
}
