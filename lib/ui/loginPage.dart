import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:task_list/ui/taskListScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                shrinkWrap: true,
                scrollDirection: Axis.vertical,

                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/icon.png',
                    height: 100.0,
                    width: 100.0,
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
                          return "Password atleast have 6 characters";
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
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                    onPressed: () {
                      signIn();
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                      child: Text("Don't have an account ?",
                          style: TextStyle(fontSize: 16.0))),
                  SizedBox(
                    height: 15.0,
                  ),
                  RaisedButton(
                    color: Color(0xFFF44336),
                    elevation: 6.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100.0, vertical: 15.0),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Text(
                      "SignUp",
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    elevation: 6.0,
                    color: Color(0xFFF44336),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100.0, vertical: 15.0),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Text(
                      "Login as Guest",
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/todoscreen');
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

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((FirebaseUser user) {
        print(user.email);
        Navigator.of(context).pop();
        // Removing the back button in appbar(removing the todoscreen page from the stack when we click the logout button therefore user can't go back )
        Navigator.of(context).pushReplacementNamed('/todoscreen');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen()));
      }).catchError((e) {
        print(e);
      });
    }
  }
}
