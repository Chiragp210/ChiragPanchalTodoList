import 'package:flutter/material.dart';
import 'package:todolist/db_handler.dart';

import 'add_update_Screen.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("To-Do List"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                    future: dataList,
                    builder:
                        (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                      if (!snapshot.hasData || snapshot == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data!.length == 0) {
                        return const Center(
                          child: Text(
                            "No Tasks Found",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        );
                      }
                      else {
                        return ListView.builder(shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index){
                          int todoId = snapshot.data![index].id!.toInt();
                          String todoTitle = snapshot.data![index].title.toString();
                          String todoDis = snapshot.data![index].dis.toString();
                          String todoDT = snapshot.data![index].datetime.toString();
                          return Dismissible(key: ValueKey<int>(todoId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.redAccent,
                                child: Icon(Icons.delete_forever, color: Colors.white),
                              ),
                          onDismissed: (DismissDirection direction){
                            setState(() {
                                dbHelper!.delete(todoId);
                                dataList = dbHelper!.getDataList();
                                snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.yellow.shade300,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 1
                                ),
                              ]),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.all(10),
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        todoTitle,style: TextStyle(fontSize: 19),
                                      ),
                                    ),
                                    subtitle: Text(
                                      todoDis,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 0.8,
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(todoDT,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context,MaterialPageRoute(builder: (cotext) =>
                                          AddUpdateTask(
                                            todoId: todoId,
                                            todoTitle: todoTitle,
                                            todoDis: todoDis,
                                            todoDT: todoDT,
                                            update: true,
                                          ),
                                        ));
                                      },
                                      child: Icon(Icons.edit_note, size: 28,color: Colors.green,),

                                    )
                                    ],
                                  ),
                                  )
                                ],
                              ),
                            ),
                          );
                            });
                      }
                    })
            )
          ],
        ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddUpdateTask()),);
      }),

    );
  }
}
