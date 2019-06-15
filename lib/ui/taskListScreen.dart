import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoScreen extends StatefulWidget {
  final FirebaseUser user;
  TodoScreen({Key key, this.user});
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  FirebaseUser user;

  final _cloudFirestore = Firestore.instance.collection('todos').snapshots();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _textController = TextEditingController();
  final uid = Firestore.instance.collection('users').document().documentID;
  bool active = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5.0,
        backgroundColor: Color(0xEEF44336),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              print("Icon Tapped!!!!");
            },
            child: Image.asset(
              'images/icon.png',
              height: 100.0,
              width: 100.0,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "TaskList",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.66),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Text(
                  "LogOut",
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  logOut();
                },
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: _cloudFirestore,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                return Container(
                  child: Dismissible(
                    resizeDuration: Duration(milliseconds: 1000),
                    secondaryBackground: Card(
                      elevation: 6.0,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Container(
                        // color: Colors.black26,
                        padding: EdgeInsets.all(18.0),
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {},
                          color: Colors.redAccent,
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    ),
                    background: Card(
                      elevation: 6.0,

                      // shape: BeveledRectangleBorder(
                      //     borderRadius: BorderRadius.circular(50.0)),
                      child: Container(
                        // color: Colors.black26,
                        padding: EdgeInsets.all(18.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Delete",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    key: Key(Firestore.instance
                        .collection('users')
                        .document()
                        .documentID),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Center(
                              child: ListTile(
                                onTap: () {
                                  print("List tile tapped!");
                                  print(Firestore.instance
                                      .collection('todos')
                                      .document());
                                },
                                leading: CircleAvatar(
                                  child: Text(
                                    ds['task'][0].toString().toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  ds['task'].toString(),
                                  style: TextStyle(),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Created on 05/04/2018"),
                                ),
                                trailing: IconButton(
                                  color: Colors.redAccent,
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    print("${ds['task']} is deleted");
                                    Firestore.instance
                                        .collection('todos')
                                        .document(ds.documentID)
                                        .delete();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      print("${ds['task']} is deleted");
                      Firestore.instance
                          .collection('todos')
                          .document(ds.documentID)
                          .delete();
                      // Working on showing snackbar when an item is deleted
                      // Scaffold.of(context).showSnackBar(SnackBar(
                      //   content: Text(ds['task'].toString()),
                      //   action: SnackBarAction(
                      //     label: "Undo",
                      //     onPressed: () {
                      //       Firestore.instance.collection('todos').add({
                      //         'task': ds['task'] == null
                      //             ? CircularProgressIndicator()
                      //             : ds['task'].toString()
                      //       });
                      //     },
                      //   ),
                      // ));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 9.0,
        child: Icon(Icons.add),
        // backgroundColor: Colors.redAccent,
        backgroundColor: Color(0xFFF44336),
        onPressed: () {
          _showFormDialog();
        },
        tooltip: "Add Item",
      ),
    );
  }

  _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Form(
            key: _formkey,
            child: Expanded(
              child: ListTile(
                title: TextFormField(
                  controller: _textController,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter something!';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Enter A Todo",
                    labelText: "Item",
                    icon: Icon(Icons.event_note),
                  ),
                  autofocus: true,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Save"),
          onPressed: () {
            if (_formkey.currentState.validate()) {
              _handleSubmit();

              _textController.clear();

              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );

    showDialog(
        context: context, builder: (_) => alert, barrierDismissible: false);
  }

  void _handleSubmit() {
    if (Firestore.instance.collection('todos').document() == null) {
      Firestore.instance.collection('todos').document().setData({"task": ""});
    } else {
      Firestore.instance
          .collection('todos')
          .document()
          .setData({'task': _textController.text.toString()});
      debugPrint("Item added");
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut().then((val) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/');
    }).catchError((e) {
      print(e);
    });
  }
}
