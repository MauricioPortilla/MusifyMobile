import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/models/accountsong.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    test("TEST: Fetch account song by ID", () {
        Account.login("mlum@arkanapp.com", "2602", expectAsync1<void, Account>((account) async {
            AccountSong.fetchAccountSongById(19, expectAsync1<void, AccountSong>((accountSong) {
                expect(accountSong != null, true);
            }), (errorResponse) {
                fail("Account song not fetched");
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
