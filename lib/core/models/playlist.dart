import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';

class Playlist {
    final int playlistId;
    final int accountId;
    final String name;
    List<Song> songs = <Song>[];

    Playlist({
        this.playlistId = 0,
        this.accountId,
        this.name
    });

    factory Playlist.fromJson(Map<String, dynamic> json) {
        return Playlist(
            playlistId: json["playlist_id"],
            accountId: json["account_id"],
            name: json["name"]
        );
    }

    Future<List<Song>> loadSongs() async {
        var data = {
            "{playlistId}": playlistId
        };
        NetworkResponse response = await Network.futureGet("/playlist/{playlistId}/songs", data);
        songs.clear();
        if (response.status == "success") {
            for (var songJson in response.data) {
                var song = Song.fromJson(songJson);
                Album album = await song.loadAlbum();
                await album.loadArtists();
                songs.add(song);
            }
        }
        return songs;
    }

    void save(onSuccess(Playlist playlist), onFailure(NetworkResponse errorResponse)) {
        try {
            var data = {
                "account_id": accountId,
                "name": name
            };
            if (playlistId == 0) {
                Network.post("/playlist", data, (response) {
                    onSuccess(Playlist.fromJson(response.data));
                }, (errorResponse) {
                    onFailure(errorResponse);
                });
            } else {
                Network.put("/playlist", data, (response) {
                    onSuccess(Playlist.fromJson(response.data));
                }, (errorResponse) {
                    onFailure(errorResponse);
                });
            }
        } catch (exception) {
            print("Exception@Playlist->save() -> $exception");
            throw exception;
        }
    }
}
