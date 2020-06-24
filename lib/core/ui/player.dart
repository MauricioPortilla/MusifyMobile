import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flauto.dart';
import 'package:flutter_sound/flutter_sound_player.dart';
import 'package:musify/core/core.dart';
import 'package:musify/core/models/accountsong.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/screens/player_screen.dart';


class Player extends StatefulWidget {
    final _PlayerState state = _PlayerState();
    _PlayerState createState() {
        return state;
    }
}

class _PlayerState extends State<Player> {

    Song latestPlayedSong;
    AccountSong latestPlayedAccountSong;
    Uint8List latestPlayedSongBuffer;
    FlutterSoundPlayer player = FlutterSoundPlayer();
    double playerCurrentPosition = 0;
    double playerMaxPosition = 0;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                if (latestPlayedSong != null || latestPlayedAccountSong != null) {
                    Navigator.push(
                        context, MaterialPageRoute(
                            builder: (context) => PlayerScreen()
                        )
                    );
                }
            },
            child: Container(
                width: double.infinity,
                height: 80,
                child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    color: Colors.grey.shade300,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    GestureDetector(
                                        child: Text(
                                            latestPlayedSong == null ? (latestPlayedAccountSong != null ? latestPlayedAccountSong.title : "") : latestPlayedSong.title,
                                            style: TextStyle(
                                                fontSize: 15
                                            )
                                        ),
                                        onTap: () {},
                                    ),
                                    GestureDetector(
                                        child: Text(latestPlayedSong == null ? "" : latestPlayedSong.album.artistsNames()),
                                        onTap: () {},
                                    ),
                                ],
                            ),
                            Container(
                                child: Row(
                                    children: <Widget>[
                                        Container(
                                            child: InkWell(
                                                child: Icon(Icons.skip_previous),
                                                onTap: previousButtonOnTap,
                                            ),
                                            padding: EdgeInsets.all(10),
                                        ),
                                        Container(
                                            child: InkWell(
                                                child: Icon(player.isPlaying ? Icons.pause : Icons.play_arrow),
                                                onTap: playButtonOnTap,
                                            ),
                                            padding: EdgeInsets.all(10),
                                        ),
                                        Container(
                                            child: InkWell(
                                                child: Icon(Icons.skip_next),
                                                onTap: nextButtonOnTap,
                                            ),
                                            padding: EdgeInsets.all(10),
                                        ),
                                    ],
                                ),
                            )
                        ],
                    ),
                )
            ),
        );
    }

    void playSong({Song song, AccountSong accountSong}) async {
        if (player.isPlaying) {
            player.stopPlayer();
        }
        player.release();
        setState(() {});
        if (player.isInited == t_INITIALIZED.NOT_INITIALIZED) {
            await player.initialize();
        }
        if ((song == null && accountSong == null) || (song != null && accountSong != null)) {
            return;
        }
        if (song != null) {
            latestPlayedSong = song;
            if (Session.songsIdPlayHistory.length == Core.MAX_SONGS_IN_PLAY_HISTORY){
                Session.songsIdPlayHistory.removeAt(0);
            }
            Session.songsIdPlayHistory.add(latestPlayedSong.songId.toString());
            Session.preferences.setStringList("songsIdPlayHistory" + Session.account.accountId.toString(), Session.songsIdPlayHistory);
            latestPlayedAccountSong = null;
            if (await song.isDownloaded()) {
                var songBuffer = await song.getDownloadedSongFileContent();
                latestPlayedSongBuffer = songBuffer;
                _playSong(songBuffer);
                return;
            }
            song.fetchSongBuffer((buffer) {
                latestPlayedSongBuffer = buffer;
                _playSong(buffer);
            }, (errorResponse) {
                UI.createErrorDialog(context, errorResponse.message);
            });
        } else if (accountSong != null) {
            latestPlayedAccountSong = accountSong;
            if (Session.songsIdPlayHistory.length == Core.MAX_SONGS_IN_PLAY_HISTORY){
                Session.songsIdPlayHistory.removeAt(0);
            }
            Session.songsIdPlayHistory.add((latestPlayedAccountSong.accountSongId * -1).toString());
            Session.preferences.setStringList("songsIdPlayHistory" + Session.account.accountId.toString(), Session.songsIdPlayHistory);
            latestPlayedSong = null;
            var data = {
                "{accountSongId}": accountSong.accountSongId
            };
            Network.getStreamBuffer("/stream/accountsong/{accountSongId}", data, (buffer) {
                latestPlayedSongBuffer = buffer;
                _playSong(buffer);
            }, (errorResponse) {
                UI.createErrorDialog(context, errorResponse.message);
            });
        }
    }

    void _playSong(Uint8List buffer) async {
        await player.startPlayerFromBuffer(buffer, whenFinished: () {
            setState(() {
                playerCurrentPosition = 0;
            });
            nextButtonOnTap();
        });
        setState(() { });
        player.onPlayerStateChanged.listen((data) {
            if (data != null) {
                playerMaxPosition = data.duration;
                playerCurrentPosition = data.currentPosition;
            }
        });
    }

    void previousButtonOnTap() {
        if (player.isInited == t_INITIALIZED.NOT_INITIALIZED) {
            return;
        }
        if (playerCurrentPosition / 1000 >= 3) {
            player.stopPlayer();
            _playSong(latestPlayedSongBuffer);
        } else if (Session.historyIndex >= 0) {
            if (int.parse(Session.songsIdPlayHistory.elementAt(Session.historyIndex)) > 0) {
                Song.fetchSongById(int.parse(Session.songsIdPlayHistory.elementAt(Session.historyIndex)), (song) {
                    Session.historyIndex--;
                    if (Session.songsIdPlayHistory.length == Core.MAX_SONGS_IN_PLAY_HISTORY){
                        Session.historyIndex--;
                    }
                    playSong(song: song);
                    setState(() {
                    });
                }, (errorResponse) {
                    UI.createErrorDialog(context, errorResponse.message);
                }, () {
                    UI.createErrorDialog(context, "Ocurrió un error al intentar reproducir la canción.");
                });
            } else {
                AccountSong.fetchAccountSongById(int.parse(Session.songsIdPlayHistory.elementAt(Session.historyIndex)) * -1, (accountSong) {
                    Session.historyIndex--;
                    if (Session.songsIdPlayHistory.length == Core.MAX_SONGS_IN_PLAY_HISTORY){
                        Session.historyIndex--;
                    }
                    playSong(accountSong: accountSong);
                    setState(() {
                    });
                }, (errorResponse) {
                    UI.createErrorDialog(context, errorResponse.message);
                }, () {
                    UI.createErrorDialog(context, "Ocurrió un error al intentar reproducir la canción.");
                });
            }
        }
    }

    void playButtonOnTap() {
        if (player.isInited == t_INITIALIZED.NOT_INITIALIZED) {
            return;
        }
        if (player.isPlaying) {
            player.pausePlayer();
        } else if (player.isPaused) {
            player.resumePlayer();
        } else if (player.isStopped) {
            _playSong(latestPlayedSongBuffer);
        }
        setState(() { });
    }

    void nextButtonOnTap() {
        if (player.isInited == t_INITIALIZED.NOT_INITIALIZED) {
            return;
        }
        if (Session.songsIdPlayQueue.length > 0 || Session.songsIdSongList.length > 0) {
            int id;
            if (Session.songsIdPlayQueue.length > 0) {
                id = int.parse(Session.songsIdPlayQueue.first);
            } else {
                id = Session.songsIdSongList.first;
            }
            if (id > 0) {
                Song.fetchSongById(id, (song) {
                    playSong(song: song);
                    setState(() {
                        if (Session.songsIdPlayQueue.length > 0) {
                            Session.songsIdPlayQueue.removeAt(0);
                            Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                        } else {
                            Session.songsIdSongList.removeAt(0);
                        }
                    });
                }, (errorResponse) {
                    UI.createErrorDialog(context, errorResponse.message);
                }, () {
                    UI.createErrorDialog(context, "Ocurrió un error al intentar reproducir la canción.");
                });
            } else {
                AccountSong.fetchAccountSongById(id * -1, (accountSong) {
                    playSong(accountSong: accountSong);
                    setState(() {
                        if (Session.songsIdPlayQueue.length > 0) {
                            Session.songsIdPlayQueue.removeAt(0);
                            Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                        } else {
                            Session.songsIdSongList.removeAt(0);
                        }
                    });
                }, (errorResponse) {
                    UI.createErrorDialog(context, errorResponse.message);
                }, () {
                    UI.createErrorDialog(context, "Ocurrió un error al intentar reproducir la canción.");
                });
            }
        }
    }
}
