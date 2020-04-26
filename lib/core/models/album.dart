import 'package:musify/core/models/artist.dart';

class Album {
    final int albumId;
    final String type;
    final String name;
    final int launchYear;
    final String discography;
    final String imageLocation;
    List<Artist> artists = <Artist>[];

    Album({
        this.albumId,
        this.type,
        this.name,
        this.launchYear,
        this.discography,
        this.imageLocation,
        this.artists
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
