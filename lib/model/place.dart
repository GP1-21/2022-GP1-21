// To parse this JSON data, do
//
//     final placeModel = placeModelFromJson(jsonString);

import 'dart:convert';

PlaceModel placeModelFromJson(String str) =>
    PlaceModel.fromJson(json.decode(str));

String placeModelToJson(PlaceModel data) => json.encode(data.toJson());

class PlaceModel {
  PlaceModel({
    this.category,
    this.city,
    this.description,
    this.free,
    this.from,
    this.images,
    this.location,
    this.name,
    this.price,
    this.time,
    this.to,
    this.type,
    this.lat,
    this.lng,
  });

  String? category;
  String? city;
  String? description;
  String? free;
  String? from;
  List<String>? images;
  String? location;
  String? name;
  String? price;
  String? time;
  String? to;
  String? type;
  double? lat;
  double? lng;

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        category: json["category"],
        city: json["city"],
        description: json["description"],
        free: json["free"],
        from: json["from"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        location: json["location"],
        name: json["name"],
        price: json["price"],
        time: json["time"],
        to: json["to"],
        type: json["type"],
        lng: json["lng"] == null ? 0 : json['lng'],
        lat: json["lat"] == null ? 0 : json['lat'],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "city": city,
        "description": description,
        "free": free,
        "from": from,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "location": location,
        "name": name,
        "price": price,
        "time": time,
        "to": to,
        "type": type,
        "lng": lng,
        "lat": lat,
      };
}
