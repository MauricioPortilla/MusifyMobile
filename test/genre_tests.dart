import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/models/genre.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    test("TEST: Fetch genres by ID", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var genres = await Genre.fetchGenresById([1]);
            expect(genres.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch all genres", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var genres = await Genre.fetchAll();
            expect(genres.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch all genre songs", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Genre genre = Genre(genreId: 1);
            var songs = await genre.fetchSongs();
            expect(songs.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
}