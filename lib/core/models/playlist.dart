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
}
