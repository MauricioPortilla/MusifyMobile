import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/models/accountsong.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/networkresponse.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    test("TEST: Login successful with true credentials", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) {
            expect(account != null, true);
        }), (errorResponse) {
            fail("Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Login not successful with false credentials", () {
        Account.login("freya@arkanapp.com", "12300", (account) {
            fail("Successful login");
        }, expectAsync1<void, NetworkResponse>((errorResponse) {
            expect(errorResponse != null, true);
        }), () {
            fail("Exception raised");
        });
    });

    test("TEST: Register successful with no artist data", () {
        Account account = Account(
            email: "kyara@arkanapp.com", 
            password: "1234", 
            name: "Kyara", 
            lastName: "Cothran"
        );
        account.register(false, expectAsync1<void, Account>((account) {
            expect(account != null, true);
        }), (errorResponse) {
            fail("Unsuccessful register");
        }, () {
            fail("Unsuccessful register");
        });
    });

    test("TEST: Register successful with artist data", () {
        Account account = Account(
            email: "kyara2@arkanapp.com", 
            password: "1234", 
            name: "Kyara", 
            lastName: "Cothran"
        );
        account.register(true, expectAsync1<void, Account>((account) {
            expect(account != null, true);
        }), (errorResponse) {
            fail("Unsuccessful register");
        }, () {
            fail("Unsuccessful register");
        }, artisticName: "Kyara");
    });

    test("TEST: Register not successful with no artist data - Reason: Registered email", () {
        Account account = Account(
            email: "kyara@arkanapp.com", 
            password: "1234", 
            name: "Kyara", 
            lastName: "Cothran"
        );
        account.register(false, (account) {
            fail("Successful register");
        }, expectAsync1<void, NetworkResponse>((errorResponse) {
            expect(errorResponse != null, true);
        }), () {
            fail("Exception raised");
        });
    });

    test("TEST: Register not successful with artist data - Reason: Registered artist", () {
        Account account = Account(
            email: "kyara3@arkanapp.com", 
            password: "1234", 
            name: "Kyara", 
            lastName: "Cothran"
        );
        account.register(true, (account) {
            fail("Successful register");
        }, expectAsync1<void, NetworkResponse>((errorResponse) {
            expect(errorResponse != null, true);
        }), () {
            fail("Exception raised");
        }, artisticName: "Kyara");
    });

    test("TEST: Fetch playlists", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var playlists = await account.fetchPlaylists();
            expect(playlists != null, true);
        }), (errorResponse) {
            fail("Playlist not fetched. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch artist", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            await account.fetchArtist();
            expect(account.artist != null, true);
        }), (errorResponse) {
            fail("Artist not fetched. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch account songs", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var accountSongs = await account.fetchAccountSongs();
            expect(accountSongs != null, true);
        }), (errorResponse) {
            fail("Account songs not fetched. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Add account songs", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            List<File> songsFile = [File('/storage/emulated/0/Download/CanciónCuenta1.mp3')];
            account.addAccountSongs(songsFile, expectAsync0(() {
                expect(true, true);
            }), (errorResponse) {
                fail("Song not rated. Unsuccessful like");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Account songs not fetched. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Delete account song", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            AccountSong accountSong = AccountSong(
                accountId: account.accountId, 
                accountSongId: 1
            );
            account.deleteAccountSong(accountSong, expectAsync0(() {
                expect(true, true);
            }), (errorResponse) {
                fail("Song not rated. Unsuccessful like");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Account songs not fetched. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
    
    test("TEST: Song rate: Like", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var song = Song(songId: 1);
            account.likeSong(song, expectAsync0(() async {
                var hasLikedSong = await account.hasLikedSong(song);
                expect(hasLikedSong == true, true);
            }), (errorResponse) {
                fail("Song not rated. Unsuccessful like");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Song not rated. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Song rate: Dislike", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var song = Song(songId: 1);
            account.dislikeSong(song, expectAsync0(() async {
                var hasDislikedSong = await account.hasDislikedSong(song);
                expect(hasDislikedSong == true, true);
            }), (errorResponse) {
                fail("Song not rated. Unsuccessful dislike");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Song not rated. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Song unrate: Like", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var song = Song(songId: 1);
            account.unlikeSong(song, expectAsync0(() async {
                var hasLikedSong = await account.hasLikedSong(song);
                expect(hasLikedSong == false, true);
            }), (errorResponse) {
                fail("Song not unrated. Unsuccessful unlike");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Song not unrated. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
    
    test("TEST: Song unrate: Dislike", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            var song = Song(songId: 1);
            account.undislikeSong(song, expectAsync0(() async {
                var hasDislikedSong = await account.hasDislikedSong(song);
                expect(hasDislikedSong == false, true);
            }), (errorResponse) {
                fail("Song not unrated. Unsuccessful undislike");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Song not unrated. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
    
    test("TEST: Subscribe", () {
        Account.login("kyara@arkanapp.com", "1234", expectAsync1<void, Account>((account) async {
            account.subscribe(expectAsync0(() {
                expect(account.subscription != null, true);
            }), (errorResponse) {
                fail("Account not subscribed. Unsuccessful subscription");
            }, () {
                fail("Exception raised");
            });
        }), (errorResponse) {
            fail("Account not subscribed. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });

    test("TEST: Fetch subscription", () {
        Account.login("freya@arkanapp.com", "1230", expectAsync1<void, Account>((account) async {
            await account.fetchSubscription();
            expect(account.subscription != null, true);
        }), (errorResponse) {
            fail("Subscription not fetched. Unsuccessful login");
        }, () {
            fail("Exception raised");
        });
    });
}
