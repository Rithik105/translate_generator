import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class LanguageProvider with ChangeNotifier {
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
  Locale _generateSelectedLocale = const Locale('en');
  Locale _updateSelectedLocale = const Locale('en');

  bool _translating = false;
  bool _translatingComplete = false;

  final Map<String, String> _generateLanguageData = {};
  final Map<String, String> _updatelanguageData1 = {};
  String? _updatelanguageData2;
  final Map<String, String> _generateTranslatedData = {};
  final Map<String, String> _updateTranslatedData = {};

  double _progress = 0.0;
  String? _downloadedFileName;
  String? _generateFileName;
  String? _updateFileName1;
  String? _updateFileName2;

  bool get translating => _translating;
  set translating(bool value) {
    _translating = value;
    notifyListeners();
  }

  static List<Locale> get supportedLanguages => [..._supportedLanguages];
  Locale get generateSelectedLocale => _generateSelectedLocale;
  set generateSelectedLocale(Locale locale) {
    _generateSelectedLocale = locale;
    notifyListeners();
  }

  Locale get updateSelectedLocale => _updateSelectedLocale;
  set updateSelectedLocale(Locale locale) {
    _updateSelectedLocale = locale;
    notifyListeners();
  }

  Map<String, String> get generateLanguageData => _generateLanguageData;
  set generateLanguageData(Map<String, String> data) {
    _generateLanguageData.clear();
    _generateLanguageData.addAll(data);
    notifyListeners();
  }

  Map<String, String> get updatelanguageData1 => _updatelanguageData1;
  set updatelanguageData1(Map<String, String> data) {
    _updatelanguageData1.clear();
    _updatelanguageData1.addAll(data);
    notifyListeners();
  }

  String? get updatelanguageData2 => _updatelanguageData2;
  set updatelanguageData2(String? data) {
    _updatelanguageData2 = data;
    notifyListeners();
  }

  Map<String, String> get generateTranslatedData => _generateTranslatedData;
  set generateTranslatedData(Map<String, String> data) {
    _generateTranslatedData.clear();
    _generateTranslatedData.addAll(data);
    notifyListeners();
  }

  Map<String, String> get updateTranslatedData => _updateTranslatedData;
  set updateTranslatedData(Map<String, String> data) {
    _updateTranslatedData.clear();
    _updateTranslatedData.addAll(data);
    notifyListeners();
  }

  double get progress => _progress;
  set progress(double value) {
    _progress = value;
    notifyListeners();
  }

  String? get generateFileName => _generateFileName;
  set generateFileName(String? value) {
    _generateFileName = value;
    notifyListeners();
  }

  String? get updateFileName1 => _updateFileName1;
  set updateFileName1(String? value) {
    _updateFileName1 = value;
    notifyListeners();
  }

  String? get updateFileName2 => _updateFileName2;
  set updateFileName2(String? value) {
    _updateFileName2 = value;
    _selectedDefaultLanguageFromFile(_updateFileName2 ?? "");
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
    try {
      _updateSelectedLocale = supportedLanguages
          .firstWhere((element) => element.languageCode == value);
    } catch (e) {
      print(e);
    }
  }

  void generateFileTranslate() async {
    downloadedFileName = _generateSelectedLocale.languageCode;
    progress = 0.0;
    translating = true;

    translatingComplete = false;
    for (var entry in _generateLanguageData.entries) {
      if (!_translating) {
        break;
      }
      Translation processedValue = await entry.value
          .translate(from: 'en', to: _generateSelectedLocale.languageCode);
      _generateTranslatedData[entry.key] = processedValue.text;
      progress = _progress + 1;
    }
    translating = false;
    translatingComplete = true;
    notifyListeners();
  }

  void updateFileTranslate() async {
    downloadedFileName = _updateSelectedLocale.languageCode;
    progress = 0.0;
    translating = true;

    translatingComplete = false;
    for (var entry in _updatelanguageData1.entries) {
      if (!_translating) {
        break;
      }
      Translation processedValue = await entry.value
          .translate(from: 'en', to: _updateSelectedLocale.languageCode);
      _updateTranslatedData[entry.key] = processedValue.text;
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

  void downloadGeneratedFile() {
    downloadJsonFile(jsonEncode(_generateTranslatedData));
  }

  void downloadUpdateFile() {
    if ((updatelanguageData2?.lastIndexOf('}') ?? -1) > 0) {
      updatelanguageData2 =
          ("${updatelanguageData2?.substring(0, updatelanguageData2?.lastIndexOf('}'))},${jsonEncode(_updateTranslatedData).substring(jsonEncode(_updateTranslatedData).indexOf('{') + 1)}");
      downloadJsonFile(updatelanguageData2 ?? "");
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
