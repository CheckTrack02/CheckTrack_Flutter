import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<int> fetchUser(String user_id, String user_pw) async {
  var url = 'http://172.10.5.144:80/login';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
    "user_id": user_id,
    "user_pw": user_pw
    }),
  );

  return response.statusCode;
}
