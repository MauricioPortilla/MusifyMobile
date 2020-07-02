import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/models/song.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    test("TEST: Fetch album", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Song song = Song(songId: 3, albumId: 3);
            var album = await song.fetchAlbum();
            expect(album != null, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch genre", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Song song = Song(songId: 1, genreId: 1);
            var genre = await song.fetchGenre();
            expect(genre != null, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch artists", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Song song = Song(songId: 1);
            var artists = await song.fetchArtists();
            expect(artists != null && artists.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch by title coincidences", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var songs = await Song.fetchSongByTitleCoincidences("Ori");
            expect(songs.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch by ID", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Song.fetchSongById(1, expectAsync1<void, Song>((song) {
                expect(song != null, true);
            }), (errorResponse) {
                fail("Could not fetch song");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch buffer", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Song song = Song(songId: 3);
            song.fetchSongBuffer(expectAsync1<void, Uint8List>((buffer) {
                expect(buffer.length > 0, true);
            }), (errorResponse) {
                fail("Could not fetch song buffer");
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
