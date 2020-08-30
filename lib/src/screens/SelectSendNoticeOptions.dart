import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vit_app/src/shared/header.dart';

class SelectSendNoticeOptions extends StatefulWidget {
  final String noticeText;
  final String fromText;
  final File file;

  const SelectSendNoticeOptions(
      {Key key, this.noticeText, this.fromText, this.file})
      : super(key: key);

  @override
  _SelectSendNoticeOptionsState createState() =>
      _SelectSendNoticeOptionsState();
}

class _SelectSendNoticeOptionsState extends State<SelectSendNoticeOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        isAppTitle: false,
        titleText: 'Select Options',
        isCenterTitle: true,
        bold: true,
      ),
      body: Center(
        child: Container(
          child: Text('Options'),
        ),
      ),
    );
  }
}
