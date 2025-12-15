import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Group {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Group({
    required this.name,
    required this.icon,
    required this.color,
    String? id,
  }) : id = id ?? uuid.v4();
}
