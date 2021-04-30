import 'package:flutter/material.dart';

import '../websites.dart';

class WebsiteListNotifier extends ValueNotifier<List<Website>> {
  List<Website> list;
  WebsiteListNotifier(this.list) : super(list);

  void addWebsite(Website website) {
    this.list.add(website);
    notifyListeners();
  }

  void deleteWebsite(Website website) {
    this.list.remove(website);
    notifyListeners();
  }
}

class UsedWebsiteListNotifier extends WebsiteListNotifier {
  List<UserWebsite> websiteList;
  UsedWebsiteListNotifier(this.websiteList) : super(websiteList);
}

class UnusedWebsiteListNotifier extends WebsiteListNotifier {
  List<Website> websiteList;
  UnusedWebsiteListNotifier(this.websiteList) : super(websiteList);
}
