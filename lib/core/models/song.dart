import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/genre.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';

class Song {
    final int songId;
    final int albumId;
    Album album;
    final int genreId;
    Genre genre;
    final String title;
    final String duration;
    final String songLocation;
    final String status;

    Song({
        this.songId,
        this.albumId,
        this.album,
        this.genreId,
        this.genre,
        this.title,
        this.duration,
        this.songLocation,
        this.status
    });

    factory Song.fromJson(Map<String, dynamic> json) {
        return Song(
            songId: json["song_id"],
            albumId: json["album_id"],
            genreId: json["genre_id"],
            title: json["title"],
            duration: json["duration"],
            songLocation: json["song_location"],
            status: json["status"]
        );
    }

    Future<Album> loadAlbum() async {
        var data = {
            "{albumId}": albumId
        };
        NetworkResponse response = await Network.futureGet("/album/{albumId}", data);
        if (response.status == "success") {
            album = Album.fromJson(response.data);
        }
        return album;
    }

    static Future<List<Song>> fetchSongByTitleCoincidences(String title) async {
        var data = {
            "{title}": title
        };
        NetworkResponse response = await Network.futureGet("/song/search/{title}", data);
        List<Song> songs = <Song>[];
        if (response.status == "success") {
            for (var songResponse in response.data) {
                songs.add(Song.fromJson(songResponse));
            }
        }
        return songs;
    }
}
