class Genre {
    final int genreId;
    final String name;

    Genre({this.genreId, this.name});

    factory Genre.fromJson(Map<String, dynamic> json) {
        return Genre(
            genreId: json["genre_id"],
            name: json["name"]
        );
    }
}
