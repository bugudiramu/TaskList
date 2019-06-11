import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManagement {
  storeNewUser(user, context) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      // 'password': user.password,
      'uid': user.uid,
    }).then((val) {
      // Removing the back button in appbar(removing the todoscreen page from the stack when we click the logout button therefore user can't go back )
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/todoscreen');
    }).catchError((e) {
      print(e);
    });
  }
}
