import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today_work_firebase/screens/tasks_screen.dart';

class SignUpScreen extends StatefulWidget {
  static final id = 'signupinscreen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscure = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  String _name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3.5,
                left: MediaQuery.of(context).size.width / 8),
            child: Column(
              children: [
                SafeArea(
                  child: Row(
                    children: [
                      Text(
                        "SignUp",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      DefaultTextStyle(
                        style:
                            const TextStyle(fontSize: 30, color: Colors.white),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText("to Today Work"),
                          ],
                          isRepeatingAnimation: true,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 17,
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 20),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Enter Name',
                            labelText: "Name",
                            contentPadding: const EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onChanged: (value) {
                          _name = value;
                          // do something
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 35),
                      TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Enter Email',
                            labelText: "Email",
                            contentPadding: const EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onChanged: (value) {
                          _email = value;
                          // do something
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 25),
                      TextField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            labelText: "Password",
                            hintText: 'Enter Password',
                            contentPadding: const EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onChanged: (value) {
                          // do something
                          _password = value;
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 35),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                      color: Colors.lightBlue,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: const Text(
                                  'SignUp',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  UserCredential _cred = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: _email, password: _password);
                                  print(_cred);
                                  FirebaseFirestore.instance
                                      .collection('UsersData')
                                      .doc(_cred.user!.uid)
                                      .set({
                                    "Email": _cred.user!.email,
                                    "Name": _name
                                  });
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'email', _email.toString());
                                  await prefs.setString(
                                      'password', _password.toString());

                                  Navigator.pushNamed(context, TasksScreen.id);
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
