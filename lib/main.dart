import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppinglist_app/pages/product.dart';
import 'package:shoppinglist_app/pages/edit_product.dart';

String title_edit = "";
String subtitle_edit = "";
String status_edit = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Einkaufsliste',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Einkaufsliste APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> _isSelected = [false, true, false];
  List todos = List.empty();
  String title = "";
  String description = "";
  String status = "Benötigt";
  @override
  void initState() {
    super.initState();
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Einkaufsliste").doc(item);

    documentReference
        .delete()
        .whenComplete(() => print("deleted successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection("Einkaufsliste").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Etwas ist schief gelaufen!');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data?.docs[index];
                  return Dismissible(
                      key: Key(index.toString()),
                      //media qu
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text((documentSnapshot != null)
                              ? (documentSnapshot["todoTitle"])
                              : ""),
                          subtitle: Text((documentSnapshot != null)
                              ? ((documentSnapshot["todoDesc"] != null)
                                  ? documentSnapshot["todoDesc"]
                                  : "")
                              : ""),
                          trailing: Wrap(
                            children: <Widget>[
                              Text((documentSnapshot != null)
                                  ? ((documentSnapshot["todoStatus"] != null)
                                      ? documentSnapshot["todoStatus"]
                                      : "")
                                  : ""),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () {
                                  if (documentSnapshot != null) {
                                    title_edit = documentSnapshot["todoTitle"];
                                    subtitle_edit =
                                        documentSnapshot["todoDesc"];
                                    status_edit =
                                        documentSnapshot["todoStatus"];
                                    deleteTodo((documentSnapshot != null)
                                        ? (documentSnapshot["todoTitle"])
                                        : "");
                                  }
                                  MaterialPageRoute materialPageRoute =
                                      MaterialPageRoute(
                                    builder: (context) => edit_product(),
                                  );
                                  Navigator.of(context).push(materialPageRoute);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    deleteTodo((documentSnapshot != null)
                                        ? (documentSnapshot["todoTitle"])
                                        : "");
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ));
                });
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (context) => product(),
          );
          Navigator.of(context).push(materialPageRoute);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
