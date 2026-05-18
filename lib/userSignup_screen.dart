import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_project/userLogin_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<SignupPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool obscurePassword = true;

  Future<void> registerUser() async {
  final url = Uri.parse('https://mobilebanking-bankend-node-js.onrender.com/register');

  final body = jsonEncode({
    'fName': firstNameController.text,
    'lName': lastNameController.text,
    'username': userController.text,
    'password': passwordController.text,
    'phone': phoneController.text,
  });

  final res = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (res.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registration Successful!")),
    );

    // Navigate to another page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>LoginPage()),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                    'Account Registration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Icon(Icons.aod_outlined, size: 120, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Please fill in the details below to create your account',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width:180,
                          child: TextFormField(
                            controller: firstNameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'First Name',
                              labelStyle: TextStyle(color: Colors.white60),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: SizedBox(
                          width:180,
                          child: TextFormField(
                            controller: lastNameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Last Name',
                              labelStyle: TextStyle(color: Colors.white60),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white60),
                      hintText: 'Enter your Password',
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
                        Icons.lock_outlined,
                        color: Colors.white,
                      ),
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
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phoneController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: Colors.white60),
                      hintText: 'Enter your Phone Number',
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
                        Icons.phone,
                        color: Colors.white,
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(40.0),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async{
                          await registerUser();
                        },
                        child: const Text("Register Account"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
