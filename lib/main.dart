import 'package:flutter/material.dart';
import './Screens/mainscreen.dart';
import './Screens/login_screen.dart';
import './Screens/Singnup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef = FirebaseDatabase.instance.reference().child('user');

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Driver App',
      theme: ThemeData(
        fontFamily: 'Brand Bold',
        primarySwatch: Colors.blue,
      ),
      initialRoute: MainScreen.routeName,
      routes: {
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        LogInScreen.routeName: (ctx) => LogInScreen(),
        MainScreen.routeName: (ctx) => MainScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
