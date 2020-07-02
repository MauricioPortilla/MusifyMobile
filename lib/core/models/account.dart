import 'dart:io';

import 'package:musify/core/models/accountsong.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/models/subscription.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';
import 'package:musify/core/session.dart';

class Account {
    final int accountId;
    final String email;
    final String password;
    final String name;
    final String lastName;
    final DateTime creationDate;
    Artist artist;
    List<Playlist> playlists = <Playlist>[];
    List<AccountSong> accountSongs = <AccountSong>[];
    Subscription subscription;

    Account({
        this.accountId,
        this.email,
        this.password,
        this.name,
        this.lastName,
        this.creationDate
    });

    factory Account.fromJson(Map<String, dynamic> json) {
        return Account(
            accountId: json["account_id"],
            email: json["email"],
            password: json["password"],
            name: json["name"],
            lastName: json["last_name"],
            creationDate: DateTime.parse(json["creation_date"])
        );
    }

    static void login(
        String email, 
        String password, 
        onSuccess(Account account), 
        onFailure(NetworkResponse errorResponse),
        onError()
    ) {
        var data = {
            "email": email,
            "password": password
        };
        Network.post("/auth/login", data, (response) {
            Session.accessToken = response.json["access_token"];
            Account account = Account.fromJson(response.data);
            Session.account = account;
            onSuccess(account);
        }, onFailure, () {
            print("Exception@Account->login()");
            onError();
        });
    }

    static void loginWithGoogle(
        String accessToken, 
        onSuccess(Account account), 
        onFailure(NetworkResponse errorResponse),
        onError()
    ) {
        var data = {
            "access_token": accessToken
        };
        Network.post("/auth/login/google", data, (response) {
            Session.accessToken = response.json["access_token"];
            Account account = Account.fromJson(response.data);
            Session.account = account;
            onSuccess(account);
        }, onFailure, () {
            print("Exception@Account->loginWithGoogle()");
            onError();
        });
    }

    void register(
        bool isArtist, 
        onSuccess(Account account), 
        onFailure(NetworkResponse errorResponse), 
        onError(), 
        { String artisticName = "" }
    ) {
        var data = {
            "email": email,
            "password": password,
            "name": name,
            "last_name": lastName,
            "is_artist": isArtist,
            "artistic_name": artisticName == "" ? null : artisticName
        };
        Network.post("/auth/register", data, (response) {
            onSuccess(Account.fromJson(response.data));
        }, onFailure, () {
            print("Exception@Account->register()");
            onError();
        });
    }

    void registerWithGoogle(
        String accessToken,
        bool isArtist, 
        onSuccess(Account account), 
        onFailure(NetworkResponse errorResponse), 
        onError(), 
        { String artisticName = "" }
    ) {
        var data = {
            "access_token": accessToken,
            "is_artist": isArtist,
            "artistic_name": artisticName == "" ? null : artisticName
        };
        Network.post("/auth/register/google", data, (response) {
            onSuccess(Account.fromJson(response.data));
        }, onFailure, () {
            print("Exception@Account->registerWithGoogle()");
            onError();
        });
    }

    Future<List<Playlist>> fetchPlaylists() async {
        var data = {
            "{accountId}": accountId    
        };
        try {
            NetworkResponse response = await Network.futureGet("/account/{accountId}/playlists", data);
            playlists.clear();
            if (response.status == "success") {
                for (var playlistJson in response.data) {
                    playlists.add(Playlist.fromJson(playlistJson));
                }
            }
            return playlists;
        } catch (exception) {
            throw exception;
        }
    }

    Future fetchArtist() async {
        var data = {
            "{accountId}": accountId    
        };
        try {
            NetworkResponse response = await Network.futureGet("/account/{accountId}/artist", data);
            if (response.status == "success") {
                artist = Artist.fromJson(response.data);
            }
        } catch (exception) {
            throw exception;
        }
    }

    Future<List<AccountSong>> fetchAccountSongs() async {
        var data = {
            "{accountId}": accountId
        };
        try {
            NetworkResponse response = await Network.futureGet("/account/{accountId}/accountsongs", data);
            accountSongs.clear();
            if (response.status == "success") {
                for (var accountSongJson in response.data) {
                    accountSongs.add(AccountSong.fromJson(accountSongJson));
                }
            }
            return accountSongs;
        } catch (exception) {
            throw exception;
        }
    }

    void addAccountSongs(List<File> files, onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "{accountId}": accountId
        };
        Network.postMultimedia("/account/{accountId}/accountsongs", data, files, (response) {
            for (var accountSongJson in response.data) {
                accountSongs.add(AccountSong.fromJson(accountSongJson));
            }
            onSuccess();
        }, onFailure, () {
            onError();
            print("Exception@Account->addAccountSongs()");
        });
    }

    void deleteAccountSong(AccountSong accountSong, onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "{accountId}": accountId,
            "{accountSongId}": accountSong.accountSongId
        };
        Network.delete("/account/{accountId}/accountsong/{accountSongId}", data, (response) {
            accountSongs.remove(accountSong);
            onSuccess();
        }, onFailure, () {
            onError();
            print("Exception@Account->deleteAccountSong()");
        });
    }

    void likeSong(Song song, onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "account_id": accountId
        };
        Network.post("/song/${song.songId}/songlike", data, (response) {
            onSuccess();
        }, onFailure, () {
            onError();
            print("Exception@Account->likeSong()");
        });
    }

    void dislikeSong(Song song, onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "account_id": accountId
        };
        Network.post("/song/${song.songId}/songdislike", data, (response) {
            onSuccess();
        }, (errorResponse) {
            onFailure(errorResponse);
        }, () {
            onError();
            print("Exception@Account->dislikeSong()");
        });
    }

    Future<bool> hasLikedSong(Song song) async {
        try {
            NetworkResponse response = await Network.futureGet("/song/${song.songId}/songlike", null);
            return response.status == "success";
        } catch (exception) {
            print("Exception@Account->hasLikedSong()");
            throw exception;
        }
    }

    Future<bool> hasDislikedSong(Song song) async {
        try {
            NetworkResponse response = await Network.futureGet("/song/${song.songId}/songdislike", null);
            return response.status == "success";
        } catch (exception) {
            print("Exception@Account->hasDislikedSong()");
            throw exception;
        }
    }

    void unlikeSong(Song song, onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "account_id": accountId
        };
        Network.delete("/song/${song.songId}/songlike", data, (response) {
            onSuccess();
        }, onFailure, () {
            onError();
            print("Exception@Account->unlikeSong()");
        });
    }

    void undislikeSong(Song song, onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        var data = {
            "account_id": accountId
        };
        Network.delete("/song/${song.songId}/songdislike", data, (response) {
            onSuccess();
        }, onFailure, () {
            onError();
            print("Exception@Account->undislikeSong()");
        });
    }

    Future fetchSubscription() async {
        try {
            var response = await Network.futureGet("/subscription", null);
            if (response.status == "success") {
                subscription = Subscription.fromJson(response.data);
            }
        } catch (exception) {
            print("Exception@Account->fetchSubscription()");
            throw exception;
        }
    }

    void subscribe(onSuccess(), onFailure(NetworkResponse errorResponse), onError()) {
        Network.post("/subscription", null, (response) {
            subscription = Subscription.fromJson(response.data);
            onSuccess();
        }, onFailure, () {
            onError();
            print("Exception@Account->subscribe()");
        });
    }
}
