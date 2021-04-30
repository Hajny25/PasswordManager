import 'dart:convert';

import 'dart:math';

final _random = Random();

abstract class Character {
  int length;
  List<String> charList;
  Character(this.length);

  List<String> getChars() {
    List<String> chars = [];
    for (int i = 0; i < this.length; i++) {
      chars.add(this.charList[_random.nextInt(this.charList.length)]);
    }
    return chars;
  }
}

class Upper extends Character {
  int length;
  Upper(this.length) : super(length) {
    super.charList = [
      for (int i = 65; i <= 90; i++) AsciiDecoder().convert([i])
    ];
  }
}

class Lower extends Character {
  int length;
  Lower(this.length) : super(length) {
    super.charList = [
      for (int i = 97; i <= 122; i++) AsciiDecoder().convert([i])
    ];
  }
}

class Number extends Character {
  int length;
  Number(this.length) : super(length) {
    super.charList = [for (int i = 0; i <= 9; i++) i.toString()];
  }
}

class Special extends Character {
  int length;
  Special(this.length) : super(length) {
    super.charList = [
      for (int i = 33; i <= 43; i++)
        if (i != 34 && i != 39) AsciiDecoder().convert([i])
    ];
  }
}

String getPassword(int length) {
  List<String> passwordChars = [];
  String password = "";
  int letters = length ~/ 2;
  int lowers = letters ~/ 2;
  int uppers = letters - lowers;
  int specials = (length - letters) ~/ 2;
  int numbers = length - letters - specials;
  passwordChars.addAll(Upper(uppers).getChars());
  passwordChars.addAll(Lower(lowers).getChars());
  passwordChars.addAll(Number(numbers).getChars());
  passwordChars.addAll(Special(specials).getChars());
  passwordChars.shuffle();
  for (String char in passwordChars) {
    password += char;
  }
  return password;
}