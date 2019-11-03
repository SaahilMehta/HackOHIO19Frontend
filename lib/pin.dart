class Pin {
  int color, downVotes, upVotes, totalScore, id;
  double rating, latitude, longitude;
  String datetime, description, title;

  Pin(
      {this.color,
      this.downVotes,
      this.upVotes,
      this.totalScore,
      this.id,
      this.latitude,
      this.longitude,
      this.rating,
      this.datetime,
      this.description,
      this.title});

  factory Pin.fromJson(Map<String, dynamic> dict) {
    return Pin(
        color: dict['color'],
        downVotes: dict['downVotes'],
        upVotes: dict['upVotes'],
        totalScore: dict['totalScore'],
        id: dict['id'],
        latitude: dict['latitude'],
        longitude: dict['longitude'],
        rating: dict['rating'],
        datetime: dict['datetime'],
        description: dict['description'],
        title: dict['title']);
  }
}

class Pins {
  List<Pin> pins;

  Pins({this.pins});

  factory Pins.fromJson(Map<String, dynamic> dict) {
    List<Pin> pins = List<Pin>();
    pins = dict['pins'].map<Pin>((x) => Pin.fromJson(x)).toList();
    return Pins(pins: pins);
  }
}
