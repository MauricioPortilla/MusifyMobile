import 'package:musify/core/models/album.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';

class Artist {
    final int artistId;
    final int accountId;
    final String artisticName;
    List<Album> albums = <Album>[];

    Artist({
        this.artistId, 
        this.accountId, 
        this.artisticName
    });

    factory Artist.fromJson(Map<String, dynamic> json) {
        return Artist(
            artistId: json["artist_id"],
            accountId: json["account_id"],
            artisticName: json["artistic_name"]
        );
    }

    static Future<List<Artist>> fetchAlbumByArtisticNameCoincidences(String artisticName) async {
        List<Artist> artists = <Artist>[];
        if (artisticName.isEmpty) {
            return artists;
        }
        var data = {
            "{artisticName}": artisticName
        };
        NetworkResponse response = await Network.futureGet("/artist/search/{artisticName}", data);
        if (response.status == "success") {
            for (var artistResponse in response.data) {
                var artist = Artist.fromJson(artistResponse);
                artists.add(artist);
            }
        }
        return artists;
    }

    Future<List<Album>> fetchAlbums() async {
        var data = {
            "{artistId}": artistId
        };
        NetworkResponse response = await Network.futureGet("/artist/{artistId}/albums", data);
        if (response.status == "success") {
            albums.clear();
            for (var albumResponse in response.data) {
                var album = Album.fromJson(albumResponse);
                await album.fetchSongs();
                await album.fetchArtists();
                albums.add(album);
            }
        }
        return albums;
    }
}
