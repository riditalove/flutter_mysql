import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> insertrecord() async {
    if (email.text != "" || password.text != "") {
      try {
        String uri = 'http://10.0.2.2/mysql/lib/insert_record.php';
        var res = await http.post(Uri.parse(uri), body: {
          "email": email.text,
          "password": password.text,
        });
        var respone = jsonDecode(res.body);
        if (respone["success"] == "true") {
          print("Record inserted");
        } else {
          print("issue");
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Employee Dashboard",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Your Email",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Your password",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    insertrecord();
                  },
                  child: Icon(Icons.login),
                ),
              ),
            ],
          ),
        ));
  }
}
