class Location {
  double lat;
  double lng;
  Location({required this.lat, required this.lng});
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(lat: json['lat']! as double, lng: json['lng']! as double);
  }
}
