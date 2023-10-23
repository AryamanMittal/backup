import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Updatecategory extends StatefulWidget {
  const Updatecategory({super.key});

  @override
  State<Updatecategory> createState() => _UpdatecategoryState();
}

class _UpdatecategoryState extends State<Updatecategory> {
  final catnamec = TextEditingController();

  var catname = "";
  var author = "";
  var price = "";
  var pages = "";
  var description = "";
  bool isuploading = false;
  final formkey = GlobalKey<FormState>();

  void onupdate() async {
    bool isvalid = formkey.currentState!.validate();

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
      response = await http.put(
          Uri.parse(
              "https://arcanists-04-3jz1.onrender.com/api/v1/updatebookcategory"),
          body: {
            "name": catname,
            "author": author,
            "price": price,
            "pages": pages,
            "description": description
          });
    } catch (e) {
      return;
    }
    var data = jsonDecode(response.body);

    setState(() {
      isuploading = false;
    });

    var message = "";
    if (response.statusCode == 200) {
      message = "Category Updated Successfully";
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Update Category ",
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
                    if (value == null || value.trim().isEmpty) {
                      return "Cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    catname = newValue!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.all(20),
                    hoverColor: Colors.blue,
                    label: const Text(
                      "Category name",
                      style: TextStyle(color: Color.fromARGB(255, 1, 66, 78)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    author = newValue!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.all(20),
                    hoverColor: Colors.blue,
                    label: const Text(
                      "Author",
                      style: TextStyle(color: Color.fromARGB(255, 1, 66, 78)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          price = newValue!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.all(20),
                          hoverColor: Colors.blue,
                          label: const Text(
                            "Price",
                            style: TextStyle(
                                color: Color.fromARGB(255, 1, 66, 78)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          pages = newValue!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.all(20),
                          hoverColor: Colors.blue,
                          label: const Text(
                            "No. of pages",
                            style: TextStyle(
                                color: Color.fromARGB(255, 1, 66, 78)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    description = newValue!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.all(20),
                    hoverColor: Colors.blue,
                    label: const Text(
                      "Description",
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
                  child: isuploading == true
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
      ),
    );
  }
}
