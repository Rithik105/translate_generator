import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:translate_generator/providers/language_provider.dart';
import 'package:translate_generator/ui/widgets/custom_button.dart';
import 'package:translate_generator/utils/app_colors.dart';

import '../../utils/app_utils.dart';
import '../widgets/file_choose_widget.dart';

class FileGenerateTab extends StatelessWidget {
  const FileGenerateTab({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: !languageProvider.translating
                ? Image.asset(
                    "assets/images/logo.gif",
                  )
                : Image.asset("assets/animations/translating.gif"),
          ),
          if (languageProvider.generateTranslatedData.isNotEmpty &&
              languageProvider.translating)
            SizedBox(
                width: 300,
                child: LinearPercentIndicator(
                  animateFromLastPercent: true,
                  percent: languageProvider.progress /
                      languageProvider.generateLanguageData.length,
                  backgroundColor: Colors.grey,
                  progressColor: AppColor.accentColor,
                  barRadius: const Radius.circular(20),
                  animation: true,
                )),
          if (languageProvider.generateLanguageData.isNotEmpty &&
              languageProvider.translating)
            Text(
                "${((languageProvider.progress / languageProvider.generateLanguageData.length) * 100).toStringAsFixed(1)}%"),
          FileChooseWidget(
            onFilePicked: () {
              AppUtils.onFilePicked(context,
                  onFileSelect: (selectedFile) async {
                final file = selectedFile!.files.single;
                languageProvider.translatingComplete = false;
                languageProvider.generateTranslatedData.clear();
                languageProvider.generateFileName = file.name;
                languageProvider.generateLanguageData =
                    Map.from(json.decode(String.fromCharCodes(file.bytes!)));
              });
            },
            hintText:
                languageProvider.generateFileName ?? "Select an English File",
          ),
          const Text(
            "Select the target language",
          ),
          SizedBox(
            height: 50,
            width: 130,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              dropdownColor: Colors.grey,
              value: languageProvider.generateSelectedLocale.languageCode,
              onChanged: (String? newValue) {
                languageProvider.generateTranslatedData.clear();
                languageProvider.generateSelectedLocale = Locale(newValue!);
              },
              items: LanguageProvider.supportedLanguages
                  .map<DropdownMenuItem<String>>((Locale value) {
                return DropdownMenuItem<String>(
                  value: value.languageCode,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/flags/${value.countryCode}.png',
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(value.languageCode),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          CustomButton(
              title: languageProvider.translating ? "Stop" : "Translate",
              onPressed: languageProvider.generateLanguageData.isEmpty
                  ? null
                  : () {
                      if (languageProvider.translating) {
                        languageProvider.stopTranslate();
                      } else {
                        languageProvider.generateFileTranslate();
                      }
                    }),
          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  languageProvider.generateTranslatedData.isEmpty
                      ? "Please choose a file to translate"
                      : (languageProvider.translating)
                          ? "Translating..... please wait"
                          : "Your file is ready for download",
                ),
                if (languageProvider.generateTranslatedData.isNotEmpty &&
                    !languageProvider.translating)
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomButton(
                        onPressed: () {
                          languageProvider.downloadGeneratedFile();
                        },
                        title: "Download",
                      )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
