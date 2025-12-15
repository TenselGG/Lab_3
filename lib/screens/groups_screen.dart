import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group.dart';
import '../providers/contacts_provider.dart';
import '../providers/groups_provider.dart';
import 'contact_list_screen.dart';

class GroupItem extends ConsumerWidget {
  const GroupItem({super.key, required this.group});

  final Group group;

  void _selectGroup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ContactListScreen(
          filterGroupId: group.id,
          title: '${group.name} Contacts',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactCounts = ref.watch(contactCountByGroupProvider);
    final count = contactCounts[group.id] ?? 0;

    return InkWell(
      onTap: () => _selectGroup(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              group.color.withOpacity(0.85),
              group.color.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: group.color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              group.name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contacts: $count',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Icon(
                  group.icon,
                  color: Colors.white.withOpacity(0.9),
                  size: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GroupsScreen extends ConsumerWidget {
  GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableGroups = ref.watch(groupsProvider);

    return GridView(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        ...availableGroups.map((group) => GroupItem(group: group)).toList(),
      ],
    );
  }
}
