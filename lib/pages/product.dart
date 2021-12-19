// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppinglist_app/main.dart';

class product extends StatefulWidget {
  @override
  State<product> createState() => _productState();
}

class _productState extends State<product> {
  List<bool> _isSelected = [true, false];

  List todos = List.empty();

  String title = "";

  String description = "";

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Einkaufsliste").doc(title);

    Map<String, String> todoList = {
      "todoTitle": title,
      "todoDesc": description,
      "todoStatus": _isSelected[0].toString(), // true
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produkt'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: "Produkt",
            ),
            onChanged: (String value) {
              title = value;
            },
          ),
          TextField(
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
                color: _isSelected[0] ? Colors.blue : null,
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _isSelected[0] = false;
                    _isSelected[1] = true;
                  });
                },
                child: const Text("Eingekauft"),
                color: _isSelected[1] ? Colors.blue : null,
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
                  child: const Text("Hinzufügen"))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
