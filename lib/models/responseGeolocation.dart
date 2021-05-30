// To parse this JSON data, do
//
//     final responseGeolocator = responseGeolocatorFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class ResponseGeolocator {
  ResponseGeolocator({
    @required this.data,
  });

  final List<Datum> data;

  ResponseGeolocator copyWith({
    List<Datum> data,
  }) =>
      ResponseGeolocator(
        data: data ?? this.data,
      );

  factory ResponseGeolocator.fromRawJson(String str) =>
      ResponseGeolocator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseGeolocator.fromJson(Map<String, dynamic> json) =>
      ResponseGeolocator(
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    @required this.latitude,
    @required this.longitude,
    @required this.type,
    @required this.distance,
    @required this.name,
    @required this.number,
    @required this.postalCode,
    @required this.street,
    @required this.confidence,
    @required this.region,
    @required this.regionCode,
    @required this.county,
    @required this.locality,
    @required this.administrativeArea,
    @required this.neighbourhood,
    @required this.country,
    @required this.countryCode,
    @required this.continent,
    @required this.label,
  });

  final double latitude;
  final double longitude;
  final String type;
  final double distance;
  final String name;
  final String number;
  final String postalCode;
  final String street;
  final double confidence;
  final String region;
  final String regionCode;
  final String county;
  final String locality;
  final String administrativeArea;
  final dynamic neighbourhood;
  final String country;
  final String countryCode;
  final String continent;
  final String label;

  Datum copyWith({
    double latitude,
    double longitude,
    String type,
    double distance,
    String name,
    String number,
    String postalCode,
    String street,
    double confidence,
    String region,
    String regionCode,
    String county,
    String locality,
    String administrativeArea,
    dynamic neighbourhood,
    String country,
    String countryCode,
    String continent,
    String label,
  }) =>
      Datum(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        type: type ?? this.type,
        distance: distance ?? this.distance,
        name: name ?? this.name,
        number: number ?? this.number,
        postalCode: postalCode ?? this.postalCode,
        street: street ?? this.street,
        confidence: confidence ?? this.confidence,
        region: region ?? this.region,
        regionCode: regionCode ?? this.regionCode,
        county: county ?? this.county,
        locality: locality ?? this.locality,
        administrativeArea: administrativeArea ?? this.administrativeArea,
        neighbourhood: neighbourhood ?? this.neighbourhood,
        country: country ?? this.country,
        countryCode: countryCode ?? this.countryCode,
        continent: continent ?? this.continent,
        label: label ?? this.label,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        type: json["type"] == null ? null : json["type"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        name: json["name"] == null ? null : json["name"],
        number: json["number"] == null ? null : json["number"],
        postalCode: json["postal_code"] == null ? null : json["postal_code"],
        street: json["street"] == null ? null : json["street"],
        confidence:
            json["confidence"] == null ? null : json["confidence"].toDouble(),
        region: json["region"] == null ? null : json["region"],
        regionCode: json["region_code"] == null ? null : json["region_code"],
        county: json["county"] == null ? null : json["county"],
        locality: json["locality"] == null ? null : json["locality"],
        administrativeArea: json["administrative_area"] == null
            ? null
            : json["administrative_area"],
        neighbourhood: json["neighbourhood"],
        country: json["country"] == null ? null : json["country"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        continent: json["continent"] == null ? null : json["continent"],
        label: json["label"] == null ? null : json["label"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "type": type == null ? null : type,
        "distance": distance == null ? null : distance,
        "name": name == null ? null : name,
        "number": number == null ? null : number,
        "postal_code": postalCode == null ? null : postalCode,
        "street": street == null ? null : street,
        "confidence": confidence == null ? null : confidence,
        "region": region == null ? null : region,
        "region_code": regionCode == null ? null : regionCode,
        "county": county == null ? null : county,
        "locality": locality == null ? null : locality,
        "administrative_area":
            administrativeArea == null ? null : administrativeArea,
        "neighbourhood": neighbourhood,
        "country": country == null ? null : country,
        "country_code": countryCode == null ? null : countryCode,
        "continent": continent == null ? null : continent,
        "label": label == null ? null : label,
      };
}
