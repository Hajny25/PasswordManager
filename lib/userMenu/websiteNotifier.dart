import 'package:flutter/material.dart';

import '../websites.dart';

class WebsiteListNotifier extends ValueNotifier<List<Website>> {
  List<Website> list;
  WebsiteListNotifier(this.list) : super(list);

  void addWebsite(UnusedWebsite website) {
    this.list.add(website);
    notifyListeners();
  }

  void removeWebsite(UnusedWebsite website) {
    this.list.remove(website);
    notifyListeners();
  }
}

class UsedWebsiteListNotifier extends WebsiteListNotifier {
  List<UserWebsite> websiteList;
  UsedWebsiteListNotifier(this.websiteList) : super(websiteList);
}

class UnusedWebsiteListNotifier extends WebsiteListNotifier {
  List<UnusedWebsite> websiteList;
  UnusedWebsiteListNotifier(this.websiteList) : super(websiteList);
}
