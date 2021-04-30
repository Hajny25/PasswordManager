import 'dart:io';
import 'globals.dart' as Globals; // for appDir

class FileHandler {
  static write(String text, String fileLocation) async {
    Directory dir = Globals.appDir;
    File file = File("${dir.path}/$fileLocation");
    if (! await file.exists()) {
      file = await file.create();
    }
    file.writeAsString(text, mode: FileMode.append);
  }

  static Future<String> read(String fileName) async {
    String text;
    try {
      Directory dir = Globals.appDir;
      final File file = File("${dir.path}/$fileName");
      text = await file.readAsString();
    } catch (e) {
      print("Could not find file");
    }
    return text;
  }
}
