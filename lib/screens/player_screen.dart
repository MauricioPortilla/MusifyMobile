import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:musify/core/models/accountsong.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/screens/consult_artist.dart';

class PlayerScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        initializeDateFormatting();
        return _PlayerPage();
    }
}

class _PlayerPage extends StatefulWidget {
    _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<_PlayerPage> {
    Timer sliderUpdater;
    Song latestPlayedSong = Session.player.state.latestPlayedSong;
    AccountSong latestPlayedAccountSong = Session.player.state.latestPlayedAccountSong;
    bool _isLikeButtonEnabled = true;
    bool _isDislikeButtonEnabled = true;

    _PlayerPageState() {
        sliderUpdater = Timer.periodic(Duration(seconds: 1), (timer) {
            if (Session.player.state.player.isPlaying) {
                setState(() { });
            } else if (Session.player.state.player.isStopped && Session.player.state.playerCurrentPosition == Session.player.state.playerMaxPosition) {
                setState(() {
                    Session.player.state.playerCurrentPosition = 0;
                });
            }
        });
    }

    @override
    void dispose() {
        super.dispose();
        sliderUpdater?.cancel();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Container(
                    child: Text(
                        latestPlayedSong == null ? latestPlayedAccountSong.title : latestPlayedSong.title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                    ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                            Container(
                                child: latestPlayedSong == null ? Icon(Icons.music_note, size: 150,) : latestPlayedSong.album.fetchImage(),
                                width: MediaQuery.of(context).size.width / 1.15,
                                height: MediaQuery.of(context).size.width / 1.15,
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(13, 15, 13, 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                                GestureDetector(
                                                    child: ConstrainedBox(
                                                        child: Text(
                                                            latestPlayedSong == null ? latestPlayedAccountSong.title : latestPlayedSong.title,
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                        ),
                                                        constraints: BoxConstraints(
                                                            minWidth: 30,
                                                            maxWidth: MediaQuery.of(context).size.width / 1.5
                                                        ),
                                                    ),
                                                    onTap: () { }
                                                ),
                                                GestureDetector(
                                                    child: Text(
                                                        latestPlayedSong == null ? "" : latestPlayedSong.album.artistsNames(),
                                                        style: TextStyle(
                                                            fontSize: 15
                                                        )
                                                    ),
                                                    onTap: () {
                                                        if (latestPlayedSong == null) {
                                                            return;
                                                        }
                                                        Session.homePush(ConsultArtistScreen(
                                                            artist: latestPlayedSong.album.artists[0]
                                                        ));
                                                        Navigator.pop(context);
                                                    },
                                                )
                                            ],
                                        ),
                                        _loadRateSongButtons()
                                    ],
                                ),
                            ),
                            Slider(
                                min: 0,
                                max: Session.player.state.playerMaxPosition,
                                value: Session.player.state.playerCurrentPosition,
                                onChanged: (value) {
                                    if (Session.player.state.playerCurrentPosition == 0 && Session.player.state.player.isStopped) {
                                        return;
                                    }
                                    if (Session.player.state.playerMaxPosition != Session.player.state.playerCurrentPosition) {
                                        setState(() {
                                            Session.player.state.player.seekToPlayer(value.toInt());
                                        });
                                    }
                                },
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Text(DateFormat('mm:ss').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            Session.player.state.playerCurrentPosition.toInt()
                                        )
                                    )),
                                    Text(DateFormat('mm:ss').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            Session.player.state.playerMaxPosition.toInt()
                                        )
                                    ))
                                ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    Container(
                                        width: 50,
                                        height: 50,
                                        margin: EdgeInsets.only(right: 12),
                                        child: InkWell(
                                            child: Icon(Icons.skip_previous, size: 50),
                                            onTap: Session.player.state.previousButtonOnTap,
                                        ),
                                    ),
                                    Container(
                                        width: 50,
                                        height: 50,
                                        margin: EdgeInsets.only(right: 12),
                                        child: InkWell(
                                            child: Icon(
                                                Session.player.state.player.isPlaying ? Icons.pause : Icons.play_arrow, 
                                                size: 50
                                            ),
                                            onTap: () {
                                                Session.player.state.playButtonOnTap();
                                                setState(() { });
                                            },
                                        ),
                                    ),
                                    Container(
                                        width: 50,
                                        height: 50,
                                        margin: EdgeInsets.only(right: 12),
                                        child: InkWell(
                                            child: Icon(Icons.skip_next, size: 50),
                                            onTap: Session.player.state.nextButtonOnTap,
                                        ),
                                    )
                                ],
                            )
                        ],
                    ),
                ),
            )
        );
    }

    Widget _loadRateSongButtons() {
        if (latestPlayedSong != null) {
            Session.account.hasLikedSong(latestPlayedSong).then((hasLiked) {
                if (hasLiked) {
                    setState(() {
                        _isDislikeButtonEnabled = false;
                        _isLikeButtonEnabled = true;
                    });
                } else {
                    Session.account.hasDislikedSong(latestPlayedSong).then((hasDisliked) {
                        if (hasDisliked) {
                            setState(() {
                                _isLikeButtonEnabled = false;
                                _isDislikeButtonEnabled = true;
                            });
                        }
                    });
                }
            });
        }
        return latestPlayedSong != null ? Row(
            children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 12),
                    child: InkWell(
                        child: Icon(Icons.thumb_up, color: _isLikeButtonEnabled ? Colors.green.shade800 : Colors.green.shade200),
                        onTap: () => _likeSong(),
                        highlightColor: _isLikeButtonEnabled ? Colors.grey.shade300 : Colors.transparent,
                        splashColor: _isLikeButtonEnabled ? Colors.grey.shade300 : Colors.transparent,
                    ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 12),
                    child: InkWell(
                        child: Icon(Icons.thumb_down, color: _isDislikeButtonEnabled ? Colors.red : Colors.red.shade200),
                        onTap: () => _dislikeSong(),
                        highlightColor: _isDislikeButtonEnabled ? Colors.grey.shade300 : Colors.transparent,
                        splashColor: _isDislikeButtonEnabled ? Colors.grey.shade300 : Colors.transparent,
                    ),
                )
            ],
        ) : Container();
    }

    void _likeSong() {
        if (_isLikeButtonEnabled && _isDislikeButtonEnabled) {
            Session.account.likeSong(latestPlayedSong, () {
                setState(() {
                    _isDislikeButtonEnabled = false;
                });
            }, (errorResponse) {
                UI.createErrorDialog(context, errorResponse.message);
            }, () {
                UI.createErrorDialog(context, "Ocurrió un error al procesar tu solicitud.");
            });
        } else if (_isLikeButtonEnabled && !_isDislikeButtonEnabled) {
            Session.account.unlikeSong(latestPlayedSong, () {
                setState(() {
                    _isDislikeButtonEnabled = true;
                });
            }, (errorResponse) {
                UI.createErrorDialog(context, errorResponse.message);
            }, () {
                UI.createErrorDialog(context, "Ocurrió un error al procesar tu solicitud.");
            });
        }
    }

    void _dislikeSong() {
        if (_isLikeButtonEnabled && _isDislikeButtonEnabled) {
            Session.account.dislikeSong(latestPlayedSong, () {
                setState(() {
                    _isLikeButtonEnabled = false;
                });
            }, (errorResponse) {
                UI.createErrorDialog(context, errorResponse.message);
            }, () {
                UI.createErrorDialog(context, "Ocurrió un error al procesar tu solicitud.");
            });
        } else if (!_isLikeButtonEnabled && _isDislikeButtonEnabled) {
            Session.account.undislikeSong(latestPlayedSong, () {
                setState(() {
                    _isLikeButtonEnabled = true;
                });
            }, (errorResponse) {
                UI.createErrorDialog(context, errorResponse.message);
            }, () {
                UI.createErrorDialog(context, "Ocurrió un error al procesar tu solicitud.");
            });
        }
    }
}
