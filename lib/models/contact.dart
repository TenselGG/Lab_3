import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Contact {
  final String id;
  String name;
  String phone;
  String groupId;

  Contact({
    required this.name,
    required this.phone,
    required this.groupId,
    String? id,
  }) : id = id ?? uuid.v4();

  // ФІКС: copyWith не приймає 'id' як параметр, але використовує його
  Contact copyWith({String? name, String? phone, String? groupId}) {
    return Contact(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'groupId': groupId,
  };

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      groupId: json['groupId'] ?? '',
    );
  }
}
