import 'package:flutter/material.dart';
import 'package:password_manager/userMenu/websiteListWidget.dart';
import 'package:password_manager/websites.dart';

class FavoritesPage extends StatefulWidget {
  final List<UserWebsite> favorites;

  FavoritesPage(this.favorites);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return WebsiteList(this.widget.favorites);
  }
}