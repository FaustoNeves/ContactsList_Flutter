import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'contact.dart';

class NewContact extends StatefulWidget {
  final Contact contact;

  NewContact(this.contact);

  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  final firestoreInstance = Firestore.instance;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController(text: widget.contact.name);
    _emailController = new TextEditingController(text: widget.contact.email);
  }

  @override
  Widget build(BuildContext context) {
    var uuid = Uuid();
    return Scaffold(
      key: _form,
      appBar: AppBar(
        title: Text("Contacts Manager"),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value!.trim().length < 4) {
                    return "Name must contain at least 4 characters";
                  }
                },
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return "Invalid email format";
                  }
                },
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              ElevatedButton(
                child: (widget.contact.id != "") ? Text('Update') : Text("New"),
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    _form.currentState!.save();
                    if (widget.contact.id != "") {
                      firestoreInstance
                          .collection("contacts")
                          .document(widget.contact.id)
                          .setData({
                        "name": _nameController.text,
                        "email": _emailController.text,
                      });
                      Navigator.pop(context);
                    } else {
                      firestoreInstance
                          .collection("contacts")
                          .document(uuid.v1())
                          .setData({
                        "name": _nameController.text,
                        "email": _emailController.text,
                      });
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
