import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppinglist_app/main.dart';

class edit_product extends StatefulWidget {
  @override
  State<edit_product> createState() => _edit_productState();
}

class _edit_productState extends State<edit_product> {
  List<bool> _isSelected = [true, false];
  late TextEditingController _controller;
  late TextEditingController _controller2;

  @override
  void initState() {
    if (status_edit == "false") {
      _isSelected = [true, false];
    } else {
      _isSelected = [false, true];
    }
    _controller = new TextEditingController(text: title_edit);
    _controller2 = new TextEditingController(text: subtitle_edit);
  }

  List todos = List.empty();

  String title = "";

  String description = "";
  convert(bool input) {
    if (input == true) {
      return "Benötigt";
    } else {
      return "Eingekauft";
    }
  }

  createToDo() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Einkaufsliste")
        .doc(_controller.text);

    Map<String, String> todoList = {
      "todoTitle": _controller.text,
      "todoDesc": _controller2.text,
      "todoStatus": convert(_isSelected[0]),
    };
    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            createToDo();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
        title: const Text('Produkt ändern'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Produkt",
            ),
            onChanged: (String value) {
              title = value;
            },
          ),
          TextField(
            controller: _controller2,
            decoration: const InputDecoration(
              labelText: "Anzahl",
            ),
            onChanged: (String value) {
              description = value;
            },
          ),
          const Spacer(flex: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _isSelected[0] = true;
                    _isSelected[1] = false;
                  });
                },
                child: const Text("Benötigt"),
                color: _isSelected[0] ? Colors.red : null,
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _isSelected[0] = false;
                    _isSelected[1] = true;
                  });
                },
                child: const Text("Eingekauft"),
                color: _isSelected[1] ? Colors.green : null,
              ),
            ],
          ),
          const Spacer(flex: 12),
          Column(
            children: [
              RaisedButton(
                  onPressed: () {
                    createToDo();
                    Navigator.of(context).pop();
                  },
                  color: Colors.blue,
                  child: const Text("Ändern"))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
