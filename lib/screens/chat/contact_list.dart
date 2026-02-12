import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/chat/contacts_list_screen.dart';
import 'package:whatsapp_clone/screens/chat/empty_contacts_screen.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  void fetchContacts() async {
    await Future.delayed(Duration(seconds: 1)); // test

    setState(() {
      contacts = []; // firebase data ayega
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (contacts.isEmpty) {
      return EmptyContactsScreen();
    }

    return ContactsListScreen(contacts: contacts);
  }
}
