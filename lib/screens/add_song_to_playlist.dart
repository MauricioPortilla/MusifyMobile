import 'package:flutter/material.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/ui/playlistlist.dart';

class AddSongToPlaylistScreen extends StatelessWidget {
    final Song songToAdd;

    AddSongToPlaylistScreen({@required this.songToAdd});
    
    @override
    Widget build(BuildContext context) {
        return _AddSongToPlaylistPage();
    }
}

class _AddSongToPlaylistPage extends StatefulWidget {
    _AddSongToPlaylistPageState createState() => _AddSongToPlaylistPageState();
}

class _AddSongToPlaylistPageState extends State<_AddSongToPlaylistPage> {
    List<Playlist> playlists = <Playlist>[
        Playlist(name: "Awesome"),
        Playlist(name: "Mis canciones favoritas")
    ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Agregar a lista de reproducción"),
                centerTitle: true,
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
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
        print(playlist.name);
    }
}
