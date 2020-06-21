import 'dart:io';
import 'dart:typed_data';

import 'package:musify/core/core.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/genre.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';
import 'package:musify/core/session.dart';
import 'package:path_provider/path_provider.dart';

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
    List<Artist> artists = <Artist>[];

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

    factory Song.json(Map<String, dynamic> json) {
        return Song(
            songLocation: json["name"],
            duration: json["duration"]
        );
    }

    Future<Album> fetchAlbum() async {
        var data = {
            "{albumId}": albumId
        };
        NetworkResponse response = await Network.futureGet("/album/{albumId}", data);
        if (response.status == "success") {
            album = Album.fromJson(response.data);
        }
        return album;
    }

    Future<Genre> fetchGenre() async {
        var data = {
            "{genreId}": genreId
        };
        NetworkResponse response = await Network.futureGet("/genre/{genreId}", data);
        if (response.status == "success") {
            genre = Genre.fromJson(response.data);
        }
        return genre;
    }

    Future<List<Artist>> fetchArtists() async {
        var data = {
            "{songId}": songId
        };
        NetworkResponse response = await Network.futureGet("/song/{songId}/artists", data);
        if (response.status == "success") {
            artists.clear();
            for (var artistResponse in response.data) {
                artists.add(Artist.fromJson(artistResponse));
            }
        }
        return artists;
    }

    static Future<List<Song>> fetchSongByTitleCoincidences(String title) async {
        List<Song> songs = <Song>[];
        if (title.isEmpty) {
            return songs;
        }
        var data = {
            "{title}": title
        };
        NetworkResponse response = await Network.futureGet("/song/search/{title}", data);
        if (response.status == "success") {
            for (var songResponse in response.data) {
                var song = Song.fromJson(songResponse);
                Album album = await song.fetchAlbum();
                await album.fetchArtists();
                await song.fetchGenre();
                await song.fetchArtists();
                songs.add(song);
            }
        }
        return songs;
    }

    static void fetchSongById(
        int songId, onSuccess(Song song), 
        onFailure(NetworkResponse errorResponse), 
        onError()
    ) {
        try {
            Network.get("/song/$songId", null, (response) async {
                var song = Song.fromJson(response.data);
                Album album = await song.fetchAlbum();
                await album.fetchArtists();
                await song.fetchGenre();
                await song.fetchArtists();
                onSuccess(song);
            }, (errorResponse) {
                onFailure(errorResponse);
            });
        } catch (exception) {
            onError();
        }
    }

    Future<void> fetchSongBuffer(onSuccess(Uint8List buffer), onFailure(errorResponse)) async {
        String songStreamingQuality = Session.songStreamingQuality;
        if (Session.songStreamingQuality == "automaticquality") {
            songStreamingQuality = "lowquality";
            final networkSpeed = await Core.calculateNetworkSpeed();
            if (networkSpeed == -1 || (networkSpeed >= 20 && networkSpeed <= 40)) {
                songStreamingQuality = "mediumquality";
            } else if (networkSpeed > 40) {
                songStreamingQuality = "highquality";
            }
        }
        Network.getStreamBuffer("/stream/song/$songId/$songStreamingQuality", null, (buffer) {
            onSuccess(buffer);
        }, (errorResponse) {
            onFailure(errorResponse);
        });
    }

    Future<bool> isDownloaded() async {
        Directory musifyDirectory = await getApplicationDocumentsDirectory();
        File songFile = File("${musifyDirectory.path}/$songId.bin");
        return await songFile.exists();
    }

    Future<Uint8List> getDownloadedSongFileContent() async {
        Directory musifyDirectory = await getApplicationDocumentsDirectory();
        File songFile = File("${musifyDirectory.path}/$songId.bin");
        return await songFile.readAsBytes();
    }

    String artistsNames() {
        String artistsNames = "";
        for (Artist artist in artists) {
            if (artistsNames.isNotEmpty) {
                artistsNames += ", ";
            }
            artistsNames += artist.artisticName;
        }
        return artistsNames;
    }
}
