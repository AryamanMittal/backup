import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Updatebook extends StatefulWidget {
  const Updatebook({super.key});

  @override
  State<Updatebook> createState() => _UpdatebookState();
}

class _UpdatebookState extends State<Updatebook> {
  final fkey = GlobalKey<FormState>();
  var bookid = "";
  var condition = "";
  bool isloading = false;

  void onupdate() async {
    var isvalid = fkey.currentState!.validate();
    if (isvalid) {
      fkey.currentState!.save();
    } else {
      return;
    }
    var response;
    try {
      setState(() {
        isloading = true;
      });
      response = await http.put(
          Uri.parse("https://arcanists-04-3jz1.onrender.com/api/v1/updatebook"),
          body: {"bookid": bookid, "condition": condition});
    } catch (e) {
      return;
    }

    var data = jsonDecode(response.body);

    setState(() {
      isloading = false;
    });
    var message = "";
    if (response.statusCode == 200) {
      message = "Book Updated Successfully";
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      message = data["message"];
    }
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
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
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Form(
          key: fkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Update Book ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter all details";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  bookid = newValue!;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(20),
                  hoverColor: Colors.blue,
                  label: const Text(
                    "Book ID",
                    style: TextStyle(color: Color.fromARGB(255, 1, 66, 78)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter all details";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  condition = newValue!;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(20),
                  hoverColor: Colors.blue,
                  label: const Text(
                    "Condition",
                    style: TextStyle(color: Color.fromARGB(255, 1, 66, 78)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50),
                    shadowColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    foregroundColor: Color.fromARGB(255, 45, 146, 255)),
                onPressed: onupdate,
                child: isloading == true
                    ? SpinKitCircle(
                        color: Colors.white,
                        size: 30,
                      )
                    : const Text(
                        "UPDATE",
                        style: TextStyle(fontSize: 20),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
