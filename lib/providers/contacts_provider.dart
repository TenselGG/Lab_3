import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';

const String contactsKey = 'contacts';

class ContactsNotifier extends StateNotifier<List<Contact>> {
  ContactsNotifier() : super([]);

  Future<void> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? contactsJson = prefs.getStringList(contactsKey);

    if (contactsJson != null) {
      final List<Contact> loadedContacts = contactsJson
          .map((jsonString) => Contact.fromJson(jsonDecode(jsonString)))
          .toList();
      state = _sortContacts(loadedContacts);
    }
  }

  Future<void> _saveContacts(List<Contact> currentContacts) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> contactsJson = currentContacts
        .map((contact) => jsonEncode(contact.toJson()))
        .toList();
    await prefs.setStringList(contactsKey, contactsJson);
  }

  List<Contact> _sortContacts(List<Contact> contacts) {
    contacts.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return contacts;
  }

  void addContact(Contact contact) {
    final newState = [...state, contact];
    state = _sortContacts(newState);
    _saveContacts(state);
  }

  void editContact(Contact updatedContact, int index) {
    final newState = [...state];
    newState[index] = updatedContact;
    state = _sortContacts(newState);
    _saveContacts(state);
  }

  void removeContact(Contact contact) {
    final newState = state.where((c) => c.id != contact.id).toList();
    state = newState;
    _saveContacts(state);
  }

  void insertContact(Contact contact, int index) {
    final newState = [...state];
    newState.insert(index, contact);
    state = _sortContacts(newState);
    _saveContacts(state);
  }
}

final contactsProvider = StateNotifierProvider<ContactsNotifier, List<Contact>>(
  (ref) {
    return ContactsNotifier();
  },
);

final contactCountByGroupProvider = Provider<Map<String, int>>((ref) {
  final contacts = ref.watch(contactsProvider);
  final Map<String, int> counts = {};

  for (var contact in contacts) {
    counts.update(contact.groupId, (value) => value + 1, ifAbsent: () => 1);
  }
  return counts;
});
