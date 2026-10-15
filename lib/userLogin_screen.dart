import 'package:flutter/material.dart';
import 'package:final_project/homePage.dart';
import 'package:final_project/userSignup_screen.dart';
import 'package:final_project/forgot_password.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  Future<void> loginUser() async {
  final url = Uri.parse('https://mobilebanking-bankend-node-js.onrender.com/login');

  final body = jsonEncode({
    'username': userController.text,
    'password': passwordController.text,
  });

  final res = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login Successful!")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage( username: data['username'], userId: data['userID'])),
    );
  } else if(res.statusCode == 400){
    final error = jsonDecode(res.body)['error'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }else if (res.statusCode == 401) {
    final error = jsonDecode(res.body)['error'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login Failed")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
            )),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              children: [
                SizedBox(height:40),
                Image.asset('assets/images/logo.png',
                  height: 200, width: 200,),
                SizedBox(height:25),
                Text('Welcome Back!!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                  )),
                SizedBox(height:50),
                TextFormField(
                  controller: userController,
                  style:TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'UserName/Phone',
                    labelStyle: TextStyle(color: Colors.white60),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white70),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))
                  ),
                ),
                SizedBox(height:20),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style:TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white60),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white70),
                    isDense: true,
                    suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                        obscurePassword = !obscurePassword;
                        });
                      },),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: Colors.white),
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                         onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PasswordReset()),
                          );
                         },
                         child: Text(
                          'Forgot Password?',
                          style: TextStyle(color:Colors.lightBlueAccent)),
                      )                     
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () async{
                        await loginUser();
                      },
                      child: const Text("Log In"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13, 
                      )),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupPage()),
                          );
                        },
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                          )
                        )
                      )                     
                    ],
                  ),
                ),
            ]),
          ),)
      ),
    );
  }
}