import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  final url;
  NetworkHelper({required this.url});
  Future getData() async {
    http.Response response = await http.get(url);

    /// statusCode of 200 means everything went well as expected, and the data was received
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("ERROR OCCURED");
      print(response.statusCode);
    }
  }
}
