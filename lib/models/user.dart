import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String id;
  String name;
  String password;
  String email;
  String phone;

  User({this.id, this.name, this.email, this.phone});

  Future<User> save() async {
    final http.Response response = await http.post(
      'https://form-test-app.herokuapp.com/api/addData',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
        'Access-Control-Allow-Origin': '*'
      },
      body: jsonEncode(<String, String>{
        'name': this.name,
        'email': this.email,
        'phone': this.phone,
        'password': this.password
      }),
    );
    print(response.body.toString());
    if (response.statusCode == 201) {
      print("User created Successfully");
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create User');
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'].toString(),
      name: json['user']['name'].toString(),
      email: json['user']['email'].toString(),
      phone: json['user']['phone'].toString(),
    );
  }
}
