import 'package:flutter/material.dart';
import 'package:libraryapp/widgets/addBook.dart';
import 'package:libraryapp/widgets/addcategory.dart';

class Tab3 extends StatefulWidget {
  const Tab3({super.key});

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  var screen = 0;
  void onpress1() {
    setState(() {
      screen = 1;
    });
  }

  void onpress2() {
    setState(() {
      screen = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Text("");
    if (screen == 1) {
      content = AddBook();
    } else if (screen == 0) {
      content = AddCategory();
    }
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 90),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: onpress1,
                child: Text("ADD NEW BOOK"),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  backgroundColor: screen == 1 ? Colors.black : Colors.white,
                  foregroundColor: screen == 1
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(255, 255, 33, 33),
                ),
              ),
              ElevatedButton(
                onPressed: onpress2,
                child: Text("ADD NEW CATEGORY"),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50),
                  shadowColor: Colors.black,
                  backgroundColor: screen == 0 ? Colors.black : Colors.white,
                  foregroundColor: screen == 0
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(255, 255, 33, 33),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          content,
        ],
      ),
    ));
  }
}
