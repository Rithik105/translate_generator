import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:translate_generator/providers/language_provider.dart';
import 'package:translate_generator/ui/widgets/custom_button.dart';
import 'package:translate_generator/ui/widgets/file_choose_widget.dart';
import 'package:translate_generator/utils/app_constants.dart';
import 'package:translate_generator/utils/app_utils.dart';

class FileUpdateTab extends StatefulWidget {
  FileUpdateTab({super.key});

  @override
  State<FileUpdateTab> createState() => _FileUpdateTabState();
}

class _FileUpdateTabState extends State<FileUpdateTab> {
  Map<String, String>? _tempData;

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
          if (languageProvider.updateTranslatedData.isNotEmpty &&
              languageProvider.translating)
            SizedBox(
                width: 300,
                child: LinearPercentIndicator(
                  animateFromLastPercent: true,
                  percent: languageProvider.progress /
                      languageProvider.updatelanguageData1.length,
                  backgroundColor: Colors.grey,
                  progressColor: const Color(0xff5f37da),
                  barRadius: const Radius.circular(20),
                  animation: true,
                )),
          if (languageProvider.updateTranslatedData.isNotEmpty &&
              languageProvider.translating)
            Text(
                "${((languageProvider.progress / languageProvider.updatelanguageData1.length) * 100).toStringAsFixed(1)}%"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FileChooseWidget(
                onFilePicked: () {
                  AppUtils.onFilePicked(context,
                      onFileSelect: (selectedFile) async {
                    final file = selectedFile!.files.single;
                    languageProvider.translatingComplete = false;
                    languageProvider.updatelanguageData1.clear();
                    languageProvider.updateFileName1 = file.name;
                    languageProvider.updatelanguageData1 = Map.from(
                        json.decode(String.fromCharCodes(file.bytes!)));
                    _tempData = null;
                    setState(() {});
                  });
                },
                hintText: languageProvider.updateFileName1 ??
                    "Select an English File",
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
                    AppUtils.showCustomDialog(context,
                        initialData: _tempData != null
                            ? _tempData.toString()
                            : "", onSubmit: (data) {
                      _tempData = Map.castFrom(data);
                      languageProvider.updateFileName1 = null;
                      languageProvider.updatelanguageData1 = _tempData!;
                      setState(() {});
                    });
                  }),
              const SizedBox(
                width: 20,
              ),
              (_tempData != null && _tempData!.isNotEmpty)
                  ? Icon(
                      Icons.done,
                      color: AppConstants.PRIMARY_COLOR,
                    )
                  : SizedBox()
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          FileChooseWidget(
            onFilePicked: () {
              AppUtils.onFilePicked(context,
                  onFileSelect: (selectedFile) async {
                final file = selectedFile!.files.single;
                languageProvider.translatingComplete = false;
                languageProvider.updatelanguageData2 = '';
                languageProvider.updateFileName2 = file.name;
                languageProvider.updatelanguageData2 =
                    await file.xFile.readAsString();
                _tempData = null;
                setState(() {});
              });
            },
            hintText:
                languageProvider.updateFileName2 ?? "Select File to Update",
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
              value: languageProvider.updateSelectedLocale.languageCode,
              onChanged: (String? newValue) {
                Provider.of<LanguageProvider>(context, listen: false)
                    .updateTranslatedData
                    .clear();
                languageProvider.updateSelectedLocale = Locale(newValue!);
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
              onPressed: (languageProvider.updatelanguageData1.isEmpty ||
                      (languageProvider.updatelanguageData2?.isEmpty ?? true))
                  ? null
                  : () {
                      if (languageProvider.translating) {
                        languageProvider.stopTranslate();
                      } else {
                        languageProvider.updateFileTranslate();
                      }
                    }),
          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  languageProvider.updateTranslatedData.isEmpty
                      ? "Please choose a file to translate"
                      : (languageProvider.translating)
                          ? "Translating..... please wait"
                          : "Your file is ready for download",
                ),
                if (languageProvider.updateTranslatedData.isNotEmpty &&
                    !languageProvider.translating)
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomButton(
                        onPressed: () {
                          languageProvider.downloadUpdateFile();
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
