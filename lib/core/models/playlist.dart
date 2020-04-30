import 'package:musify/core/models/song.dart';

class Playlist {
    final int playlistId;
    final int accountId;
    final String name;
    List<Song> songs = <Song>[];

    Playlist({
        this.playlistId,
        this.accountId,
        this.name,
        this.songs
    });

    factory Playlist.fromJson(Map<String, dynamic> json) {
        return Playlist(
            playlistId: json["playlist_id"],
            accountId: json["account_id"],
            name: json["name"]
        );
    }
}
