import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatContactModel {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  ChatContactModel({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'profilePic': this.profilePic,
      'contactId': this.contactId,
      'timeSent': this.timeSent,
      'lastMessage': this.lastMessage,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      contactId: map['contactId'] as String,
      timeSent: (map['timeSent'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'] as String,
    );
  }
}
