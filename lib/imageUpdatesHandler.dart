import 'dart:io'; // Directory & File
import 'globals.dart' as Globals; // for appDir

import 'package:firebase_storage/firebase_storage.dart';
import 'package:archive/archive.dart'; // unzipping

import 'fileHandler.dart';
import 'Firebase/storage.dart';

String updateImagesFolder = "Image Updates";
String _updateFile = updateImagesFolder + "/imageUpdates.txt";

Future<bool> updateNeeded() async {
  String lastName = await getLastName();
  String content = await FileHandler.read(_updateFile);
  if (content.contains(lastName)) {
    return false;
  }
  return true;
}

Future<void> updateFile(String text) async {
  await FileHandler.write(text + "\n", _updateFile);
}

updateImages(String subDir) async {
  if (await updateNeeded()) {
    Directory appDir = Globals.appDir;
    String fileLocation = "$appDir/$subDir";
    String ref = "/Image Updates";
    File zipFile = await downloadFile(fileLocation, ref);
    String name = zipFile.path.split(Platform.pathSeparator).last;
    unzipFile(zipFile);
    updateFile(name);
  }
}

Future<File> downloadFile(String fileLocation, String reference) async {
  try {
    final ref = FirebaseStorage.instance.ref(reference);
    String fileName = ref.name;
    File downloadFile = File("$fileLocation/$fileName");
    downloadFile.create(recursive: true);
    ref.writeToFile(downloadFile);

    return downloadFile;
  } on FirebaseException {
    print("Download failed.");
  }
}

Future<void> unzipFile(File zippedFile) async {
  final dir = zippedFile.parent.path;
  String subDir =
      zippedFile.path.split(Platform.pathSeparator).first.split(".").last;
  final bytes = zippedFile.readAsBytesSync();
  Archive archive = ZipDecoder().decodeBytes(bytes);
  for (var file in archive) {
    var filename = "$dir/$subDir/${file.name}";
    if (file.isFile) {
      var outFile = File(filename);
      outFile = await outFile.create(recursive: true);
      await outFile.writeAsBytes(file.content);
    }
  }
}
