import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

class Tab1 extends StatefulWidget {
  const Tab1({super.key});

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  final listitems = [
    Image.asset(
      "images/b0.jpg",
      fit: BoxFit.fill,
    ),
    Image.asset(
      "images/b1.jpg",
      fit: BoxFit.fill,
    ),
    Image.asset(
      "images/b2.jpg",
      fit: BoxFit.fill,
    ),
    Image.asset(
      "images/b3.jpg",
      fit: BoxFit.fill,
    ),
    Image.asset(
      "images/b5.jpg",
      fit: BoxFit.fill,
    ),
    Image.asset(
      "images/b6.jpg",
      fit: BoxFit.cover,
    ),
  ];
  var currentindex = 0;
  List<dynamic> allbook = [];
  bool isloading = false;
  void loadAllBook() async {
    var response;
    try {
      isloading = true;
      response = await http.get(
        Uri.parse("https://arcanists-04-3jz1.onrender.com/api/v1/getallbooks"),
      );
    } catch (e) {
      return;
    }

    var data = jsonDecode(response.body);
    // print(response);

    if (response.statusCode == 200) {
      setState(() {
        allbook = data["data"];
        Timer(Duration(milliseconds: 800), () {
          setState(() {
            isloading = false;
          });
        });
      });
    }
    print(allbook[0]["name"]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 251),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            SingleChildScrollView(
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  height: 180,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: const Duration(milliseconds: 300),
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentindex = index;
                    });
                  },
                ),
                items: listitems,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedSmoothIndicator(
                activeIndex: currentindex,
                effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    radius: 5,
                    dotColor: Color.fromARGB(255, 255, 29, 29),
                    activeDotColor: Colors.black,
                    spacing: 10,
                    paintStyle: PaintingStyle.fill),
                count: listitems.length),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "All Books",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            isloading
                ? Padding(
                    padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                    child: SpinKitCircle(
                      color: Colors.black,
                      size: 40,
                    ),
                  )
                : Text(""),
            Expanded(
              child: ListView.builder(
                itemCount: allbook.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Book Name:" + " " + allbook[i]["name"],
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 13, 0, 75),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Author:" + " " + allbook[i]["author"],
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 80, 79, 79),
                                fontWeight: FontWeight.w400),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Price:" + " " + allbook[i]["price"].toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 111, 3, 3)),
                              ),
                              Text(
                                "Pages:" + " " + allbook[i]["pages"].toString(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    color:
                                        const Color.fromARGB(255, 111, 3, 3)),
                              ),
                              Text(
                                "Available" +
                                    " " +
                                    allbook[i]["available"].toString() +
                                    "/" +
                                    allbook[i]["total"].toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 111, 3, 3),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Description:" + " " + allbook[i]["description"],
                            style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 18, 2, 0)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
