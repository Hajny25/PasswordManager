import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage storage = FirebaseStorage.instance;

final ref = storage.ref("/Image Updates");

Future<String> getLastName() async {
  final result = await ref.listAll();
  final Reference lastItem = result.items.last;
  String name = lastItem.name;
  return name;
}
