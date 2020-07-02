import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';

class Playlist {
    final int playlistId;
    final int accountId;
    String name;
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

    Future<List<Song>> fetchSongs() async {
        var data = {
            "{playlistId}": playlistId
        };
        try {
            NetworkResponse response = await Network.futureGet("/playlist/{playlistId}/songs", data);
            songs.clear();
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
        } catch (exception) {
            print("Exception@Playlist->fetchSongs()");
            throw exception;
        }
    }

    void save(onSuccess(Playlist playlist), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "account_id": accountId,
            "name": name
        };
        if (playlistId == 0) {
            Network.post("/playlist", data, (response) {
                onSuccess(Playlist.fromJson(response.data));
            }, onFailure, () {
                print("Exception@Playlist->save()");
                onError();
            });
        } else {
            Network.put("/playlist", data, (response) {
                onSuccess(Playlist.fromJson(response.data));
            }, onFailure, () {
                print("Exception@Playlist->save()");
                onError();
            });
        }
    }

    void addSong(Song song, onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "{playlistId}": playlistId,
            "song_id": song.songId
        };
        Network.post("/playlist/{playlistId}/song", data, (response) {
            songs.add(song);
            onSuccess();
        }, onFailure, () {
            print("Exception@Playlist->addSong()");
            onError();
        });
    }

    void containsSong(Song song, onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "{playlistId}": playlistId,
            "{songId}": song.songId
        };
        Network.get("/playlist/{playlistId}/song/{songId}", data, (response) {
            onSuccess();
        }, onFailure, () {
            print("Exception@Playlist->containsSong()");
            onError();
        });
    }

    void delete(onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "{playlistId}": playlistId
        };
        Network.delete("/playlist/{playlistId}", data, (response) {
            onSuccess();
        }, onFailure, () {
            print("Exception@Playlist->delete()");
            onError();
        });
    }

    void deleteSong(Song song, onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "{playlistId}": playlistId,
            "{songId}": song.songId
        };
        Network.delete("/playlist/{playlistId}/songs/{songId}", data, (response) {
            songs.remove(song);
            onSuccess();
        }, onFailure, () {
            print("Exception@Playlist->deleteSong()");
            onError();
        });
    }
}
