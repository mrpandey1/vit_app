import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/screens/SelectSendNoticeOptions.dart';
import 'package:vit_app/src/shared/header.dart';

class AddNotice extends StatefulWidget {
  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  TextEditingController _noticeController = TextEditingController();
  TextEditingController _fromController = TextEditingController();
  bool noticeError = false;
  bool fromError = false;

  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        isAppTitle: false,
        titleText: 'Add Notice',
        isCenterTitle: true,
        bold: true,
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: _noticeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add Notice Here....',
                      labelText: 'Notice',
                      errorText: noticeError ? 'Notice is empty' : null,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () => {selectImage(context)},
                  child: Container(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: file != null
                                ? DecorationImage(image: FileImage(file))
                                : DecorationImage(
                                    image:
                                        AssetImage('assets/images/upload.jpg')),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text(
                    'Adding Image is Optional',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0),
                  child: TextFormField(
                    maxLines: 1,
                    controller: _fromController,
                    decoration: InputDecoration(
                      hintText: 'ex. David Assistant Professor',
                      labelText: 'From:',
                      errorText: fromError ? 'This field is required' : null,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Container(
                  height: 50.0,
                  width: 350.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    elevation: 2.0,
                    color: kPrimaryColor,
                    child: InkWell(
                      onTap: onSubmit,
                      child: Center(
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  selectImage(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Open a Camera',
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 17.0,
                  ),
                ),
                onPressed: () => handleTakePhoto(context),
              ),
              SimpleDialogOption(
                child: Text(
                  'Open a Gallery',
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 17.0,
                  ),
                ),
                onPressed: () => handleChooseFromGallery(context),
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 17.0,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  handleTakePhoto(BuildContext context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = File(pickedFile.path);
    });
  }

  handleChooseFromGallery(BuildContext context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = File(pickedFile.path);
    });
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  void onSubmit() {
    if (_fromController.text.trim().isEmpty) {
      setState(() {
        fromError = true;
      });
    } else {
      setState(() {
        fromError = false;
      });
    }

    if (_noticeController.text.trim().isEmpty) {
      setState(() {
        noticeError = true;
      });
    } else {
      noticeError = false;
    }

    if (_fromController.text.trim().isNotEmpty &&
        _noticeController.text.trim().isNotEmpty) {
      String notice = _fromController.text.trim();
      String from = _noticeController.text.trim();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectSendNoticeOptions(
                    noticeText: notice,
                    fromText: from,
                    file: file,
                  )));
    }
  }
}
