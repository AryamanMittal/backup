import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:libraryapp/screens/homescreen.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailcontroller;

  var passwordcontroller = "";
  bool islogin = false;

  final formkey = GlobalKey<FormState>();
  List data = [];
  void login() async {
    var isvalidCred = formkey.currentState!.validate();

    if (isvalidCred) {
      formkey.currentState!.save();
    } else {
      return;
    }
    final response;

    try {
      setState(() {
        islogin = true;
      });
      response = await http.post(
          Uri.parse("https://arcanists-04-3jz1.onrender.com/api/v1/adminlogin"),
          body: {"ID": emailcontroller, "key": passwordcontroller});
    } catch (e) {
      print(e.toString());
      return;
    }

    var responsedata = jsonDecode(response.body);
    print(response.statusCode);

    print(responsedata);
    var message = "";
    setState(() {
      islogin = false;
    });
    if (response.statusCode == 403) {
      setState(() {
        message = responsedata["message"];
      });
    }
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        ),
      );
    } else if (response.statusCode == 403) {
      setState(() {
        message = responsedata["message"];
      });
    } else if (response.statusCode == 404) {
      setState(() {
        message = responsedata["message"];
      });
    }
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (response.statusCode == 200) {
      message = "Logged In Successfully";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        ),
      );
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 253, 253),
      body: ListView(
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            height: 100,
            width: 100,
            child: Image.asset("images/image.png"),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              "Welcome Back",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter Correct ID";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        emailcontroller = newValue!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.all(20),
                        hoverColor: Colors.blue,
                        label: Text(
                          "Enter your ID",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 129, 198)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    child: TextFormField(
                      onSaved: (newValue) {
                        passwordcontroller = newValue!;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.all(20),
                        hoverColor: Colors.blue,
                        label: Text(
                          "Enter Password",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 129, 198)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(400, 50),
                        shadowColor: Colors.black,
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        foregroundColor: Color.fromARGB(255, 45, 146, 255)),
                    onPressed: login,
                    child: islogin == true
                        ? SpinKitCircle(
                            color: Colors.white,
                            size: 30,
                          )
                        : const Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
