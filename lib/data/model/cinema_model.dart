class Cinema {
  final String id;
  final String title;
  final String subtitle;
  final String images;
  final double rating;
  final int year;
  final String length;
  final List<String> genre;
  final String director;
  final List<Actor> actors;
  final String description;
  final String trailer;

  Cinema({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.images,
    required this.rating,
    required this.year,
    required this.length,
    required this.genre,
    required this.director,
    required this.actors,
    required this.description,
    required this.trailer,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) => Cinema(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        images: json["images"],
        rating: json["rating"]?.toDouble(),
        year: json["year"],
        length: json["length"],
        genre: List<String>.from(json["genre"].map((x) => x)),
        director: json["director"],
        actors: List<Actor>.from(json["actors"].map((x) => Actor.fromJson(x))),
        description: json["description"],
        trailer: json["trailer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "images": images,
        "rating": rating,
        "year": year,
        "length": length,
        "genre": List<dynamic>.from(genre.map((x) => x)),
        "director": director,
        "actors": List<dynamic>.from(actors.map((x) => x.toJson())),
        "description": description,
        "trailer": trailer,
      };
}

class Actor {
  final String name;
  final String image;

  Actor({
    required this.name,
    required this.image,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}
