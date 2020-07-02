import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/song.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    test("TEST: Save album", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Artist artist = Artist(artistId: 1);
            Album album = Album(type: "Sencillo", name: "Álbum 1", launchYear: 2020, discography: "Discografía 1");
            album.artists = [artist];
            Song song = Song(genreId: 1, title: "Canción 1");
            song.artists = [artist];
            album.songs = [song];
            File imageFile = File('/storage/emulated/0/Download/Imagen1.png');
            List<File> songsFile = [File('/storage/emulated/0/Download/Canción1.mp3')];
            album.save(imageFile, songsFile, expectAsync0(() {
                expect(true, true);
            }), (errorResponse) {
                fail("Could not save album");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
    
    test("TEST: Fetch artists", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Album album = Album(albumId: 1);
            var artists = await album.fetchArtists();
            expect(artists != null && artists.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch all album songs", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Album album = Album(albumId: 1);
            var songs = await album.fetchSongs();
            expect(songs.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch by title coincidences", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var albums = await Album.fetchAlbumByNameCoincidences("Ori");
            expect(albums.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
}