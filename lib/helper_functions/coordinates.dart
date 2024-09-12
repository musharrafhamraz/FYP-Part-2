class CoordinatesClass {
  final List<Map<String, dynamic>> predefinedLocations = [
    {
      'placeName': 'Jutal',
      'latitudeMin': 36.0780,
      'latitudeMax': 36.1120,
      'longitudeMin': 74.3200,
      'longitudeMax': 74.3600,
    },
    {
      'placeName': 'Rahimabad',
      'latitudeMin': 36.1195,
      'latitudeMax': 36.1205,
      'longitudeMin': 74.2979,
      'longitudeMax': 74.2989,
    },
    {
      'placeName': 'Danyore',
      'latitudeMin': 36.1200,
      'latitudeMax': 36.1300,
      'longitudeMin': 74.3000,
      'longitudeMax': 74.3200,
    },
    {
      'placeName': 'Sultanabad',
      'latitudeMin': 36.0900,
      'latitudeMax': 36.1100,
      'longitudeMin': 74.3300,
      'longitudeMax': 74.3500,
    },
    {
      'placeName': 'Mohammadabad',
      'latitudeMin': 36.1000,
      'latitudeMax': 36.1200,
      'longitudeMin': 74.3100,
      'longitudeMax': 74.3300,
    },
    {
      'placeName': 'Gilgit',
      'latitudeMin': 35.9100,
      'latitudeMax': 35.9300,
      'longitudeMin': 74.3000,
      'longitudeMax': 74.3200,
    }
  ];

  String getPlaceNameFromPredefinedLocations(
      double latitude, double longitude) {
    for (var location in predefinedLocations) {
      if (latitude >= location['latitudeMin'] &&
          latitude <= location['latitudeMax'] &&
          longitude >= location['longitudeMin'] &&
          longitude <= location['longitudeMax']) {
        return location['placeName'];
      }
    }
    return 'Unknown'; // Default if no match is found
  }
}
