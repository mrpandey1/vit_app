import 'package:flutter/material.dart';

snackBar(
  context, {
  isErrorSnackbar = false,
  String errorText,
  String successText,
}) {
  return SnackBar(
    content: Text(isErrorSnackbar ? errorText : successText),
    backgroundColor: isErrorSnackbar ? Colors.red : Colors.green,
  );
}
