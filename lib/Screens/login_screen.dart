import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/Screens/mainscreen.dart';
import 'package:uber_clone/main.dart';
import './Singnup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/progressDialogue.dart';

class LogInScreen extends StatelessWidget {
  static const routeName = '/login';
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Container(
                child: Center(
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 390,
                    height: 250,
                  ),
                ),
              ),
              Text('Login as a Rider',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Brand Bold',
                  )),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 14),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    TextField(
                      obscureText: true,
                      controller: _passController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 14),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Colors.yellow,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      onPressed: () {
                        if (_emailController.text.isEmpty ||
                            !_emailController.text.contains('@')) {
                          displaytoastMessage(
                              'Please provide a valid Email address', context);
                        } else if (_passController.text.length < 7) {
                          displaytoastMessage(
                              'Password must be atleast 7 characters', context);
                        } else {
                          logInUser(context);
                        }
                      },
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Brand Bold'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SignUpScreen.routeName);
                  },
                  child: Text(
                    'Dont have an account? Register Here.',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  final _auth = FirebaseAuth.instance;
  logInUser(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProgressDialogue(
            message: 'Authenticating please wait....',
          );
        });
    final User firebaseuser = (await _auth
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passController.text.trim())
            .catchError((err) {
      Navigator.pop(context);
      displaytoastMessage('Error: $err', context);
    }))
        .user;
    if (firebaseuser != null) {
      userRef.child(firebaseuser.uid).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Navigator.of(context).pushNamed(MainScreen.routeName);
          displaytoastMessage('You are logged-in', context);
        } else {
          Navigator.pop(context);
          _auth.signOut();
          displaytoastMessage(
              'No Record exist for this user. Please create a new one.',
              context);
        }
      });
    } else {
      Navigator.pop(context);
      displaytoastMessage('Error occured cannot be signed-in', context);
    }
  }
}
