import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class User {
  final int user_no;
  final String user_id;
  final String user_name;

  User({
    required this.user_no,
    required this.user_id,
    required this.user_name
    });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_no: json['user_no'],
      user_id: json['user_id'],
      user_name: json['user_name'],
    );
  }
}


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