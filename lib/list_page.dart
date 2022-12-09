import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ListPage extends StatefulWidget {
  const ListPage({ Key? key }) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List objects = <dynamic>[];

  Future <void> getData() async { 
    final uri=Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=10');
    final response = await http.get(uri);
    print(response.statusCode);
    final json = convert.jsonDecode(response.body) as Map;
    final values = json['items'] as List;
    setState(() {
      objects = values;
    });
  }

  Future<void> deleteData(String id)async{
    final uri = Uri.parse('https://api.nstack.in/v1/todos/$id');
    await http.delete(uri);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Todo'),
      ),
      body: RefreshIndicator(
        onRefresh: getData,
        child: ListView.builder(
          itemCount: objects.length,
          itemBuilder: (context,index){
          var property = objects[index] as Map;
          var id = property['_id'] as String;
          //var allValues = property['items'];
          var nameValue = property['title'];
          var numValue = property['description'];
          return Dismissible(
          key: UniqueKey(),
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('$nameValue'),
            subtitle: Text('$numValue'),
          ),
          onDismissed: (direction) {
            setState(() {
              if(direction == DismissDirection.startToEnd){
                deleteData(id);
                objects.removeAt(index);
              }
            });
          },
          );
        }),
      ),
    );
  }
}