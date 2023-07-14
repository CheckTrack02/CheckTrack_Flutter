import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:checktrack/db/GroupEntity.dart';
import 'package:checktrack/db/UserEntity.dart';

const int PORT_NO = 80;
const String httpUrl = "http://172.10.5.144:${PORT_NO}";

class APISystem{
  static Future<dynamic> getResponse(String httpPath, String queryType, data) async{
    final String url = httpUrl + httpPath;
    if(queryType == "GET"){
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type' : 'application/json',
        },
      );
      return response;
    }
    if(queryType == "POST"){
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type' : 'application/json',
        },
        body: jsonEncode(data),
      );
      return response;
    }
    return null;
  }
}

class UserAPISystem{
  static Future<int> fetchUser(String user_id, String user_pw) async {
    final response = await APISystem.getResponse("/login", "POST", {
      "user_id": user_id,
      "user_pw": user_pw
    });
    return response.statusCode;
  }
}

class GroupAPISystem{
  static Future<GroupEntity> getGroupEntity(int groupNo) async{
    final response = await APISystem.getResponse("/group/get-group/groupNo=${groupNo}", "GET", null);
    return GroupEntity(
      groupBookNo: jsonDecode(response.body)['groupBookNo'], 
      groupEndDate: DateTime.parse(jsonDecode(response.body)['groupEndDate']), 
      groupNo: jsonDecode(response.body)['groupNo'], 
      groupName: jsonDecode(response.body)['groupName'], 
      groupStartDate: DateTime.parse(jsonDecode(response.body)['groupStartDate'])
    );
  }
}





<<<<<<< HEAD
  return response.statusCode;
}
=======
>>>>>>> 891a3ca7debb453444dcd54bb36a6e2c3e80cd3c
