import 'package:flutter/material.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/ui/playlistlist.dart';
import 'package:musify/screens/consult_playlist.dart';

class ConsultPlaylistsScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _ConsultPlaylistsPage();
    }
}

class _ConsultPlaylistsPage extends StatefulWidget {
    _ConsultPlaylistsPageState createState() => _ConsultPlaylistsPageState();
}

class _ConsultPlaylistsPageState extends State<_ConsultPlaylistsPage> {
    List<Playlist> playlists = <Playlist>[
        Playlist(name: "Awesome", songs: <Song>[
            Song(title: "Sirens of the Sea", album: Album(name: "Acoustic", artists: <Artist>[
                Artist(artisticName: "Above & Beyond")
            ])),
            Song(title: "Sirens of the Sea - Club Mix", album: Album(name: "Acoustic Mix", artists: <Artist>[
                Artist(artisticName: "Above & Beyond"),
                Artist(artisticName: "Oceanlab")
            ])),
        ]),
        Playlist(name: "Mis canciones favoritas")
    ];
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Menú principal"),
                centerTitle: true,
                automaticallyImplyLeading: false,
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    RaisedButton(
                                        child: Text("Suscribirse"),
                                        onPressed: () {},
                                    ),
                                    RaisedButton(
                                        child: Text("Nueva lista de reproducción"),
                                        onPressed: () {},
                                    ),
                                ],
                            ),
                        ),
                        Text(
                            "Listas de reproducción",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        Container(
                            child: PlaylistList(playlists: playlists, onTap: _onSelectPlaylist),
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    void _onSelectPlaylist(Playlist playlist) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConsultPlaylistScreen(playlist: playlist)));
    }
}
