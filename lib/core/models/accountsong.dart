import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';
import 'package:musify/core/session.dart';

class AccountSong {
    final int accountSongId;
    final int accountId;
    final String title;
    final String duration;
    final String songLocation;
    final DateTime uploadDate;

    AccountSong({
        this.accountSongId,
        this.accountId,
        this.title,
        this.duration,
        this.songLocation,
        this.uploadDate
    });

    factory AccountSong.fromJson(Map<String, dynamic> json) {
        return AccountSong(
            accountSongId: json["account_song_id"],
            accountId: json["account_id"],
            title: json["title"],
            duration: json["duration"],
            songLocation: json["song_location"],
            uploadDate: DateTime.parse(json["upload_date"])
        );
    }

    static void fetchAccountSongById(
        int accountSongId, onSuccess(AccountSong accountSong), 
        onFailure(NetworkResponse errorResponse), 
        onError()
    ) {
        Network.get("/account/${Session.account.accountId}/accountsong/$accountSongId", null, (response) async {
            var accountSong = AccountSong.fromJson(response.data);
            onSuccess(accountSong);
        }, onFailure, () {
            print("Exception@AccountSong->fetchAccountSongById()");
            onError();
        });
    }
}
