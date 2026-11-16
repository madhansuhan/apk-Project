import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? company;
  final String? role;
  final String token;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.company,
    this.role,
    required this.token,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? company,
    String? role,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
      'role': role,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      company: map['company'] ?? 'Sankar Group Partner',
      role: map['role'] ?? 'Procurement Engineer',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
