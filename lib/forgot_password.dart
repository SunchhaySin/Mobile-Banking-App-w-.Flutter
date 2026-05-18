import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<StatefulWidget> createState() {
    return PasswordResetState();
  }
}

class PasswordResetState extends State<PasswordReset> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscurePassword = true;

  Future<void> resetPassword() async {
    if (passwordController.text != _passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    final url = Uri.parse('https://mobilebanking-bankend-node-js.onrender.com/password_reset');

    final body = jsonEncode({
      'username': userController.text,
      'newPassword': passwordController.text,
    });
    final res = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successful!')),
      );
    } else {
      final data = jsonDecode(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['error'] ?? 'Reset failed')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
            ))),
          Positioned(
            top: 40,
            left:10,
            child: IconButton(
              icon:  Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              }
            )
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 150),
                  Text(
                    'Password Reset',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Icon(Icons.security, size: 120, color: Colors.white),
                  SizedBox(height: 40),
                  Text(
                    'Please enter your Username and new Password',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: userController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'UserName',
                      labelStyle: TextStyle(color: Colors.white60),
                      hintText: 'Enter your Username',
                      hintStyle: TextStyle(color: Colors.white70),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      )
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: Colors.white60),
                      hintText: 'Enter your new Password',
                      hintStyle: TextStyle(color: Colors.white70),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
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
                        Icons.vpn_key,
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: obscurePassword,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Re-Enter Password',
                      labelStyle: TextStyle(color: Colors.white60),
                      hintText: 'Re-Enter your Password',
                      hintStyle: TextStyle(color: Colors.white70),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      prefixIcon: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(40.0),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async{
                          await resetPassword();
                        },
                        child: const Text("Save Password"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ])
    );
  }
}