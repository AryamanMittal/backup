import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Tab4 extends StatefulWidget {
  const Tab4({super.key});

  @override
  State<Tab4> createState() => _Tab4State();
}

class _Tab4State extends State<Tab4> {
  var bookname = "";
  var isuploading = false;
  final formkey = GlobalKey<FormState>();
  List<dynamic> allbook = [];
  var msg = "";
  final ctr = TextEditingController();

  void getbook() async {
    bool isvalid = formkey.currentState!.validate();

    if (isvalid) {
      setState(() {
        formkey.currentState!.save();
      });
    } else {
      return;
    }
    var response;
    try {
      setState(() {
        isuploading = true;
      });
      response = await http.post(
        Uri.parse(
            "https://arcanists-04-3jz1.onrender.com/api/v1/getbookfromcategory"),
        body: {
          "name": bookname,
        },
      );
    } catch (e) {
      return;
    }
    setState(() {
      isuploading = false;
    });
    var data = jsonDecode(response.body);
    if (response.statusCode == 404) {
      setState(() {
        msg = data["message"];
      });
      allbook = [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
      ctr.clear();
    }
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (response.statusCode == 200) {
      setState(() {
        allbook = data["book_cat"]["books"];
      });
      // print(data);
    }
    print(allbook[0]["condition"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: formkey,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: ctr,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter book category";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  bookname = newValue!;
                },
                decoration: const InputDecoration(
                  label: Text(
                    "Book Name",
                    style: TextStyle(color: Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: getbook,
              child: isuploading == true
                  ? SpinKitCircle(
                      color: Colors.white,
                      size: 30,
                    )
                  : const Text(
                      "Push book request",
                      style: TextStyle(fontSize: 15),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Color.fromARGB(255, 10, 218, 255),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            allbook.isEmpty
                ? Center(
                    child: Text("Nothing to show"),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: allbook.length,
                      itemBuilder: (context, i) {
                        return Card(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 20, left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Book ID:" + " " + allbook[i]["book_id"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 13, 0, 75),
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  "Condition:" + " " + allbook[i]["condition"],
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 80, 79, 79),
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "Count:" +
                                      " " +
                                      allbook[i]["count"].toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // Text(
                                //   "Issue date:" + " " + allbook[i]["issue_date"],
                                //   style: TextStyle(fontSize: 18, color: Colors.red),
                                // ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
