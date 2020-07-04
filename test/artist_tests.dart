import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/models/artist.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    test("TEST: Fetch artists by starting artistic name", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var artists = await Artist.fetchArtistsByArtisticNameCoincidences("Fre");
            expect(artists.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch artist albums", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            Artist artist = Artist(artistId: 1);
            var albums = await artist.fetchAlbums();
            expect(albums.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
}
