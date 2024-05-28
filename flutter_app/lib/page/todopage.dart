import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/to_do.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late Future<List<ToDo>> futureToDo;

  @override
  void initState() {
    super.initState();
    futureToDo = fetchToDo();
  }

  Future<List<ToDo>> fetchToDo() async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/todos?_start=0&_limit=10'));

    if (response.statusCode == 200) {
      return toDoFromJson(response.body);
    } else {
      throw Exception('Failed to load to-dos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: FutureBuilder<List<ToDo>>(
        future: futureToDo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada to-do list"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle:
                      Text('Completed: ${snapshot.data![index].completed}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
