import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../providers/groups_provider.dart';

class ContactTile extends ConsumerWidget {
  final Contact contact;
  final VoidCallback? onCall;

  const ContactTile({super.key, required this.contact, this.onCall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupByIdProvider(contact.groupId));

    final groupColor = group?.color ?? Colors.grey;
    final groupIcon = group?.icon ?? Icons.person;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: groupColor.withOpacity(0.1),
          child: Icon(groupIcon, color: groupColor),
        ),

        title: Text(
          contact.name,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        subtitle: Text(
          contact.phone,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Colors.black54),
        ),

        trailing: IconButton(
          icon: const Icon(Icons.call),
          color: Colors.green,
          onPressed: onCall,
        ),
      ),
    );
  }
}
