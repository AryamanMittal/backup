import 'package:flutter/material.dart';
import 'package:libraryapp/screens/deletebook.dart';
import 'package:libraryapp/screens/deletecategory.dart';
import 'package:libraryapp/screens/updatebook.dart';
import 'package:libraryapp/screens/updatecategory.dart';

class DrawerSide extends StatefulWidget {
  const DrawerSide({super.key});

  @override
  State<DrawerSide> createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80, left: 10, right: 10),
      child: Column(
        children: [
          const Text(
            "Edits",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 5,
            color: Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Book Category",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            tileColor: Color.fromARGB(255, 249, 224, 224),
            title: const Text("Update Book Category"),
            leading: Icon(Icons.update_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Updatecategory(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Color.fromARGB(255, 249, 224, 224),
            title: const Text("Delete Book Category"),
            leading: Icon(Icons.delete),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => Deletecategory(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Book ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Color.fromARGB(255, 249, 224, 224),
            title: const Text("Update Book "),
            leading: Icon(Icons.update_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => Updatebook(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Color.fromARGB(255, 249, 224, 224),
            title: const Text("Delete Book "),
            leading: Icon(Icons.delete),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => Deletebook(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
