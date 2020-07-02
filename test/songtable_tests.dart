import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/models/songtable.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    test("TEST: Fetch songs by ID", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var songs = await SongTable.fetchSongsById([1]);
            expect(songs.length > 0, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
}