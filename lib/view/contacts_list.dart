import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_lists_in_flutter/model/contact.dart';
import 'package:contacts_lists_in_flutter/model/new_contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  late List<Contact> _items;
  var collectionRef = Firestore.instance.collection("contacts");
  StreamSubscription<QuerySnapshot>? contactSubscription;

  @override
  void initState() {
    super.initState();
    contactSubscription?.cancel();
    contactSubscription = collectionRef.snapshots().listen((event) {
      final List<Contact> contactsList = event.documents
          .map((docSnapshot) =>
          Contact.fromMap(docSnapshot.data, docSnapshot.documentID))
          .toList();

      setState(() {
        this._items = contactsList;
      });
    });
  }

  @override
  void dispose() {
    contactSubscription?.cancel();
    super.dispose();
  }

  //Returns all contacts
  Stream<QuerySnapshot> getContactsList() {
    return collectionRef.snapshots();
  }

  //Navigate to contact screen
  void managerNavigator(BuildContext context, Contact contact) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewContact(contact)));
  }

  //Register contact
  void _registerContact(BuildContext context, Contact contact) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewContact(
              Contact("", "", ""),
            )));
  }

  //Delete contact
  void _deleteContact(
      BuildContext context, DocumentSnapshot doc, int index) async {
    collectionRef.document(doc.documentID).delete();

    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts List"),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getContactsList(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:

                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      List<DocumentSnapshot> documents = snapshot.data!.documents;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  _items[index].name,
                                  style: TextStyle(fontSize: 22),
                                ),
                                subtitle: Text(
                                  _items[index].email,
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Container(
                                  width: 100,
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _deleteContact(
                                              context, documents[index], index);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          managerNavigator(
                                              context, _items[index]);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                  }
                },
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () => _registerContact(context, Contact(null, "", ""))),
    );
  }
}
