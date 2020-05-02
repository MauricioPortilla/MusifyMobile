import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui/songlist.dart';

class ConsultPlaylistScreen extends StatelessWidget {
    final Playlist playlist;

    ConsultPlaylistScreen({@required this.playlist});

    @override
    Widget build(BuildContext context) {
        return _ConsultPlaylistScreenPage(playlist: this.playlist);
    }
}

class _ConsultPlaylistScreenPage extends StatefulWidget {
    final Playlist playlist;

    _ConsultPlaylistScreenPage({@required this.playlist});

    _ConsultPlaylistScreenPageState createState() => _ConsultPlaylistScreenPageState();
}

class _ConsultPlaylistScreenPageState extends State<_ConsultPlaylistScreenPage> {
    bool isDownloadSwitched = false;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Lista de reproducción"),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                        Session.homePop();
                    },
                ),
            ),
            body: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                    children: <Widget>[
                        Text(
                            widget.playlist.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    Text("Descargar"),
                                    Switch(
                                        value: isDownloadSwitched,
                                        onChanged: (value) {
                                            setState(() {
                                                isDownloadSwitched = value;
                                            });
                                        },
                                    ),
                                    RaisedButton(
                                        child: Text("Eliminar lista"),
                                        onPressed: () {},
                                    ),
                                ],
                            ),
                        ),
                        Container(
                            child: _songList(),
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    FutureBuilder<List<Song>> _songList() {
        return FutureFactory<List<Song>>().networkFuture(widget.playlist.loadSongs(), (data) {
            return SongList(songs: data);
        });
    }
}
