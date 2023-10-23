import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class BookIssue extends StatefulWidget {
  const BookIssue({super.key});

  @override
  State<BookIssue> createState() => _BookIssueState();
}

class _BookIssueState extends State<BookIssue> {
  final useridc = TextEditingController();
  final book1c = TextEditingController();
  final book2c = TextEditingController();
  final book3c = TextEditingController();
  final book4c = TextEditingController();
  final book5c = TextEditingController();
  var userId = "";
  var book1 = "";
  var book2 = "";
  var book3 = "";
  var book4 = "";
  var book5 = "";
  var dateerror = "";
  bool isuploading = false;
  DateTime? issuedDate;
  DateTime? lastdate;

  final formkey = GlobalKey<FormState>();
  void onIssue() async {
    final isvalidated = formkey.currentState!.validate();
    if (isvalidated) {
      formkey.currentState!.save();
    } else {
      return;
    }

    if (issuedDate == null && lastdate == null) {
      setState(() {
        dateerror = "Please pick a issue date";
      });
      return;
    }

    var response;

    try {
      setState(() {
        isuploading = true;
      });

      response = await http.post(
        Uri.parse("https://arcanists-04-3jz1.onrender.com/api/v1/issuebook"),
        body: {
          "email": userId,
          "bookid1": book1,
          "bookid2": book2,
          "bookid3": book3,
          "bookid4": book4,
          "bookid5": book5,
          "issueDate": issuedDate.toString(),
          "deadlineDate": lastdate.toString()
        },
      );
    } catch (e) {
      return;
    }
    var data = jsonDecode(response.body);
    print(data);
    setState(() {
      isuploading = false;
    });
    print(data);
    var message = "";
    if (response.statusCode == 200) {
      Navigator.pop(context);
      message = "Book Issued Successfully";
    } else {
      message = "Failed ! Try again later";
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
    useridc.clear();
    book1c.clear();
    book2c.clear();
    book3c.clear();
    book4c.clear();
    book5c.clear();
  }

  void issueDate() async {
    issuedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    lastdate = DateTime.now();
    lastdate =
        DateTime(issuedDate!.year, issuedDate!.month + 1, issuedDate!.day);
    print(lastdate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: 40, left: 15, right: 15),
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              const Text(
                "New issue Details",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: useridc,
                decoration: const InputDecoration(
                  label: Text("Student ID"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter Correct Student ID";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  userId = newValue!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: book1c,
                decoration: const InputDecoration(
                  label: Text("Book 1 ID"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                onSaved: (newValue) {
                  book1 = newValue!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: book2c,
                decoration: const InputDecoration(
                  label: Text("Book 2 ID"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                onSaved: (newValue) {
                  book2 = newValue!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: book3c,
                decoration: const InputDecoration(
                  label: Text("Book 3 ID"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                onSaved: (newValue) {
                  book3 = newValue!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: book4c,
                decoration: const InputDecoration(
                  label: Text("Book 4 ID"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                onSaved: (newValue) {
                  book4 = newValue!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: book5c,
                decoration: const InputDecoration(
                  label: Text("Book 5 ID"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                onSaved: (newValue) {
                  book5 = newValue!;
                },
              ),
              TextButton.icon(
                onPressed: issueDate,
                icon: const Icon(Icons.calendar_month),
                label: const Text("Pick Issue date"),
              ),
              Text(
                dateerror,
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 50),
                      shadowColor: Colors.black,
                      backgroundColor: Color.fromARGB(255, 102, 164, 240),
                      foregroundColor: Color.fromARGB(255, 0, 0, 0),
                    ),
                    child: isuploading == true
                        ? SpinKitCircle(
                            color: Colors.white,
                            size: 30,
                          )
                        : const Text(
                            "Issue",
                            style: TextStyle(fontSize: 20),
                          ),
                    onPressed: onIssue,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 50),
                      shadowColor: Colors.black,
                      backgroundColor: Color.fromARGB(255, 253, 254, 255),
                      foregroundColor: Color.fromARGB(255, 0, 0, 0),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
