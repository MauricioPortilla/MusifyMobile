import 'package:flutter/material.dart';
import 'package:musify/core/models/song.dart';

class Player extends StatefulWidget {
    Song latestPlayedSong;

    _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
    @override
    Widget build(BuildContext context) {
        return Container(
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
                                Text("Sirens of the Sea"),
                                Text("Above & Beyond")
                            ],
                        ),
                        Container(
                            child: Row(
                                children: <Widget>[
                                    Container(
                                        child: InkWell(
                                            child: Icon(Icons.skip_previous),
                                            onTap: () { },
                                        ),
                                        padding: EdgeInsets.all(10),
                                    ),
                                    Container(
                                        child: InkWell(
                                            child: Icon(Icons.play_arrow),
                                            onTap: () { },
                                        ),
                                        padding: EdgeInsets.all(10),
                                    ),
                                    Container(
                                        child: InkWell(
                                            child: Icon(Icons.skip_next),
                                            onTap: () { },
                                        ),
                                        padding: EdgeInsets.all(10),
                                    ),
                                ],
                            ),
                        )
                    ],
                ),
            )
        );
    }
}
