import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myscheduler/config/config.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskTxtController = TextEditingController();
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    getUid();
    super.initState();
  }

  void getUid() async {
    FirebaseUser u = await _auth.currentUser();
    setState(() {
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        elevation: 4,
        backgroundColor: primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.person_outline),
                  onPressed: () {
                    _auth.signOut();
                  },
                )
              ])),
      body: Container(
          child: StreamBuilder(
              stream: _db
                  .collection("users")
                  .document(user.uid)
                  .collection("tasks")
                  .orderBy("date", descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.documents.isNotEmpty) {
                    return ListView(
                      children: snapshot.data.documents.map((snap) {
                        return ListTile(
                          title: Text(snap.data["task"]),
                          onTap: () {},
                          trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _db
                                    .collection("users")
                                    .document(user.uid)
                                    .collection("tasks")
                                    .document(snap.documentID)
                                    .delete();
                              }),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container(
                        child: Center(
                      child: Image(image: AssetImage("assets/logo.png"),),
                    ));
                  }
                }
                return Container(
                    child: Center(
                  child: Image(image: AssetImage("assets/logo.png")),
                ));
              })),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
              title: Text("Add Task"),
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      controller: _taskTxtController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Write your task here",
                        labelText: "Task Name",
                      ),
                    )),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(children: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    RaisedButton(
                      color: primaryColor,
                      child: Text("Add"),
                      onPressed: () async {
                        String task = _taskTxtController.text.trim();
                        print(task);

                        _db
                            .collection("users")
                            .document(user.uid)
                            .collection("tasks")
                            .add({
                          "task": task,
                          "date": DateTime.now(),
                        });

                        Navigator.of(ctx).pop();
                      },
                    )
                  ]),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ));
        });
  }
}
