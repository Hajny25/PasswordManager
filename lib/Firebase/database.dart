import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_manager/Firebase/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../websites.dart';

final usersCollection = FirebaseFirestore.instance.collection("users/");
final globalWebsitesCollection =
    FirebaseFirestore.instance.collection("websites/");

Future<void> registerInDatabase(User user) async {
  // set name and id
  final userDoc = usersCollection.doc(user.uid);
  Map userJson = jsonifyUser(user);
  await userDoc.set(userJson);
  // set unused subcollection
  final globalWebsitesList = await getGlobalWebsites();
  for (var website in globalWebsitesList) {
    var websiteJson = jsonifyWebsite(website);
    userDoc.collection("unused").doc(website.websiteName).set(websiteJson);
  }
  print("New user registered: ${user.displayName} (ID: ${user.uid})");
}

void addGlobalWebsites() {
  // add global websites
  List<Website> websiteList; // needs to be initialized
  for (var website in websiteList) {
    Map websiteJson = jsonifyWebsite(website);
    globalWebsitesCollection.doc(website.websiteName).set(websiteJson);
  }
}

Future<List<Website>> getUserWebsites(User user, String collectionName) async {
  List<String> fields = ["websiteName", "update"];
  if (collectionName != "unused") {
    fields.addAll(["username", "password", "isFavorite"]);
  }

  List<Website> websitesList = [];
  final websiteCollection = await FirebaseFirestore.instance
      .collection("users/")
      .doc(user.uid)
      .collection(collectionName)
      .get();

  websiteCollection.docs.forEach((doc) {
    Map<String, dynamic> argsMap = {};
    fields.forEach((field) {
      argsMap[field] = doc[field];
    });
    var website = (collectionName != "unused")
        ? UserWebsite.fromMap(argsMap)
        : Website.fromMap(argsMap);
    websitesList.add(website);
  });
  return websitesList;
}

Future<List<UserWebsite>> getUsedWebsites(User user) async {
  List<UserWebsite> websitesList = await getUserWebsites(user, "passwords");
  return websitesList;
}

Future<List<Website>> getUnusedWebsites(User user) async {
  List<Website> websitesList = await getUserWebsites(user, "unused");
  return websitesList;
}

Future<List<Website>> getGlobalWebsites() async {
  // gets all websites
  List<Website> websitesList = [];
  final websitesSnapshot = await globalWebsitesCollection.get();
  websitesSnapshot.docs.forEach((doc) {
    if (doc.exists) {
      websitesList.add(Website(doc["websiteName"], doc["update"]));
    }
  });
  return websitesList;
}

void addWebsitePassword(
    User user, Website website, String username, String password) {
  UserWebsite userWebsite = transferToUserWebsite(website, username, password);
  addWebsiteEntry(user, "passwords", userWebsite);
  deleteWebsiteEntry(user, "unused", website.websiteName);
}

void addToFavorites(User user, UserWebsite website) {
  updateField(user, website, "isFavorite", website.isFavorite);
}

void deleteWebsiteEntry(
    User user, String collectionName, String docName) async {
  await usersCollection
      .doc(user.uid)
      .collection(collectionName)
      .doc(docName)
      .delete();
}

void addWebsiteEntry(User user, String collectionName, Website website) async {
  Map<String, dynamic> data = {};
  if (website is UserWebsite) {
    data = jsonifyUserWebsite(website);
  } else {
    data = jsonifyWebsite(website);
  }
  await usersCollection
      .doc(user.uid)
      .collection(collectionName)
      .doc(website.websiteName)
      .set(data);
}

UserWebsite transferToUserWebsite(
    Website website, String username, String password,
    [bool isFavorite = false]) {
  return UserWebsite(
      website.websiteName, website.update, username, password, isFavorite);
}

void updateField(
    User user, UserWebsite website, String field, dynamic value) async {
  final updateData = {field: value};
  final doc = await usersCollection
      .doc(user.uid)
      .collection("passwords")
      .where("websiteName", isEqualTo: website.websiteName)
      .get();
  doc.docs.first.reference.set(updateData);
}

void changeUsername(User user, UserWebsite website, String value) {
  updateField(user, website, "username", value);
}

void changePassword(User user, UserWebsite website, String value) {
  updateField(user, website, "password", value);
}

Map<String, dynamic> jsonifyUser(User user) {
  return {"id": user.uid, "name": user.displayName};
}

Map<String, dynamic> jsonifyWebsite(Website website) {
  // returns a website as a dict
  Map<String, dynamic> websiteJson = {};
  websiteJson["websiteName"] = website.websiteName;
  websiteJson["update"] = website.update;
  return websiteJson;
}

Map<String, dynamic> jsonifyUserWebsite(UserWebsite website) {
  // returns a website as a dict
  Map<String, dynamic> websiteJson = {};
  websiteJson["websiteName"] = website.websiteName;
  websiteJson["update"] = website.update;
  websiteJson["username"] = website.username;
  websiteJson["password"] = website.password;
  websiteJson["isFavorite"] = website.isFavorite;
  return websiteJson;
}

String deleteSuffix(String email) {
  return email.substring(0, email.length - "@dummy123.hu".length);
}

Future<void> changeName(User user) async {
  // changes FirebaseUser's name
  String newName = deleteSuffix(user.email);
  await user.updateProfile(displayName: newName);
  await user.reload();
  user = FirebaseAuthHelper().getCurrentUser();
}
