import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:musify/core/session.dart';
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

    _PlayerPageState() {
        sliderUpdater = Timer.periodic(Duration(seconds: 1), (timer) {
            if (Session.player.state.player.isPlaying) {
                setState(() { });
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
        var latestPlayedSong = Session.player.state.latestPlayedSong;
        var latestPlayedAccountSong = Session.player.state.latestPlayedAccountSong;
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
                                        Row(
                                            children: <Widget>[
                                                Container(
                                                    margin: EdgeInsets.only(right: 12),
                                                    child: InkWell(
                                                        child: Icon(Icons.thumb_up),
                                                        onTap: () {},
                                                    ),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(left: 12),
                                                    child: InkWell(
                                                        child: Icon(Icons.thumb_down),
                                                        onTap: () {},
                                                    ),
                                                )
                                            ],
                                        )
                                    ],
                                ),
                            ),
                            Slider(
                                min: 0,
                                max: Session.player.state.playerMaxPosition,
                                value: Session.player.state.playerCurrentPosition,
                                onChanged: (value) {
                                    try {
                                        Session.player.state.player.seekToPlayer(value.toInt());
                                        setState(() { });
                                    } catch (e) {
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


}
