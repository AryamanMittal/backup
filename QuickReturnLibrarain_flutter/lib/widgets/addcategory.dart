import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final categoryc = TextEditingController();
  final authrc = TextEditingController();
  final pricec = TextEditingController();
  final pagesc = TextEditingController();
  final descriptionc = TextEditingController();
  var category = "";
  var author = "";
  var price = "";
  var pages = "";
  var description = "";
  final formkey = GlobalKey<FormState>();
  bool isuploading = false;

  void oncreate() async {
    var isvalidated = formkey.currentState!.validate();

    if (isvalidated) {
      formkey.currentState!.save();
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
            "https://arcanists-04-3jz1.onrender.com/api/v1/createbookcategory"),
        body: {
          "name": category,
          "author": author,
          "price": price,
          "pages": pages,
          "description": description
        },
      );
    } catch (e) {}
    setState(() {
      isuploading = false;
    });
    var message = "";
    if (response.statusCode == 200) {
      message = "Category Added Successfully";
    } else {
      message = "Failed ! Try again later";
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
    categoryc.clear();
    authrc.clear();
    pricec.clear();
    pagesc.clear();
    descriptionc.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Add New Category ",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10,
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
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: authrc,
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
                  controller: pricec,
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
                  keyboardType: TextInputType.number,
                  controller: pagesc,
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
                      style: TextStyle(color: Color.fromARGB(255, 1, 66, 78)),
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
            controller: descriptionc,
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
            onPressed: oncreate,
            child: isuploading == true
                ? SpinKitCircle(
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
    );
    ;
  }
}
