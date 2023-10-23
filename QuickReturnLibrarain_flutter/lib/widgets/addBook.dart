import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  var bookidc = TextEditingController();
  var conditionc = TextEditingController();
  var categoryc = TextEditingController();
  final formkey = GlobalKey<FormState>();
  var bookid = "";
  var condition = "";
  var category = "";
  bool isuploading = false;

  void onadd() async {
    bool isvalidate = formkey.currentState!.validate();

    final response;
    if (isvalidate) {
      formkey.currentState!.save();
    } else {
      return;
    }

    try {
      setState(() {
        isuploading = true;
      });
      response = await http.post(
          Uri.parse("https://arcanists-04-3jz1.onrender.com/api/v1/createbook"),
          body: {
            "bookid": bookid,
            "condition": condition,
            "category": category
          });
    } catch (e) {
      return;
    }
    var message = "";
    var data = jsonDecode(response.body);
    print(data);
    setState(() {
      isuploading = false;
    });

    if (response.statusCode == 200) {
      message = "Book Added Successfully";
    } else if (response.statusCode == 404) {
      message = data["message"];
    }
    print(response.statusCode);
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
    bookidc.clear();
    conditionc.clear();
    categoryc.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Add New Book ",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: bookidc,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Cannot be empty";
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
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: conditionc,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Cannot be empty";
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
              ),
            ]),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: categoryc,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Cannot be empty";
                }
                return null;
              },
              onSaved: (newValue) {
                category = newValue!;
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
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50),
                  shadowColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  foregroundColor: Color.fromARGB(255, 45, 146, 255)),
              onPressed: onadd,
              child: isuploading == true
                  ? const SpinKitCircle(
                      color: Colors.white,
                      size: 30,
                    )
                  : const Text(
                      "ADD",
                      style: TextStyle(fontSize: 20),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
