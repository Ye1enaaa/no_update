import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_with_api/list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameControl = TextEditingController();
  TextEditingController numControl = TextEditingController();

  Future<void> postData() async {
    final name = nameControl.text;
    final num = numControl.text;
    final body = {
      "title": name,
      "description": num,
      "is_completed": false
    };
    final uri = Uri.parse('https://api.nstack.in/v1/todos');
    final response = await http.post(uri, body: jsonEncode(body),
    headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Page'), centerTitle: true),
      body: Form(
          child: ListView(
        children: [
          TextFormField(
            controller: nameControl,
            decoration: const InputDecoration(
              labelText: "Name",
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter your Name";
              }
            },
          ),
          TextFormField(
            controller: numControl,
            decoration: const InputDecoration(
              labelText: "Number",
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter your Number";
              }
            },
          ),
          SizedBox(
              height: 50,
              child:
                  ElevatedButton(onPressed: ()async{
                    postData();
                    await Navigator.push(context, MaterialPageRoute(builder: (context)=>ListPage()));
                  }, child: const Text('SUBMIT')))
        ],
      )),
    );
  }
}
