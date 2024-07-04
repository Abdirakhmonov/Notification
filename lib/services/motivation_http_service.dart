import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String url = 'https://type.fit/api/quotes';

  static Future<String> getMotivation() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> motivations = json.decode(response.body);
      motivations.shuffle();
      String motivationText = motivations.first['text'];
      print("Bu mativatsiya:  $motivationText");
      return motivationText;
    } else {
      throw Exception("Ma'lumot olishda muammo bor");
    }
  }
}
