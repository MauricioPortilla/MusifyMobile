import 'package:flutter/material.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/ui/songlist.dart';

class SearchScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _SearchPage();
    }
}

class _SearchPage extends StatefulWidget {
    _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
    final TextEditingController _searchTextFieldController = new TextEditingController();

    // List<Song> songs = <Song>[
    //     Song(title: "Sirens of the Sea", album: Album(name: "Acoustic", artists: <Artist>[
    //         Artist(artisticName: "Above & Beyond")
    //     ])),
    //     Song(title: "Sirens of the Sea - Club Mix", album: Album(name: "Acoustic Mix", artists: <Artist>[
    //         Artist(artisticName: "Above & Beyond"),
    //         Artist(artisticName: "Oceanlab")
    //     ])),
    // ];
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Buscar canción"),
                centerTitle: true,
                automaticallyImplyLeading: false,
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        Container(
                            child: TextField(
                                controller: _searchTextFieldController,
                                decoration: InputDecoration(
                                    labelText: "Buscar",
                                ),
                                onChanged: (text) {
                                    _search(text);
                                },
                            ),
                        ),
                        // Container(
                        //     child: SongList(songs: songs),
                        // ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    void _search(String text) {
    }
}
