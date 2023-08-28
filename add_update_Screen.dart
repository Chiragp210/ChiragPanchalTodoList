import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/Home.dart';
import 'package:todolist/db_handler.dart';

import 'model.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDis;
  String? todoDT;
  bool? update;

  AddUpdateTask({
    this.todoId,
    this.todoTitle,
    this.todoDis,
    this.todoDT,
    this.update
  });

  @override
  State<StatefulWidget> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> datalist;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  localData() async{
    datalist =dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final disController = TextEditingController(text: widget.todoDis);
    String appTitle;
    if(widget.update == true){
      appTitle = "Update Task";
    }
    else{
      appTitle = "Add Task";
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 100),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: titleController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Note Title",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter some text";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 5,
                              controller: disController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Note Description",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter some text";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          color: Colors.lightGreen,
                          child: InkWell(
                            onTap: () {
                              if (_formkey.currentState!.validate()) {
                                if(widget.update==true){
                                  dbHelper!.update(TodoModel(
                                      title: titleController.text,
                                      dis: disController.text,
                                      id: widget.todoId,
                                    datetime: widget.todoDT
                                  ));
                                }
                                else{
                                  dbHelper!.insert(TodoModel(
                                      title: titleController.text,
                                      dis: disController.text,
                                      datetime: DateFormat('yMd')
                                          .add_jm()
                                          .format(DateTime.now())
                                          .toString()));
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                                titleController.clear();
                                disController.clear();
                                print("Data added");
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 55,
                              width: 120,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: Text("Submit"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
