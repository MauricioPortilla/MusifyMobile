import 'package:flutter/material.dart';
import 'package:musify/core/core.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/ui/songlist.dart';

class AlbumPanel extends StatefulWidget{
    final Album album;

    AlbumPanel({@required this.album});

    _AlbumPanelState createState() => _AlbumPanelState();
}

class _AlbumPanelState extends State<AlbumPanel> {
    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
                children: <Widget>[
                    Row(
                        children: <Widget>[
                            Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.only(right: 10),
                                // child: Image.network(Core.SERVER_URL + "/album/" + widget.album.albumId.toString() + "/image"),
                                color: Colors.black,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Text(
                                        widget.album.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                    ),
                                    Text(
                                        widget.album.launchYear.toString(),
                                        style: TextStyle(
                                            fontSize: 15
                                        )
                                    ),
                                    Text(
                                        widget.album.discography,
                                        style: TextStyle(
                                            fontSize: 12
                                        )
                                    )
                                ],
                            )
                        ],
                    ),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 15),
                        child: Flex(
                            direction: Axis.horizontal,
                            children: <Widget>[
                                SongList(songs: widget.album.songs),
                            ],
                        )
                    ),
                ],
            ),
        );
    }
}
