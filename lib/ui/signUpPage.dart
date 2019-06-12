// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_list/services/userManagement.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF44336),
        title: Text(
          "TaskList",
          style: TextStyle(
              fontSize: 25.0, fontWeight: FontWeight.w700, letterSpacing: 1.66),
        ),
        // leading: Text(""),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.red[500],
                Colors.red[400],
                Colors.red[300],
                Colors.red[200],
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Image.asset(
                    'images/icon.png',
                    height: 100.0,
                    width: 100.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter Your Email",
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please provide a valid Email ID";
                        }
                      },
                      onSaved: (val) {
                        _email = val;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter Your Password",
                      ),
                      validator: (val) {
                        if (val.length < 6) {
                          return "Password must contain atleast 6 characters!";
                        }
                      },
                      onSaved: (val) {
                        _password = val;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    elevation: 6.0,
                    color: Color(0xFFF44336),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100.0, vertical: 15.0),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Text(
                      "SignUp",
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                    onPressed: () {
                      signup();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signup() async {
    final formstate = _formKey.currentState;
    if (formstate.validate()) {
      formstate.save();
      FirebaseUser user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((signedInUser) {
        UserManagement().storeNewUser(signedInUser, context);
      }).catchError((e) {
        print(e.message);
      });
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/');
    }
  }
}
