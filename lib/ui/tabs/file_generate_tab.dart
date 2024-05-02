import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translate_generator/providers/language_provider.dart';

import '../../utils/app_utils.dart';
import '../widgets/file_choose_widget.dart';

class FileGenerateTab extends StatelessWidget {
  const FileGenerateTab({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context);
    print(languageProvider.progress);
    return FileChooseWidget(
      onFilePicked: () {
        AppUtils.onFilePicked(context, onFileSelect: (selectedFile) async {});
      },
      hintText: "Select an English File",
    );
  }
}
