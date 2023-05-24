import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/Current_data.dart';

class Services {
  static const String url = 'https://jsonplaceholder.typicode.com/users';

  static Future<List<CurrrentData>> getCurrentData() async {
    try {
      // final response = await http.get(Uri.parse(url));
      // if (response.statusCode == 200) {
      //   List<CurrrentData> list = parseCurrentData(response.body);
      //   return list;
      // } else {
      //   throw Exception('Error');
      // }
      List<CurrrentData> list = [];
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<CurrrentData> parseCurrentData(String responseBody) {
    final parser = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parser
        .map<CurrrentData>((json) => CurrrentData.fromJson(json))
        .toList();
  }
}
