import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });

  final String id;
  final String? email;
  final String? name;
  final String? photo;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  Map<String, dynamic> toDocumentData() {
    Map<String, dynamic> data = {};
    data["id"] = id;
    data["email"] = email;
    data["name"] = name;
    data["photo"] = photo;
    return data;
  }

  @override
  List<Object?> get props => [email, id, name, photo];
}
