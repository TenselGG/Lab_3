import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group.dart';

final List<Group> initialGroups = [
  Group(
    id: 'family',
    name: 'Family',
    icon: Icons.family_restroom,
    color: const Color.fromARGB(255, 255, 99, 71), // Tomato
  ),
  Group(
    id: 'friends',
    name: 'Friends',
    icon: Icons.people,
    color: const Color.fromARGB(255, 60, 179, 113), // MediumSeaGreen
  ),
  Group(
    id: 'work',
    name: 'Work',
    icon: Icons.business_center,
    color: const Color.fromARGB(255, 70, 130, 180), // SteelBlue
  ),
  Group(
    id: 'other',
    name: 'Other',
    icon: Icons.category,
    color: const Color.fromARGB(255, 128, 128, 128), // Gray
  ),
];

final groupsProvider = Provider<List<Group>>((ref) {
  return initialGroups;
});

final groupByIdProvider = Provider.family<Group?, String>((ref, id) {
  final groups = ref.watch(groupsProvider);
  try {
    return groups.firstWhere(
      (group) => group.id == id,
      orElse: () => throw Exception(),
    );
  } on Exception {
    return null;
  }
});
