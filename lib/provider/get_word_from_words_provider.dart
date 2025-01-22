import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String wordUrl = 'http://127.0.0.1:8000/word/';

  Future<String> getWord() async {
    final response = await http.get(Uri.parse(wordUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      var word = jsonData['word'];
      return word;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final wordsFromAPIProvider = Provider<ApiService>((ref) => ApiService());

final getWordFromWordsProvider = FutureProvider<String>((ref) async {
  return ref.watch(wordsFromAPIProvider).getWord();
});
