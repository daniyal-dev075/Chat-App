import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/chat_contact_model.dart';
import 'package:whatsapp_clone/model/message_model.dart';
import 'package:whatsapp_clone/repository/chat_repository.dart';
import 'package:whatsapp_clone/view_model/auth_view_model.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatViewModel(chatRepository: chatRepository, ref: ref);
});

class ChatViewModel {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatViewModel({required this.chatRepository, required this.ref});

  Stream<List<ChatContactModel>> chatContacts(){
    return chatRepository.getChatContacts();
  }
  Stream<List<MessageModel>> chatStream(String receiverUserId){
    return chatRepository.getChatStream(receiverUserId);
  }
  void removeChatContact(String contactUid) {
    chatRepository.removeChatContact(contactUid);
  }


  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    ref
        .read(userDataAuthProvider)
        .whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!,
          ),
        );
  }
}
