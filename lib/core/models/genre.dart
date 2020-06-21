import 'package:musify/core/models/song.dart';

import '../network.dart';
import '../networkresponse.dart';
import 'album.dart';

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

    static Future<List<Genre>> fetchGenreById(List<int> genresId) async {
        List<Genre> genres = <Genre>[];
        for (var genreId in genresId){
            var data = {
                "{genre_id}": genreId
            };
            NetworkResponse response = await Network.futureGet("/genre/{genre_id}", data);
            var genre;
            if (response.status == "success") {
                genre = Genre.fromJson(response.data);
                genres.add(genre);
            }
        }
        return genres;
    }

    static Future<List<Genre>> fetchAll() async {
        List<Genre> genres = <Genre>[];
        NetworkResponse response = await Network.futureGet("/genres", null);
        if (response.status == "success") {
            for (var genreJson in response.data) {
                var genre = Genre.fromJson(genreJson);
                genres.add(genre);
            }
        }
        return genres;
    }

    Future<List<Song>> fetchSongs() async {
        List<Song> songs = <Song>[];
        var data = {
            "{genre_id}": genreId
        };
        NetworkResponse response = await Network.futureGet("/genre/{genre_id}/songs", data);
        if (response.status == "success") {
            for (var songJson in response.data) {
                var song = Song.fromJson(songJson);
                Album album = await song.fetchAlbum();
                await album.fetchArtists();
                await song.fetchGenre();
                await song.fetchArtists();
                songs.add(song);
            }
        }
        return songs;
    }
}
