import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Tab2 extends StatefulWidget {
  const Tab2({super.key});

  @override
  State<Tab2> createState() => _tab2State();
}

class _tab2State extends State<Tab2> {
  var bookid = "";
  final bookcController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isloading = false;
  bool gettingdata = false;

  List<dynamic> ubooks = [];
  void requestBook() async {
    var isvalid = formkey.currentState!.validate();
    if (isvalid) {
      formkey.currentState!.save();
    } else {
      return;
    }
    var response;
    try {
      setState(() {
        isloading = true;
      });
      response = await http.post(
          Uri.parse(
              "https://arcanists-04-3jz1.onrender.com/api/v1/requestbook"),
          body: {"bookId": bookid});
    } catch (e) {
      return;
    }
    var msg = "";

    var data = jsonDecode(response.body);
    print(data);
    setState(() {
      isloading = false;
    });
    print(data["message"]);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        msg = data["message"];
      });
    } else if (response.statusCode == 404) {
      setState(() {
        msg = data["message"];
      });
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
    bookcController.clear();
  }

  void unavailable() async {
    var response;
    try {
      setState(() {
        gettingdata = true;
      });
      response = await http.get(
        Uri.parse(
            "https://arcanists-04-3jz1.onrender.com/api/v1/getunavailablebooks"),
      );
    } catch (e) {
      return;
    }

    var data = jsonDecode(response.body);
    print(data);
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (response.statusCode == 200) {
      setState(() {
        ubooks = data["data"];
        Timer(Duration(milliseconds: 800), () {
          setState(() {
            gettingdata = false;
          });
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unavailable();
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
                keyboardType: TextInputType.number,
                controller: bookcController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter book ID";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  bookid = newValue!;
                },
                decoration: const InputDecoration(
                  label: Text(
                    "Enter book ID",
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
              onPressed: requestBook,
              child: isloading == true
                  ? SpinKitCircle(
                      color: Colors.white,
                      size: 30,
                    )
                  : const Text(
                      "Push book request",
                      style: TextStyle(fontSize: 20),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Color.fromARGB(255, 10, 218, 255),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Unavailable Books",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            Expanded(
              child: ubooks.isEmpty
                  ? const Center(
                      child: Text("Nothing to show"),
                    )
                  : ListView.builder(
                      itemCount: ubooks.length,
                      itemBuilder: (context, i) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Book Name:" + " " + ubooks[i]["name"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 13, 0, 75),
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  "Author:" + " " + ubooks[i]["author"],
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 80, 79, 79),
                                      fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Price:" +
                                          " " +
                                          ubooks[i]["price"].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 28, 32, 35)),
                                    ),
                                    Text(
                                      "Pages:" +
                                          " " +
                                          ubooks[i]["pages"].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 42, 49, 54)),
                                    ),
                                    Text(
                                      "Available" +
                                          " " +
                                          ubooks[i]["available"].toString() +
                                          "/" +
                                          ubooks[i]["total"].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 62, 40, 7),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Description:" +
                                      " " +
                                      ubooks[i]["description"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: const Color.fromARGB(
                                          255, 26, 24, 24)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
            )
          ],
        ),
      ),
    );
  }
}
