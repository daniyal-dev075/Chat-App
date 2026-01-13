import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/chat_contact_model.dart';
import 'package:whatsapp_clone/model/message_model.dart';
import 'package:whatsapp_clone/res/info.dart';
import 'package:whatsapp_clone/utils/enums/message_enum.dart';
import 'package:whatsapp_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../model/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContactModel>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
          List<ChatContactModel> contacts = [];
          for (var document in event.docs) {
            var chatContact = ChatContactModel.fromMap(document.data());
            var userData = await firestore
                .collection('users')
                .doc(chatContact.contactId)
                .get();
            var user = UserModel.fromMap(userData.data()!);
            contacts.add(ChatContactModel(name: user.name, profilePic: user.profilePic, contactId: chatContact.contactId, timeSent: chatContact.timeSent, lastMessage: chatContact.lastMessage));
          }
          return contacts;
        });
  }

  Stream<List<MessageModel>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages').orderBy('timeSent').snapshots().map((event) {
          List<MessageModel> messages = [];
          for(var document in event.docs){
            messages.add(MessageModel.fromMap(document.data()));
          }
          return messages;
    });
  }

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    var receiverChatContact = ChatContactModel(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContactModel(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String receiverUsername,
    required MessageEnum messageType,
  }) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap = await firestore
          .collection('users')
          .doc(receiverUserId)
          .get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();
      _saveDataToContactsSubcollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,
      );

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        receiverUsername: receiverUserData.name,
        username: senderUser.name,
      );
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }
  Future<void> removeChatContact(String contactUid) async {
    try {
      String currentUid = auth.currentUser!.uid;
      await firestore
          .collection('users')
          .doc(currentUid)
          .collection('chats')
          .doc(contactUid)
          .delete();
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

}
