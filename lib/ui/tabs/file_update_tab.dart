import 'package:flutter/material.dart';
import 'package:translate_generator/ui/widgets/custom_button.dart';
import 'package:translate_generator/ui/widgets/file_choose_widget.dart';
import 'package:translate_generator/utils/app_utils.dart';

class FileUpdateTab extends StatelessWidget {
  const FileUpdateTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FileChooseWidget(
              onFilePicked: () {
                AppUtils.onFilePicked(context,
                    onFileSelect: (selectedFile) async {});
              },
              hintText: "Select an English File",
            ),
            const SizedBox(
              width: 20,
            ),
            const Text("or"),
            const SizedBox(
              width: 20,
            ),
            CustomButton(
                title: "Enter Language Map",
                onPressed: () {
                  AppUtils.showCustomDialog(context);
                })
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        FileChooseWidget(
          onFilePicked: () {
            AppUtils.onFilePicked(context,
                onFileSelect: (selectedFile) async {});
          },
          hintText: "Select File to Update",
        )
      ],
    );
  }
}
