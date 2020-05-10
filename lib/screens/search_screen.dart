import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
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
    List<Song> songs = <Song>[];
    
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
                        Container(
                            child: SongList(songs: songs),
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    FutureBuilder<List<Song>> _songList(String title) {
        return FutureFactory<List<Song>>().networkFuture(
            Song.fetchSongByTitleCoincidences(title), (data) {
                songs = data;
                return SongList(songs: data);
            }
        );
    }

    void _search(String text) {
        _songList(text);
    }
}
