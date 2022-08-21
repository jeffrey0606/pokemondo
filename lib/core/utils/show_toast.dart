import 'package:flutter/material.dart';

import 'enums.dart';
import 'extensions.dart';

BuildContext? APP_ROOT_BIULD_CONTEXT;

void showToast({
  required String message,
  int duration = 5,
  required ToastMessageType type,
}) {
  if(APP_ROOT_BIULD_CONTEXT == null) {
    return;
  }
  ScaffoldMessenger.of(APP_ROOT_BIULD_CONTEXT!)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(APP_ROOT_BIULD_CONTEXT!).textTheme.headline4!.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: type.color,
        duration: Duration(
          seconds: duration,
        ),
      ),
    );
}
