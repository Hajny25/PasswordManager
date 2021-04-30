import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/themes/colors.dart';

Widget cupertinoTextField(BuildContext context,
    TextEditingController controller, IconData suffixIcon, String placeholder) {
  return CupertinoTextField(
    controller: controller,
    suffix: Icon(suffixIcon, color: MyColors.grey[12]),
    placeholder: placeholder,
    style: MaterialBasedCupertinoThemeData(materialTheme: Theme.of(context)).textTheme.textStyle
  );
}
final x = CupertinoThemeData(textTheme: CupertinoTextThemeData());