import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/utils/routes/route_name.dart';
import 'package:whatsapp_clone/utils/utils.dart';

import '../model/user_model.dart';

final selectContactsRepositoryProvider = Provider((ref)=> SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository{
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try{
      if(await FlutterContacts.requestPermission()){
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e){
      debugPrint(e.toString());
    }
    return contacts;
  }
  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      // Normalize the selected phone number
      String selectedPhoneNumber = selectedContact.phones[0].number;
      String normalizedSelected = Utils().normalizePhoneNumber(selectedPhoneNumber, "92"); // Pakistan code

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());

        // Normalize the Firestore number too (safety)
        String normalizedFirestore = Utils().normalizePhoneNumber(userData.phoneNumber, "92");

        if (normalizedSelected == normalizedFirestore) {
          isFound = true;
          Navigator.pushNamed(context, RouteName.chatView, arguments: {
            'name': userData.name,
            'uid': userData.uid,
            'isOnline': userData.isOnline
          });
          break; // stop loop once found
        }
      }

      if (!isFound) {
        Utils().toastMessage('This Number doesn\'t have any account');
      }
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

}

