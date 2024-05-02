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
              _tabIndex == 0
                  ? ChangeNotifierProvider.value(
                      value: languageProvider,
                      child: const FileGenerateTab(),
                    )
                  : ChangeNotifierProvider.value(
                      value: languageProvider,
                      child: FileUpdateTab(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
