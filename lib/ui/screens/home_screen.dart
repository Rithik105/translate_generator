import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:translate_generator/providers/language_provider.dart';
import 'package:translate_generator/ui/tabs/file_generate_tab.dart';
import 'package:translate_generator/ui/tabs/file_update_tab.dart';
import 'package:translate_generator/ui/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // void onFilePicked(BuildContext context, bool file1) {
  //   FilePicker.platform
  //       .pickFiles(
  //           type: FileType.custom,
  //           allowedExtensions: ['json'],
  //           allowMultiple: false)
  //       .then((pickerResult) async {
  //     if (pickerResult != null) {
  //       final file = pickerResult.files.single;
  //       if (file1) {
  //         Provider.of<LanguageProvider>(context, listen: false)
  //             .translatingComplete = false;
  //         Provider.of<LanguageProvider>(context, listen: false)
  //             .translatedData
  //             .clear();
  //         Provider.of<LanguageProvider>(context, listen: false).fileName1 =
  //             file.name;
  //         Provider.of<LanguageProvider>(context, listen: false).languageData =
  //             Map.from(json.decode(String.fromCharCodes(file.bytes!)));
  //       } else {
  //         Provider.of<LanguageProvider>(context, listen: false)
  //             .translatingComplete = false;
  //         Provider.of<LanguageProvider>(context, listen: false)
  //             .translatedData
  //             .clear();
  //         Provider.of<LanguageProvider>(context, listen: false).fileName2 =
  //             file.name;

  //         Provider.of<LanguageProvider>(context, listen: false).languageData2 =
  //             await file.xFile.readAsString();
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Translation File Generator",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TabBar(
                onTap: (value) {
                  _tabIndex = value;
                  setState(() {});
                },
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: const Color(0xff5f37da),
                unselectedLabelColor: Colors.grey,
                labelColor: const Color(0xff5f37da),
                tabs: const [
                  Tab(
                    child: Text(
                      "FILE GENERATE",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "FILE UPDATE",
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: !languageProvider.translating
                    ? Image.asset(
                        "assets/images/logo.gif",
                      )
                    : Image.asset("assets/animations/translating.gif"),
              ),
              if (languageProvider.genearetLanguageData.isNotEmpty &&
                  languageProvider.translating)
                SizedBox(
                    width: 300,
                    child: LinearPercentIndicator(
                      animateFromLastPercent: true,
                      percent: languageProvider.progress /
                          languageProvider.genearetLanguageData.length,
                      backgroundColor: Colors.grey,
                      progressColor: const Color(0xff5f37da),
                      barRadius: const Radius.circular(20),
                      animation: true,
                    )),
              if (languageProvider.genearetLanguageData.isNotEmpty &&
                  languageProvider.translating)
                Text(
                    "${((languageProvider.progress / languageProvider.genearetLanguageData.length) * 100).toStringAsFixed(1)}%"),
              _tabIndex == 0
                  ? ChangeNotifierProvider.value(
                      value: languageProvider, child: const FileGenerateTab())
                  : const FileUpdateTab(),
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
                    Provider.of<LanguageProvider>(context, listen: false)
                        .translatedData
                        .clear();
                    languageProvider.setLocale = Locale(newValue!);
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
                  onPressed: languageProvider.genearetLanguageData.isEmpty
                      ? null
                      : () {
                          if (languageProvider.translating) {
                            languageProvider.stopTranslate();
                          } else {
                            languageProvider.translate();
                          }
                        }),
              SizedBox(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ((languageProvider.translatedData.isEmpty &&
                                  _tabIndex == 0) ||
                              (_tabIndex == 1 &&
                                  (languageProvider
                                          .updatelanguageData1?.isEmpty ??
                                      true)))
                          ? "Please choose a file to translate"
                          : ((languageProvider.translatedData.isEmpty &&
                                  _tabIndex == 1))
                              ? "Please choose a file to translate"
                              : (languageProvider.translating)
                                  ? "Translating..... please wait"
                                  : "Your file is ready for download",
                    ),
                    if (_tabIndex == 0)
                      if (languageProvider.translatedData.isNotEmpty &&
                          !languageProvider.translating)
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CustomButton(
                              onPressed: () {
                                languageProvider.downloadFile(_tabIndex);
                              },
                              title: "Download",
                            )),
                    if (_tabIndex == 1)
                      languageProvider.translatingComplete
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomButton(
                                onPressed: () {
                                  languageProvider.downloadFile(_tabIndex);
                                },
                                title: "Download",
                              ))
                          : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
