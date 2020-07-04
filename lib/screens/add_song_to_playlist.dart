import 'package:flutter/material.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/core/ui/playlistlist.dart';

class AddSongToPlaylistScreen extends StatelessWidget {
    final Song songToAdd;

    AddSongToPlaylistScreen({@required this.songToAdd});
    
    @override
    Widget build(BuildContext context) {
        return _AddSongToPlaylistPage(songToAdd: this.songToAdd);
    }
}

class _AddSongToPlaylistPage extends StatefulWidget {
    final Song songToAdd;

    _AddSongToPlaylistPage({@required this.songToAdd});

    _AddSongToPlaylistPageState createState() => _AddSongToPlaylistPageState();
}

class _AddSongToPlaylistPageState extends State<_AddSongToPlaylistPage> {
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Agregar a lista de reproducción"),
                centerTitle: true
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        Container(
                            child: PlaylistList(
                                playlists: Session.account.playlists, 
                                onTap: _onSelectPlaylist
                            )
                        )
                    ]
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15)
            )
        );
    }

    void _onSelectPlaylist(Playlist playlist) {
        UI.createLoadingDialog(context);
        playlist.containsSong(widget.songToAdd, () {
            Navigator.pop(context);
            UI.createErrorDialog(context, "Esta canción ya existe en esta lista de reproducción.");
        }, (errorResponse) {
            playlist.addSong(widget.songToAdd, () {
                setState(() {
                });
                Navigator.pop(context);
                Navigator.pop(context);
            }, (errorResponse) {
                Navigator.pop(context);
                UI.createErrorDialog(context, errorResponse.message);
            }, () {
                Navigator.pop(context);
                UI.createErrorDialog(context, "Ocurrió un error al guardar la canción en la lista de reproducción.");
            });
        }, () {
            Navigator.pop(context);
            UI.createErrorDialog(context, "Ocurrió un error al guardar la canción en la lista de reproducción.");
        });
    }
}
