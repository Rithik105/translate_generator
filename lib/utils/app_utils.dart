import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:translate_generator/utils/app_constants.dart';

class AppUtils {
  static void onFilePicked(BuildContext context,
      {required FutureOr Function(FilePickerResult? file) onFileSelect}) {
    FilePicker.platform
        .pickFiles(
            type: FileType.custom,
            allowedExtensions: ['json'],
            allowMultiple: false)
        .then(onFileSelect);
  }

  static Future<void> showCustomDialog(BuildContext context,
      {Function? onSubmit, String? initialData}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController textEditingController =
              TextEditingController(text: initialData);

          return AlertDialog(
            title: const Text('Enter Language Map'),
            content: TextField(
              cursorColor: AppConstants.PRIMARY_COLOR,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusColor: Theme.of(context).primaryColor,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppConstants.PRIMARY_COLOR, width: 2))),
              controller: textEditingController,
              minLines: 5,
              maxLines: 5,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  try {
                    onSubmit!(json.decode(textEditingController.text));
                    Navigator.of(context).pop();
                  } catch (e) {}
                },
              ),
            ],
          );
        });
  }
}
