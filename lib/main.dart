import 'package:flutter/material.dart';
import 'package:task_list/ui/displayUserInfo.dart';
import 'ui/taskListScreen.dart';
import 'ui/loginPage.dart';
import 'ui/signUpPage.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LoginPage(),
        '/todoscreen': (BuildContext context) => TodoScreen(),
        '/signup': (BuildContext context) => SignUpPage(),
        '/userinfo': (BuildContext context) => UserInfo(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
// For Android-X error use multiDexEnabled true in app(build.gradle) defaultConfig {}
// android.useAndroidX=true, android.enable Jetifier=true in gradle.properties
