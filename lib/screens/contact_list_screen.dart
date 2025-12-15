import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../widgets/contact_tile.dart';
import '../providers/contacts_provider.dart';
import 'contact_form_screen.dart';

class ContactListScreen extends ConsumerWidget {
  final String? filterGroupId;
  final String title;

  const ContactListScreen({
    super.key,
    this.filterGroupId,
    this.title = 'All Contacts',
  });

  void _openAddContactScreen(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const ContactFormScreen(),
      ),
    ).then((newContact) {
      if (newContact != null && newContact is Contact) {
        ref.read(contactsProvider.notifier).addContact(newContact);
      }
    });
  }

  void _openEditContactScreen(
    BuildContext context,
    WidgetRef ref,
    Contact contactToEdit,
    int index,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (ctx) => ContactFormScreen(initialContact: contactToEdit),
          ),
        )
        .then((updatedContact) {
          if (updatedContact != null && updatedContact is Contact) {
            ref
                .read(contactsProvider.notifier)
                .editContact(updatedContact, index);
          }
        });
  }

  void _handleCall(BuildContext context, Contact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling ${contact.name}: ${contact.phone}')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Contact> contacts = ref.watch(contactsProvider);

    if (filterGroupId != null) {
      contacts = contacts
          .where((contact) => contact.groupId == filterGroupId)
          .toList();
    }

    final contactsNotifier = ref.read(contactsProvider.notifier);

    return Scaffold(
      appBar: filterGroupId != null ? AppBar(title: Text(title)) : null,

      body: contacts.isEmpty
          ? Center(
              child: Text(
                filterGroupId != null
                    ? 'No contacts in this group.'
                    : 'Contact list is empty.\nAdd your first contact!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return Dismissible(
                  key: ValueKey(contact.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  onDismissed: (direction) {
                    final removedContact = contact;
                    final removedIndex = index;

                    contactsNotifier.removeContact(removedContact);

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${removedContact.name} deleted'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            contactsNotifier.insertContact(
                              removedContact,
                              removedIndex,
                            );
                          },
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },

                  child: InkWell(
                    onTap: () =>
                        _openEditContactScreen(context, ref, contact, index),
                    child: ContactTile(
                      contact: contact,
                      onCall: () => _handleCall(context, contact),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: filterGroupId == null
          ? FloatingActionButton(
              onPressed: () => _openAddContactScreen(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
