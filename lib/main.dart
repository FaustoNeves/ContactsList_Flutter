import 'package:contacts_lists_in_flutter/view/contacts_list.dart';
import 'package:flutter/material.dart';

//flutter run --no-sound-null-safety
void main() {
  runApp(MaterialApp(
    title: 'Contacts',
    theme: new ThemeData(primaryColor: Colors.orange),
    home: ContactsList(),
  ));
}
