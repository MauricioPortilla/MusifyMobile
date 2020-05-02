import 'package:flutter/material.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/ui/songlist.dart';

class HistoryScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _HistoryPage();
    }
}

class _HistoryPage extends StatefulWidget {
    _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<_HistoryPage> {

    // List<Song> songs = <Song>[
    //     Song(title: "Gods of the Sea", album: Album(name: "Tales from the North", artists: <Artist>[
    //         Artist(artisticName: "White Skull")
    //     ])),
    //     Song(title: "High Treason", album: Album(name: "Public Glory", artists: <Artist>[
    //         Artist(artisticName: "White Skull")
    //     ])),
    //     Song(title: "Lady of Hope", album: Album(name: "Will of the Strong", artists: <Artist>[
    //         Artist(artisticName: "White Skull")
    //     ])),
    // ];
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Historial de reproducción"),
                centerTitle: true,
                automaticallyImplyLeading: false,
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        // Container(
                        //     child: SongList(songs: songs),
                        // ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }
}
