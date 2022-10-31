import 'package:demo_1/screens/home_screen.dart';
import 'package:demo_1/screens/login_screen.dart';
import 'package:demo_1/sqlight_database/db_helper.dart';
import 'package:flutter/material.dart';

import 'modals/user_modal.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();


  User? user = await DatabaseHelper().getCurrentUser();

  runApp( MyApp(user: user,));
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({super.key,this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            //padding: MaterialStateProperty.all(EdgeInsets.all(10)),
            shape: MaterialStateProperty.all( RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(10)
            )),
            minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50))
          ),


        ),
        inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
        borderRadius:  BorderRadius.all(
         Radius.circular(10.0),
    ),
    borderSide: BorderSide(
    color: Colors.black,
    width: 1.0,
    ),
        ))),

      home: user ==null? LoginScreen():HomeScreen(user: user!),
    );
  }
}
