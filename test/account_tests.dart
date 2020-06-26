import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/models/song.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    test("TEST: Login successful with true credentials", () {
        Account.login("mlum@arkanapp.com", "1234", (account) {
            expect(account != null, true);
        }, (errorResponse) {
            fail("Unsuccessful login");
        });
    });
    test("TEST: Login not successful with false credentials", () {
        Account.login("mlum@arkanapp.com", "123450", (account) {
            fail("Successful login");
        }, (errorResponse) {
            expect(errorResponse != null, true);
        });
    });
    test("TEST: Register successful with no artist data", () {
        Account account = Account(
            email: "kyara@arkanapp.com", password: "1234", 
            name: "Kyara", lastName: "Cothran"
        );
        account.register(false, (account) {
            expect(account != null, true);
        }, (errorResponse) {
            fail("Unsuccessful register");
        }, () {
            fail("Unsuccessful register");
        });
    });
    test("TEST: Register successful with artist data", () {
        Account account = Account(
            email: "kyara2@arkanapp.com", password: "1234", 
            name: "Kyara", lastName: "Cothran"
        );
        account.register(true, (account) {
            expect(account != null, true);
        }, (errorResponse) {
            fail("Unsuccessful register");
        }, () {
            fail("Unsuccessful register");
        }, artisticName: "Kyara");
    });
    test("TEST: Register not successful with no artist data - Reason: Registered email", () {
        Account account = Account(
            email: "kyara@arkanapp.com", password: "1234", 
            name: "Kyara", lastName: "Cothran"
        );
        account.register(false, (account) {
            fail("Successful register");
        }, (errorResponse) {
            expect(errorResponse != null, true);
        }, () {
            fail("Exception raised");
        });
    });
    test("TEST: Register not successful with artist data - Reason: Registered artist", () {
        Account account = Account(
            email: "kyara3@arkanapp.com", password: "1234", 
            name: "Kyara", lastName: "Cothran"
        );
        account.register(true, (account) {
            fail("Successful register");
        }, (errorResponse) {
            expect(errorResponse != null, true);
        }, () {
            fail("Exception raised");
        }, artisticName: "Kyara");
    });
    test("TEST: Fetch playlists", () {
        Account.login("mlum@arkanapp.com", "1234", (account) async {
            var playlists = await account.fetchPlaylists();
            expect(playlists != null, true);
        }, (errorResponse) {
            fail("Playlist not fetched. Unsuccessful login");
        });
    });
    test("TEST: Fetch artist", () {
        Account.login("mlum@arkanapp.com", "1234", (account) async {
            var artist = await account.fetchArtist();
            expect(artist != null, true);
        }, (errorResponse) {
            fail("Artist not fetched. Unsuccessful login");
        });
    });
    test("TEST: Fetch account songs", () {
        Account.login("mlum@arkanapp.com", "1234", (account) async {
            var accountSongs = await account.fetchAccountSongs();
            expect(accountSongs != null, true);
        }, (errorResponse) {
            fail("Account songs not fetched. Unsuccessful login");
        });
    });
    test("TEST: Song rate: Like", () {
        Account.login("mlum@arkanapp.com", "1234", (account) async {
            var song = Song(songId: 1);
            account.likeSong(song, () async {
                var hasLikedSong = await account.hasLikedSong(song);
                expect(hasLikedSong == true, true);
            }, (errorResponse) {
                fail("Song not rated. Unsuccessful like");
            }, () {
                fail("Exception raised");
            });
        }, (errorResponse) {
            fail("Song not rated. Unsuccessful login");
        });
    });
    test("TEST: Song rate: Dislike", () {
        Account.login("mlum@arkanapp.com", "1234", (account) async {
            var song = Song(songId: 1);
            account.dislikeSong(song, () async {
                var hasDislikedSong = await account.hasDislikedSong(song);
                expect(hasDislikedSong == true, true);
            }, (errorResponse) {
                fail("Song not rated. Unsuccessful dislike");
            }, () {
                fail("Exception raised");
            });
        }, (errorResponse) {
            fail("Song not rated. Unsuccessful login");
        });
    });
    test("TEST: Song unrate: Like", () {
        Account.login("mlum@arkanapp.com", "1234", (account) async {
            var song = Song(songId: 1);
            account.unlikeSong(song, () async {
                var hasLikedSong = await account.hasLikedSong(song);
                expect(hasLikedSong == false, true);
            }, (errorResponse) {
                fail("Song not unrated. Unsuccessful unlike");
            }, () {
                fail("Exception raised");
            });
        }, (errorResponse) {
            fail("Song not unrated. Unsuccessful login");
        });
    });
    test("TEST: Song unrate: Dislike", () {
        Account.login("mlum@arkanapp.com", "1234", (account) async {
            var song = Song(songId: 1);
            account.undislikeSong(song, () async {
                var hasDislikedSong = await account.hasDislikedSong(song);
                expect(hasDislikedSong == false, true);
            }, (errorResponse) {
                fail("Song not unrated. Unsuccessful undislike");
            }, () {
                fail("Exception raised");
            });
        }, (errorResponse) {
            fail("Song not unrated. Unsuccessful login");
        });
    });
    test("TEST: Subscribe", () {
        Account.login("mlum@arkanapp.com", "1234", (account) async {
            account.subscribe(() {
                expect(account.subscription != null, true);
            }, (errorResponse) {
                fail("Account not subscribed. Unsuccessful subscription");
            }, () {
                fail("Exception raised");
            });
        }, (errorResponse) {
            fail("Account not subscribed. Unsuccessful login");
        });
    });
    test("TEST: Fetch subscription", () {
        Account.login("mlum@arkanapp.com", "1234", (account) async {
            var subscription = await account.fetchSubscription();
            expect(subscription != null, true);
        }, (errorResponse) {
            fail("Subscription not fetched. Unsuccessful login");
        });
    });
}
