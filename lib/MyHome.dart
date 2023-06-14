import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_rest_api/TestMode.dart';
import 'package:http/http.dart'as http;

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  late Future<List<TestModel>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = getData();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<TestModel>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TestModel>? data = snapshot.data;

            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                TestModel item = data[index];

                return Container(
                  color: Colors.cyan,
                  height: 130,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("UserID: ${item.userId}"),
                      Text("ID: ${item.id}"),
                      Text("Title: ${item.title}",maxLines: 1,),
                      Text("Body: ${item.body}",maxLines: 1,),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Future<List<TestModel>>getData()async{
  //   final response =await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
  //    var data= jsonDecode(response.body.toString());
  //
  //    if(response.statusCode==200){
  //      for(Map<String,dynamic>index in data){
  //        testModel.add(TestModel.fromJson(index));
  //      }return testModel;
  //    }else{
  //      testModel;
  //    }
  // }
  Future<List<TestModel>> getData() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    var data = jsonDecode(response.body.toString());
    print(response.body);
    List<TestModel> testModel = [];

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        testModel.add(TestModel.fromJson(index));
      }
      return testModel;
    } else {
      // Throw an exception or return an empty list based on your requirement
      throw Exception('Failed to fetch data');
      // return []; // Alternatively, return an empty list
    }
  }
}
