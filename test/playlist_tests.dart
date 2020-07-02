import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/networkresponse.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    test("TEST: Fetch account playlists", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var playlist = (await account.fetchPlaylists());
            expect(playlist != null, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Create playlist", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) {
            Playlist newPlaylist = Playlist(accountId: account.accountId, name: "Playlist 1");
            newPlaylist.save(expectAsync1<void, Playlist>((playlist) {
                expect(playlist != null, true);
            }), (errorResponse) {
                fail("Playlist not created");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Rename playlist", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var playlist = (await account.fetchPlaylists()).first;
            playlist.name = "Renamed Playlist";
            playlist.save(expectAsync1<void, Playlist>((renamedPlaylist) {
                expect(renamedPlaylist.name == "Renamed Playlist", true);
            }), (errorResponse) {
                fail("Playlist not renamed");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Add song", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var playlist = (await account.fetchPlaylists()).first;
            Song song = Song(songId: 1);
            playlist.addSong(song, expectAsync0(() {
                playlist.containsSong(song, expectAsync0(() {
                    expect(true, true);
                }), (errorResponse) {
                    fail("Song not added");
                }, () {
                    fail("Exception raised");
                });
            }), (errorResponse) {
                fail("Song not added");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Delete song", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var playlist = (await account.fetchPlaylists()).first;
            Song song = Song(songId: 1);
            playlist.deleteSong(song, expectAsync0(() {
                playlist.containsSong(song, () {
                    fail("Song not deleted");
                }, expectAsync1<void, NetworkResponse>((errorResponse) {
                    expect(errorResponse != null, true);
                }), () {
                    fail("Exception raised");
                });
            }), (errorResponse) {
                fail("Song not added");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
    
    test("TEST: Delete playlist", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var playlist = (await account.fetchPlaylists()).first;
            playlist.delete(expectAsync0(() async {
                var playlists = (await account.fetchPlaylists());
                expect(playlists.contains(playlist), false);
            }), (errorResponse) {
                fail("Playlist not deleted");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
}
