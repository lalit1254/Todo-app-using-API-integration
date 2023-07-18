import 'dart:convert';

import 'package:flutter/material.dart';

import 'add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {

  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          centerTitle: false,
          title: Text(
            'Todo List', style: TextStyle(  color: Colors.white,),  textScaleFactor: 1.1,
          ),
        ),
        body: Visibility(
          visible: isLoading,
          child: Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrangeAccent,
              ),
                   
            ),
        //     Image.asset("assets/images/todo.png") 
            
          
          replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: Visibility(
              visible: items.isNotEmpty,
              replacement: Center(child: Text('No Todo Items', textScaleFactor: 1.1,)),
              child: ListView.builder(
                itemCount: items.length,
              padding: EdgeInsets.all(4),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  //for extracting id from todo
                  final id = item['_id'] as String;
                  return GestureDetector(
                    onTap: () {
                      navigateToEditPage(item);
                    },
                    child: Card(
                      color: Color.fromARGB(255, 250, 243, 243),
                      child: ListTile(
                        //leading: CircleAvatar(child: Text('${index + 1}',), radius: 17,),
                        title: Text(item['title']),
                     subtitle: Text(item ['description']),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'edit') {
                              navigateToEditPage(item);
                            } else if (value == 'delete') {
                              //id for deleting
                              deleteById(id);
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: Text('Edit'),
                                value: 'edit',
                              ),
                              PopupMenuItem(
                                child: Text('Delete'),
                                value: 'delete',
                              ),
                            ];
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: navigateToAddPage, label: Text('Add +', style: TextStyle(color: Colors.white, fontSize: 20),),  backgroundColor: Colors.deepOrangeAccent,));
  }

  Future<void> navigateToEditPage(Map item) async {
    //here we have given Map item so that navigateToEditPage takes specific item
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(todo:item),
      //here we added todo:item to take those items
    );
   await Navigator.push(context, route);
   setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(),
    );
    await Navigator.push(context, route);
    // here we added future and async and await  and setstate and fetch todo just to : when we come back after adding 
    // the page refresh itself itseld and loads all items.
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    //delete the item
    //remove the item from list
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      //here data will be already deleted.
      //we write this code to show all other data that are not deleted to fast load after deleting
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //error
    }
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
