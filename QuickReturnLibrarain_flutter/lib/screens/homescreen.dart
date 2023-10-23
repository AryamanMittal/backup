import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:libraryapp/screens/qr_Scanner.dart';
import 'package:libraryapp/widgets/drawer.dart';
import 'package:libraryapp/widgets/issue.dart';
import 'package:libraryapp/widgets/tab1.dart';
import 'package:libraryapp/widgets/tab2.dart';
import 'package:libraryapp/widgets/tab3.dart';
import 'package:libraryapp/widgets/tab4.dart';

final Color color = const Color.fromARGB(255, 255, 255, 255).withOpacity(.2);

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabcontroller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabcontroller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: color,
        title: Image.asset(
          "images/QR.png",
          height: 115,
          alignment: Alignment.topLeft,
        ),
        toolbarHeight: 90,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => QRScanner(),
                ),
              );
            },
            icon: const Icon(
              Icons.qr_code_scanner_outlined,
              size: 35,
              color: Colors.blue,
            ),
          )
        ],
        bottom: TabBar(controller: tabcontroller, tabs: const [
          Tab(
            child: Text(
              "All Books",
              style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 136, 173),
                  fontWeight: FontWeight.bold),
            ),
            icon: Icon(
              FontAwesome.book,
              size: 25,
              color: Color.fromARGB(255, 255, 63, 63),
            ),
          ),
          Tab(
            child: Text(
              "Request Book",
              style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 0, 136, 173),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            icon: Icon(
              FontAwesome.clock_rotate_left,
              size: 25,
              color: Color.fromARGB(255, 255, 63, 63),
            ),
          ),
          Tab(
            child: Text(
              "Upload",
              style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 136, 173),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            icon: Icon(
              FontAwesome.upload,
              size: 25,
              color: Color.fromARGB(255, 255, 63, 63),
            ),
          ),
          Tab(
            child: Text(
              "Book id",
              style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 136, 173),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            icon: Icon(
              FontAwesome.get_pocket,
              size: 25,
              color: Color.fromARGB(255, 255, 63, 63),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            elevation: 10,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            context: context,
            builder: (context) {
              return BookIssue();
            },
          );
        },
      ),
      drawer: Drawer(child: DrawerSide()),
      body: TabBarView(
          controller: tabcontroller,
          children: [Tab1(), Tab2(), Tab3(), Tab4()]),
    );
  }
}
