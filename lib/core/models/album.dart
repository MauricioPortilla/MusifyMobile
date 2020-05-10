import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';

class Album {
    final int albumId;
    final String type;
    final String name;
    final int launchYear;
    final String discography;
    final String imageLocation;
    List<Artist> artists = <Artist>[];
    List<Song> songs = <Song>[];

    Album({
        this.albumId,
        this.type,
        this.name,
        this.launchYear,
        this.discography,
        this.imageLocation
    });

    factory Album.fromJson(Map<String, dynamic> json) {
        return Album(
            albumId: json["album_id"],
            type: json["type"],
            name: json["name"],
            launchYear: json["launch_year"],
            discography: json["discography"],
            imageLocation: json["image_location"]
        );
    }

    Future<List<Artist>> loadArtists() async {
        var data = {
            "{albumId}": albumId
        };
        NetworkResponse response = await Network.futureGet("/album/{albumId}/artists", data);
        artists.clear();
        if (response.status == "success") {
            for (var artistJson in response.data) {
                artists.add(Artist.fromJson(artistJson));
            }
        }
        return artists;
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
