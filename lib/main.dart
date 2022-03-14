import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:today_work_firebase/screens/homescreen.dart';
import 'package:today_work_firebase/screens/loginscreen.dart';
import 'package:today_work_firebase/screens/signup.dart';
import 'package:today_work_firebase/screens/tasks_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserinfo();
  }

  Future<void> getUserinfo() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final prefs = await SharedPreferences.getInstance();
    //  await prefs.setString('action', 'Start');
    final String? eMail = prefs.getString('email');
    final String? pAss = prefs.getString('password');
    if (eMail != null && pAss != null) {
      try {
        final response = await _auth.signInWithEmailAndPassword(
            email: eMail, password: pAss);
        if (response != null) {
          Navigator.pushNamed(context, TasksScreen.id);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        HomePage.id: (context) => HomePage(),
        LoginScreen.id: (context) => const LoginScreen(),
        TasksScreen.id: (context) => TasksScreen(),
        SignUpScreen.id: (context) => SignUpScreen()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: TasksScreen(),
      home: HomePage(),
    );
  }
}
