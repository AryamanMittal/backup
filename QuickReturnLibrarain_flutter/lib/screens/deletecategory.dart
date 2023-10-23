import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Deletecategory extends StatefulWidget {
  const Deletecategory({super.key});

  @override
  State<Deletecategory> createState() => _DeletecategoryState();
}

class _DeletecategoryState extends State<Deletecategory> {
  var catrgory = "";
  final formkey = GlobalKey<FormState>();
  bool isuploading = false;
  void ondelete() async {
    var isvalid = formkey.currentState!.validate();

    if (isvalid) {
      formkey.currentState!.save();
    } else {
      return;
    }
    var response;
    try {
      setState(() {
        isuploading = true;
      });
      response = await http.delete(
          Uri.parse(
              "https://arcanists-04-3jz1.onrender.com/api/v1/deletebookcategory"),
          body: {"name": catrgory});
    } catch (e) {
      return;
    }

    var data = jsonDecode(response.body);

    setState(() {
      isuploading = false;
    });
    print(data);
    var message = "";
    if (response.statusCode == 200) {
      Navigator.pop(context);
      message = "Category Deleted Successfully";
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
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Delete Category ",
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
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cannot be empty";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  catrgory = newValue!;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(20),
                  hoverColor: Colors.blue,
                  label: const Text(
                    "Category",
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
                onPressed: ondelete,
                child: isuploading == true
                    ? SpinKitCircle(
                        color: Colors.white,
                        size: 30,
                      )
                    : const Text(
                        "Delete",
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
