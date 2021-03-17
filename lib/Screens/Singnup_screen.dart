import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './mainscreen.dart';
import 'package:uber_clone/main.dart';
import './login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/progressDialogue.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signup';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
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
              Text('Register as a Rider',
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontSize: 14),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 3,
                    ),
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
                      keyboardType: TextInputType.emailAddress,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
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
                        if (_nameController.text.length < 4) {
                          displaytoastMessage(
                              'Name must be atleast 4 characters', context);
                        } else if (_emailController.text.isEmpty ||
                            !_emailController.text.contains('@')) {
                          displaytoastMessage(
                              'Please provide a valid Email address', context);
                        } else if (_phoneController.text.isEmpty) {
                          displaytoastMessage(
                              'Phone Number is mandatory', context);
                        } else if (_passController.text.length < 7) {
                          displaytoastMessage(
                              'Password must be atleast 7 characters', context);
                        } else {
                          registerUser(context);
                        }
                      },
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Register',
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
                    Navigator.of(context).pushNamed(LogInScreen.routeName);
                  },
                  child: Text(
                    'Already have an account? Login Here.',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  final _auth = FirebaseAuth.instance;
  registerUser(BuildContext ctx) async {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return ProgressDialogue(
            message: 'Authenticating please wait....',
          );
        });

    User firebaseuser = (await _auth
            .createUserWithEmailAndPassword(
                email: _emailController.text, password: _passController.text)
            .catchError((err) {
      Navigator.pop(ctx);
      displaytoastMessage('Error: $err', ctx);
    }))
        .user;
    if (firebaseuser != null) {
      Map usermap = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim()
      };
      userRef.child(firebaseuser.uid).set(usermap);
      displaytoastMessage(
          'Congratulations Your account has been successfully created', ctx);
      Navigator.of(ctx).pushNamed(MainScreen.routeName);
    } else {
      Navigator.pop(ctx);
      displaytoastMessage('Something went wrong User is not registered', ctx);
    }
  }
}

displaytoastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
