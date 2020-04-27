import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/song.dart';

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
        this.imageLocation,
        this.artists,
        this.songs
    });

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
