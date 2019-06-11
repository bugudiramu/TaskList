import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firstName =
      Firestore.instance.collection('todos').document().documentID;

      @override 
      void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: _firebaseAuth.currentUser(),
          builder:
              (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // String userID = snapshot.data.uid;
              // _userDetails(userID);
              return new Text(firstName);
            } else {
              return new Text('Loading...');
            }
          },
        ));
  }

//   _userDetails(userID) async {
//     final userDetails = await getData(userID);
//     setState(() {
//       firstName = userDetails.toString();
//       new Text(firstName);
//     });
//   }

//   getData(String userID) async {
//     DocumentSnapshot result =
//         await Firestore.instance.collection('users').document(userID).get();
//     return result;
//   }
// }
}