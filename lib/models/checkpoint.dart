import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'user.dart';

class Checkpoint {
  const Checkpoint({
    required this.id,
    required this.title,
    required this.desc,
    required this.photo,
    required this.owner,
    required this.latLng,
    required this.translatedContent,
  });

  final String id;
  final String title;
  final String desc;
  final String photo;
  final User owner;
  final LatLng latLng;
  final Map<String, dynamic> translatedContent;

  static const empty = Checkpoint(
    id: '',
    title: '',
    desc: '',
    photo: '',
    owner: User.empty,
    latLng: LatLng(0, 0),
    translatedContent: {},
  );

  Marker toMarker({
    required BitmapDescriptor icon,
    VoidCallback? onTap,
  }) {
    return Marker(
        markerId: MarkerId(id), position: latLng, icon: icon, onTap: onTap);
  }

  Checkpoint.fromEntity(Map data)
      : id = data["id"],
        title = data["content"]["title"],
        desc = data["content"]["desc"],
        photo = data["photo"],
        owner = User(
          id: data["owner"]["id"],
          email: data["owner"]["email"],
          name: data["owner"]["name"],
          photo: data["owner"]["photo"],
        ),
        latLng = LatLng(data["location"].latitude, data["location"].longitude),
        translatedContent = data["translatedContent"];

  Checkpoint.fromHit(Map data)
      : id = data["objectID"],
        title = data["content"]["title"],
        desc = data["content"]["desc"],
        photo = data["photo"],
        owner = User(
          id: data["owner"]["id"],
          email: data["owner"]["email"],
          name: data["owner"]["name"],
          photo: data["owner"]["photo"],
        ),
        latLng = LatLng(data["_geoloc"]["lat"], data["_geoloc"]["lng"]),
        translatedContent = data["translatedContent"] ?? {};

  Map<String, dynamic> toDocumentData() {
    Map<String, dynamic> data = {"content": {}};
    data["content"]["title"] = title;
    data["content"]["desc"] = desc;
    data["photo"] = photo;
    data["owner"] = owner.toDocumentData();
    data["location"] = GeoPoint(
      latLng.latitude,
      latLng.longitude,
    );
    return data;
  }
}
