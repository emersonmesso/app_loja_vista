// To parse this JSON data, do
//
//     final responseGeolocator = responseGeolocatorFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class ResponseGeolocator {
  ResponseGeolocator({
    @required this.plusCode,
    @required this.results,
    @required this.status,
  });

  final PlusCode plusCode;
  final List<Result> results;
  final String status;

  ResponseGeolocator copyWith({
    PlusCode plusCode,
    List<Result> results,
    String status,
  }) =>
      ResponseGeolocator(
        plusCode: plusCode ?? this.plusCode,
        results: results ?? this.results,
        status: status ?? this.status,
      );

  factory ResponseGeolocator.fromRawJson(String str) =>
      ResponseGeolocator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseGeolocator.fromJson(Map<String, dynamic> json) =>
      ResponseGeolocator(
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        results: json["results"] == null
            ? null
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "plus_code": plusCode == null ? null : plusCode.toJson(),
        "results": results == null
            ? null
            : List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status == null ? null : status,
      };
}

class PlusCode {
  PlusCode({
    @required this.compoundCode,
    @required this.globalCode,
  });

  final String compoundCode;
  final String globalCode;

  PlusCode copyWith({
    String compoundCode,
    String globalCode,
  }) =>
      PlusCode(
        compoundCode: compoundCode ?? this.compoundCode,
        globalCode: globalCode ?? this.globalCode,
      );

  factory PlusCode.fromRawJson(String str) =>
      PlusCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode:
            json["compound_code"] == null ? null : json["compound_code"],
        globalCode: json["global_code"] == null ? null : json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode == null ? null : compoundCode,
        "global_code": globalCode == null ? null : globalCode,
      };
}

class Result {
  Result({
    @required this.addressComponents,
    @required this.formattedAddress,
    @required this.geometry,
    @required this.placeId,
    @required this.plusCode,
    @required this.types,
  });

  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  final Geometry geometry;
  final String placeId;
  final PlusCode plusCode;
  final List<String> types;

  Result copyWith({
    List<AddressComponent> addressComponents,
    String formattedAddress,
    Geometry geometry,
    String placeId,
    PlusCode plusCode,
    List<String> types,
  }) =>
      Result(
        addressComponents: addressComponents ?? this.addressComponents,
        formattedAddress: formattedAddress ?? this.formattedAddress,
        geometry: geometry ?? this.geometry,
        placeId: placeId ?? this.placeId,
        plusCode: plusCode ?? this.plusCode,
        types: types ?? this.types,
      );

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: json["address_components"] == null
            ? null
            : List<AddressComponent>.from(json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"] == null
            ? null
            : json["formatted_address"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"] == null ? null : json["place_id"],
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        types: json["types"] == null
            ? null
            : List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "address_components": addressComponents == null
            ? null
            : List<dynamic>.from(addressComponents.map((x) => x.toJson())),
        "formatted_address": formattedAddress == null ? null : formattedAddress,
        "geometry": geometry == null ? null : geometry.toJson(),
        "place_id": placeId == null ? null : placeId,
        "plus_code": plusCode == null ? null : plusCode.toJson(),
        "types": types == null ? null : List<dynamic>.from(types.map((x) => x)),
      };
}

class AddressComponent {
  AddressComponent({
    @required this.longName,
    @required this.shortName,
    @required this.types,
  });

  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponent copyWith({
    String longName,
    String shortName,
    List<String> types,
  }) =>
      AddressComponent(
        longName: longName ?? this.longName,
        shortName: shortName ?? this.shortName,
        types: types ?? this.types,
      );

  factory AddressComponent.fromRawJson(String str) =>
      AddressComponent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"] == null ? null : json["long_name"],
        shortName: json["short_name"] == null ? null : json["short_name"],
        types: json["types"] == null
            ? null
            : List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName == null ? null : longName,
        "short_name": shortName == null ? null : shortName,
        "types": types == null ? null : List<dynamic>.from(types.map((x) => x)),
      };
}

class Geometry {
  Geometry({
    @required this.location,
    @required this.locationType,
    @required this.viewport,
    @required this.bounds,
  });

  final Location location;
  final LocationType locationType;
  final Bounds viewport;
  final Bounds bounds;

  Geometry copyWith({
    Location location,
    LocationType locationType,
    Bounds viewport,
    Bounds bounds,
  }) =>
      Geometry(
        location: location ?? this.location,
        locationType: locationType ?? this.locationType,
        viewport: viewport ?? this.viewport,
        bounds: bounds ?? this.bounds,
      );

  factory Geometry.fromRawJson(String str) =>
      Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        locationType: json["location_type"] == null
            ? null
            : locationTypeValues.map[json["location_type"]],
        viewport:
            json["viewport"] == null ? null : Bounds.fromJson(json["viewport"]),
        bounds: json["bounds"] == null ? null : Bounds.fromJson(json["bounds"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location == null ? null : location.toJson(),
        "location_type": locationType == null
            ? null
            : locationTypeValues.reverse[locationType],
        "viewport": viewport == null ? null : viewport.toJson(),
        "bounds": bounds == null ? null : bounds.toJson(),
      };
}

class Bounds {
  Bounds({
    @required this.northeast,
    @required this.southwest,
  });

  final Location northeast;
  final Location southwest;

  Bounds copyWith({
    Location northeast,
    Location southwest,
  }) =>
      Bounds(
        northeast: northeast ?? this.northeast,
        southwest: southwest ?? this.southwest,
      );

  factory Bounds.fromRawJson(String str) => Bounds.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        northeast: json["northeast"] == null
            ? null
            : Location.fromJson(json["northeast"]),
        southwest: json["southwest"] == null
            ? null
            : Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast == null ? null : northeast.toJson(),
        "southwest": southwest == null ? null : southwest.toJson(),
      };
}

class Location {
  Location({
    @required this.lat,
    @required this.lng,
  });

  final double lat;
  final double lng;

  Location copyWith({
    double lat,
    double lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lng: json["lng"] == null ? null : json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
      };
}

enum LocationType { ROOFTOP, GEOMETRIC_CENTER, APPROXIMATE }

final locationTypeValues = EnumValues({
  "APPROXIMATE": LocationType.APPROXIMATE,
  "GEOMETRIC_CENTER": LocationType.GEOMETRIC_CENTER,
  "ROOFTOP": LocationType.ROOFTOP
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
