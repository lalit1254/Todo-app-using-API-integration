import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDoPage extends StatefulWidget {
  //we added final Map? todo; and this.todo, so that AddToDoPage behaves like the edit page
  final Map? todo;
  const AddToDoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
//here we have decalared a variable which is by default false
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      //here we write below code so that when todo! = null it will show its content prefilled while editing
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
      //here we did this so that if we are going using edit button isEdit will be true
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(isEdit ? 'Edit ToDo' : 'Add ToDo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 7,
            maxLines: 50,
          ),
          SizedBox(
            height: 45,
          ),
           SizedBox(
            height: 50,
            width: 50,
            child: ElevatedButton(
              
              onPressed: isEdit ? updateData : submitData,
              
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(isEdit ? 'Update' : 'Submit',style: TextStyle(fontSize: 19, ),)
                  
                  ),
                  style: ElevatedButton.styleFrom(
                     elevation: 10, 
                    //side: BorderSide(width:6, color:Colors.black), 
                    shape: RoundedRectangleBorder( //to set border radius to button
                  borderRadius: BorderRadius.circular(15)
              ),
              primary: Colors.deepOrangeAccent
              
              ),
              
              
          
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    //get the data from
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });
      if (response.statusCode == 200) {
      titleController.text = '';
      descriptionController.text = '';
      // showSuccessMessage('Creation success');
    } else {
      // showErrorMessage('Creation failed');
    }
  }
  
  Future<void> submitData() async {
    //get the data from
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    //submit data to server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });
    //show success or fail message based on status
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      // showSuccessMessage('Creation success');
    } else {
      // showErrorMessage('Creation failed');
    }
  }
}

//   void showSuccessMessage(String message) {
//     final snackBar = SnackBar(content: Text(message));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   void showErrorMessage(String message) {
//     final snackBar = SnackBar(content: Text(message));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
