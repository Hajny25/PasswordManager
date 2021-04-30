import 'package:flutter/material.dart';

import '../websites.dart';

class WebsiteListNotifier extends ValueNotifier<List<Website>> {
  List<Website> value;
  WebsiteListNotifier(value) : super(value);

  void addWebsite(Website website) {
    value.add(website);
    notifyListeners();
  }

  void deleteWebsite(Website website) {
    value.remove(website);
    notifyListeners();
  }
}
