import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class LanguageProvider with ChangeNotifier {
  bool _translating = false;
  static const List<Locale> _supportedLanguages = [
    Locale('en', 'us'),
    Locale('fr', 'fr'),
    Locale('hi', 'in'),
    Locale('ja', 'jp'),
    Locale('ar', 'sa'),
    Locale('es', 'es'),
    Locale('fa', 'ir'),
    Locale('ko', 'kr'),
    Locale('pa', 'in'),
    Locale('pt', 'br'),
    Locale('ru', 'ru'),
    Locale('uk', 'ua'),
    Locale('zh-cn', 'cn'),
    Locale('vi', 'vi'),
  ];
  Locale selectedLocale = const Locale('en');
  final Map<String, String> _languageData = {};
  String? _languageData2;
  final Map<String, String> _translatedData = {};
  double _progress = 0.0;
  String? _downloadedFileName;
  String? _fileName1;
  String? _fileName2;
  bool _translatingComplete = false;

  bool get translating => _translating;
  set translating(bool value) {
    _translating = value;
    notifyListeners();
  }

  static List<Locale> get supportedLanguages => [..._supportedLanguages];
  Locale get selectedLanguage => selectedLocale;
  set setLocale(Locale locale) {
    selectedLocale = locale;
    notifyListeners();
  }

  Map<String, String> get languageData => _languageData;
  set languageData(Map<String, String> data) {
    _languageData.clear();
    _languageData.addAll(data);
    notifyListeners();
  }

  String? get languageData2 => _languageData2;
  set languageData2(String? data) {
    _languageData2 = data;
    notifyListeners();
  }

  Map<String, String> get translatedData => _translatedData;
  set translatedData(Map<String, String> data) {
    _translatedData.clear();
    _translatedData.addAll(data);
    notifyListeners();
  }

  double get progress => _progress;
  set progress(double value) {
    _progress = value;
    notifyListeners();
  }

  String? get fileName1 => _fileName1;
  set fileName1(String? value) {
    _fileName1 = value;
    notifyListeners();
  }

  String? get fileName2 => _fileName2;
  set fileName2(String? value) {
    _fileName2 = value;
    _selectedDefaultLanguageFromFile(_fileName2 ?? "");
    notifyListeners();
  }

  String? get downloadedFileName => _downloadedFileName;
  set downloadedFileName(String? value) {
    _downloadedFileName = value;
    notifyListeners();
  }

  bool get translatingComplete => _translatingComplete;
  set translatingComplete(bool value) {
    _translatingComplete = value;
    notifyListeners();
  }

  void _selectedDefaultLanguageFromFile(String value) {
    value = value.replaceAll(".json", "");
    print(value);
    try {
      selectedLocale = supportedLanguages
          .firstWhere((element) => element.languageCode == value);
    } catch (e) {
      print(e);
    }
  }

  void translate() async {
    downloadedFileName = selectedLanguage.languageCode;
    progress = 0.0;
    translating = true;
    for (var entry in _languageData.entries) {
      if (!_translating) {
        break;
      }
      Translation processedValue = await entry.value
          .translate(from: 'en', to: selectedLanguage.languageCode);
      _translatedData[entry.key] = processedValue.text;
      progress = _progress + 1;
    }
    translating = false;

    translatingComplete = true;
    notifyListeners();
  }

  void stopTranslate() {
    translating = false;
    notifyListeners();
  }

  void downloadFile(int tabIndex) {
    if (tabIndex == 1) {
      if ((languageData2?.lastIndexOf('}') ?? -1) > 0) {
        languageData2 =
            ((languageData2?.substring(0, languageData2?.lastIndexOf('}')) ??
                    "") +
                "," +
                jsonEncode(translatedData)
                    .substring(jsonEncode(translatedData).indexOf('{') + 1));
        downloadJsonFile(languageData2 ?? "");
      }
    } else {
      downloadJsonFile(jsonEncode(translatedData));
    }
  }

  void downloadJsonFile(String jsonString) {
    html.Blob blob = html.Blob([jsonString], 'application/json');
    html.AnchorElement(
      href: html.Url.createObjectUrlFromBlob(blob).toString(),
    )
      ..setAttribute("download", "$downloadedFileName.json")
      ..click();
  }
}
