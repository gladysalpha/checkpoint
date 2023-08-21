import 'package:equatable/equatable.dart';

import 'user.dart';

class Post extends Equatable {
  const Post({
    required this.id,
    required this.comment,
    required this.photo,
    required this.owner,
  });

  final String id;
  final String comment;
  final String photo;
  final User owner;

  static const empty = Post(
    id: '',
    comment: '',
    photo: '',
    owner: User.empty,
  );

  Post.fromEntity(Map data)
      : id = data["id"],
        comment = data["comment"],
        photo = data["photo"],
        owner = User(
          id: data["owner"]["id"],
          email: data["owner"]["email"],
          name: data["owner"]["name"],
          photo: data["owner"]["photo"],
        );
  Map<String, dynamic> toDocumentData() {
    Map<String, dynamic> data = {};
    data["comment"] = comment;
    data["photo"] = photo;
    data["owner"] = owner.toDocumentData();
    return data;
  }

  @override
  List<Object?> get props => [id, comment, photo, owner];
}
