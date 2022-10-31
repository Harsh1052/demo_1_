

import 'package:demo_1/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modals/user_modal.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginNotifier(),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/85568-user-login.gif',width:100,height: 100,),
                  const Text('Login',style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                  ),),
                  const SizedBox(
                    height: 60,
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Name",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Email",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Password",
                    ),
                  ),
                  const SizedBox(
                    height:15
                  ),
                  Consumer<LoginNotifier>(builder: (context, snapshot, child) {
                    return ElevatedButton(
                        onPressed: snapshot.isLoading
                            ? null
                            : () {

                          if(_nameController.text.isEmpty){
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                  content: Text('Enter Valid Name')));
                            return;
                          }
                          if(_emailController.text.isEmpty ||  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text)){
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                  content: Text('Enter Valid Email')));
                            return;
                          }
                          if(_passwordController.text.isEmpty){
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                  content: Text('Enter Valid Password')));
                            return;
                          }
                          if(_passwordController.text.length<8){
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                  content: Text('Enter 8 character minimum')));
                            return;
                          }

                                var data = {
                                  "name": _nameController.text,
                                  "email": _emailController.text,
                                };

                                snapshot.doLogin(data).then((value) {
                                  if (value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomeScreen(
                                                  user: User.fromJson(data),
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                          content: Text('Something Went Wrong')));
                                  }
                                });
                              },
                        child: snapshot.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Login'));
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
