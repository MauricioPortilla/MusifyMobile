import 'package:musify/core/models/playlist.dart';
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
    List<Playlist> playlists = <Playlist>[];

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
        onFailure(NetworkResponse errorResponse)
    ) {
        var data = {
            "email": email,
            "password": password
        };
        try {
            Network.post("/auth/login", data, (response) {
                Session.accessToken = response.json["access_token"];
                onSuccess(Account.fromJson(response.data));
            }, (errorResponse) {
                onFailure(errorResponse);
            });
        } catch (exception) {
            print("Exception@Account->login() -> $exception");
        }
    }

    static void loginWithGoogle(String accessToken, onSuccess(Account account), onFailure(NetworkResponse errorResponse)) {
        var data = {
            "access_token": accessToken
        };
        try {
            Network.post("/auth/login/google", data, (response) {
                Session.accessToken = response.json["access_token"];
                onSuccess(Account.fromJson(response.data));
            }, (errorResponse) {
                onFailure(errorResponse);
            });
        } catch (exception) {
            print("Exception@Account->loginWithGoogle() -> $exception");
        }
    }

    Future<List<Playlist>> loadPlaylists() async {
        var data = {
            "{accountId}": accountId    
        };
        NetworkResponse response = await Network.futureGet("/account/{accountId}/playlists", data);
        playlists.clear();
        if (response.status == "success") {
            for (var playlistJson in response.data) {
                playlists.add(Playlist.fromJson(playlistJson));
            }
        }
        return playlists;
    }
}
