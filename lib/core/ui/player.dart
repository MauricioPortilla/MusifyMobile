import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flauto.dart';
import 'package:flutter_sound/flutter_sound_player.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/network.dart';
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
    Uint8List latestPlayedSongBuffer;
    FlutterSoundPlayer player = FlutterSoundPlayer();
    double playerCurrentPosition = 0;
    double playerMaxPosition = 0;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                if (latestPlayedSong != null) {
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
                                            latestPlayedSong == null ? "" : latestPlayedSong.title,
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

    void playSong(Song song) async {
        if (player.isPlaying) {
            player.stopPlayer();
        }
        player.release();
        setState(() {});
        if (player.isInited == t_INITIALIZED.NOT_INITIALIZED) {
            await player.initialize();
        }
        latestPlayedSong = song;
        var data = {
            "{songId}": song.songId
        };
        Network.getStreamBuffer("/stream/song/{songId}/highQuality", data, (buffer) {
            latestPlayedSongBuffer = buffer;
            _playSong(buffer);
        }, (errorResponse) {
            UI.createErrorDialog(context, errorResponse["message"]);
        });
    }

    void _playSong(Uint8List buffer) async {
        await player.startPlayerFromBuffer(buffer, whenFinished: () {
            playerCurrentPosition = 0;
            setState(() { });
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
        if (player.isPlaying) {
            player.stopPlayer();
            _playSong(latestPlayedSongBuffer);
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
    }
}
