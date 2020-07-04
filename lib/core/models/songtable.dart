import 'package:musify/core/models/accountsong.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';
import 'package:musify/core/session.dart';

class SongTable {
    Song song;
    AccountSong accountSong;

    SongTable({
        this.song,
        this.accountSong
    });

    static Future<List<SongTable>> fetchSongsById(List<int> songsId) async {
        List<SongTable> songs = <SongTable>[];
        for (var songId in songsId) {
            if (songId > 0) {
                var data = {
                    "{song_id}": songId
                };
                NetworkResponse response = await Network.futureGet("/song/{song_id}", data);
                var song;
                if (response.status == "success") {
                    song = Song.fromJson(response.data);
                    Album album = await song.fetchAlbum();
                    await album.fetchArtists();
                    await song.fetchGenre();
                    await song.fetchArtists();
                    songs.add(SongTable (song: song));
                }
            } else {
                var data = {
                    "{account_id}": Session.account.accountId,
                    "{account_song_id}": (songId * -1)
                };
                NetworkResponse response = await Network.futureGet("/account/{account_id}/accountsong/{account_song_id}", data);
                var accountSongs;
                if (response.status == "success") {
                    accountSongs = AccountSong.fromJson(response.data);
                    songs.add(SongTable (accountSong: accountSongs));
                } else if (response.status == "failed") {
                    Session.songsIdPlayQueue.remove(songId);
                    Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                }
            }
        }
        return songs;
    }
}