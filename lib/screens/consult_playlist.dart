import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/core/ui/songlist.dart';
import 'package:path_provider/path_provider.dart';

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
    bool _isDownloadSwitched = false;

    @override
    Widget build(BuildContext context) {
        _checkIfIsDownloaded();
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
                                        value: _isDownloadSwitched,
                                        onChanged: (value) {
                                            setState(() {
                                                _isDownloadSwitched = value;
                                                _downloadSwitch();
                                            });
                                        },
                                    ),
                                    RaisedButton(
                                        child: Text("Eliminar lista"),
                                        onPressed: () => _deletePlaylist(),
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

    void _checkIfIsDownloaded() async {
        if (Session.preferences.getStringList("downloadedPlaylists").contains("${widget.playlist.playlistId}")) {
            setState(() {
                _isDownloadSwitched = true;
            });
        }
    }

    FutureBuilder<List<Song>> _songList() {
        return FutureFactory<List<Song>>().networkFuture(widget.playlist.fetchSongs(), (data) {
            return SongList(songs: data, playlistAssociated: widget.playlist, isSearch: false);
        });
    }

    void _deletePlaylist() {
        UI.createDialog(context, "Eliminar lista", Text("¿Desea eliminar esta lista?"), [
            FlatButton(
                child: Text("Sí"),
                onPressed: () {
                    Navigator.pop(context);
                    UI.createLoadingDialog(context);
                    widget.playlist.delete(() {
                        var downloadedPlaylists = Session.preferences.getStringList("downloadedPlaylists");
                        downloadedPlaylists.remove(widget.playlist.playlistId.toString());
                        Session.preferences.setStringList("downloadedPlaylists", downloadedPlaylists);
                        Session.account.playlists.remove(widget.playlist);
                        Navigator.pop(context);
                        Session.homePop();
                    }, (errorResponse) {
                        Navigator.pop(context);
                        UI.createErrorDialog(context, errorResponse.message);
                    }, () {
                        Navigator.pop(context);
                        UI.createErrorDialog(context, "No se pudo establecer una conexión con el servidor.");
                    });
                },
            ),
            FlatButton(
                child: Text("No"),
                onPressed: () => Navigator.pop(context),
            )
        ]);
    }

    void _downloadSwitch() async {
        try {
            Directory musifyDirectory = await getApplicationDocumentsDirectory();
            for (Song song in widget.playlist.songs) {
                File songFile = File("${musifyDirectory.path}/${song.songId}.bin");
                if (await songFile.exists() && !_isDownloadSwitched) {
                    songFile.delete();
                } else if (_isDownloadSwitched) {
                    song.fetchSongBuffer((buffer) async {
                        await songFile.writeAsBytes(buffer, mode: FileMode.writeOnly, flush: true);
                    }, (errorResponse) {
                    });
                }
            }
            var downloadedPlaylists = Session.preferences.getStringList("downloadedPlaylists");
            if (_isDownloadSwitched) {
                downloadedPlaylists.add(widget.playlist.playlistId.toString());
            } else {
                downloadedPlaylists.remove(widget.playlist.playlistId.toString());
            }
            Session.preferences.setStringList("downloadedPlaylists", downloadedPlaylists);
        } catch (exception) {
            UI.createErrorDialog(context, "Ocurrió un error al intentar descargar la lista de reproducción.");
        }
    }
}
