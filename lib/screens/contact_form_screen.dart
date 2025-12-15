import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../models/group.dart';
import '../providers/groups_provider.dart';

class ContactFormScreen extends ConsumerStatefulWidget {
  final Contact? initialContact;

  const ContactFormScreen({super.key, this.initialContact});

  @override
  ConsumerState<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends ConsumerState<ContactFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  Group? _selectedGroup;

  @override
  void initState() {
    super.initState();
    final groups = ref.read(groupsProvider);

    if (widget.initialContact != null) {
      _nameController.text = widget.initialContact!.name;
      _phoneController.text = widget.initialContact!.phone;

      _selectedGroup = groups.firstWhere(
        (g) => g.id == widget.initialContact!.groupId,
        orElse: () => groups.first,
      );
    } else {
      _selectedGroup = groups.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitData() {
    final enteredName = _nameController.text.trim();
    final enteredPhone = _phoneController.text.trim();

    if (enteredName.isEmpty || enteredPhone.isEmpty || _selectedGroup == null) {
      return;
    }

    final resultContact = Contact(
      name: enteredName,
      phone: enteredPhone,
      groupId: _selectedGroup!.id,
      id: widget.initialContact?.id,
    );

    Navigator.of(context).pop(resultContact);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialContact != null;
    final titleText = isEditing ? 'Edit Contact' : 'Add New Contact';
    final groups = ref.watch(groupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 30),
              DropdownButtonFormField<Group>(
                value: _selectedGroup,
                decoration: const InputDecoration(
                  labelText: 'Group',
                  border: OutlineInputBorder(),
                ),
                items: groups.map((group) {
                  return DropdownMenuItem<Group>(
                    value: group,
                    child: Row(
                      children: [
                        Icon(group.icon, color: group.color),
                        const SizedBox(width: 8),
                        Text(group.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Group? newValue) {
                  setState(() {
                    _selectedGroup = newValue;
                  });
                },
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(isEditing ? 'Save Changes' : 'Add Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
