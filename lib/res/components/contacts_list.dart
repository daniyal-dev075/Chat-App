import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/model/chat_contact_model.dart';
import 'package:whatsapp_clone/res/app_colors.dart';
import 'package:whatsapp_clone/res/components/loader.dart';
import 'package:whatsapp_clone/view_model/chat_view_model.dart';

import '../../utils/routes/route_name.dart';
import '../info.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ChatContactModel>>(
      stream: ref.watch(chatControllerProvider).chatContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loader());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No contacts found"));
        }

        final contacts = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            var chatContactData = snapshot.data![index];
            return Column(
              children: [
                Dismissible(
                  key: ValueKey(chatContactData.contactId),
                  direction: DismissDirection.endToStart, // swipe left only
                  onDismissed: (_) {
                    ref
                        .read(chatControllerProvider)
                        .removeChatContact(chatContactData.contactId);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteName.chatView,
                        arguments: {
                          'name': chatContactData.name,
                          'uid': chatContactData.contactId,
                        },
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: (chatContactData.profilePic.isNotEmpty)
                            ? NetworkImage(chatContactData.profilePic)
                            : null,
                        child: chatContactData.profilePic.isEmpty
                            ? Icon(Icons.person, size: 30)
                            : null,
                      ),
                      title: Text(
                        chatContactData.name,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          chatContactData.lastMessage,
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ),
                      trailing: Text(
                        DateFormat.Hm().format(chatContactData.timeSent),
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Divider(color: AppColors.dividerColor, thickness: 2),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
