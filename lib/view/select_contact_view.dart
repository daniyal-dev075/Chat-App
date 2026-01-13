import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/res/components/loader.dart';
import 'package:whatsapp_clone/view/error_view.dart';
import 'package:whatsapp_clone/view_model/select_contact_view_model.dart';

class SelectContactView extends ConsumerStatefulWidget {
  const SelectContactView({super.key});

  @override
  ConsumerState<SelectContactView> createState() => _SelectContactViewState();
}

class _SelectContactViewState extends ConsumerState<SelectContactView> {
  bool isSearching = false;
  String searchQuery = "";

  void selectContact(WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text("Select Contact")
            : TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search contacts...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) searchQuery = "";
              });
            },
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
        data: (contactList) {
          // 🔹 Filter contacts if searching
          final filteredContacts = isSearching && searchQuery.isNotEmpty
              ? contactList
              .where((c) => c.displayName.toLowerCase().contains(searchQuery))
              .toList()
              : contactList;

          if (filteredContacts.isEmpty) {
            return const Center(child: Text("No contacts found"));
          }

          return ListView.builder(
            itemCount: filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = filteredContacts[index];
              return InkWell(
                onTap: () => selectContact(ref, contact, context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: ListTile(
                    title: Text(contact.displayName),
                    leading: contact.photo == null
                        ? CircleAvatar(
                      child: const Icon(Icons.person),
                      backgroundColor: Colors.grey,
                      radius: 25.r,
                    )
                        : CircleAvatar(
                      radius: 25.r,
                      backgroundImage: MemoryImage(contact.photo!),
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (err, trace) => ErrorView(error: err.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
