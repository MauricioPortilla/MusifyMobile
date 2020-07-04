import 'package:flutter/material.dart';
import 'package:musify/core/core.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/screens/add_song_to_playlist.dart';

class SongList extends StatefulWidget {
    final List<Song> songs;
    final Playlist playlistAssociated;
    final bool isSearch;

    SongList({@required this.songs, this.playlistAssociated, this.isSearch});

    @override
    State<StatefulWidget> createState() {
        return _SongListState();
    }
}

class _SongListState extends State<SongList> {
    @override
    Widget build(BuildContext context) {
        return Expanded(child: _createListView());
    }

    ListView _createListView() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.songs.length,
            itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () {
                            Session.historyIndex = Session.songsIdPlayHistory.length - 1;
                            if (Session.songsIdPlayHistory.length == Core.MAX_SONGS_IN_PLAY_HISTORY){
                                Session.historyIndex--;
                            }
                            Session.player.state.playSong(song: widget.songs[index]);
                            Session.songsIdSongList.clear();
                            if (!widget.isSearch) {
                                for (int i = index + 1; i < widget.songs.length; i++) {
                                    Session.songsIdSongList.add(widget.songs[i].songId);
                                }
                            }
                        },
                        child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                            Container(
                                                child: Text(
                                                    widget.songs[index].title,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontWeight: FontWeight.bold)
                                                ),
                                                margin: EdgeInsets.only(bottom: 3)
                                            ),
                                            Row(
                                                children: <Widget>[
                                                    Text(
                                                        "Canción - ", 
                                                        style: TextStyle(fontSize: 13)
                                                    ),
                                                    Text(widget.songs[index].artistsNames())
                                                ]
                                            ),
                                            Container(
                                                child: Text(
                                                    widget.songs[index].genre.name,
                                                    textAlign: TextAlign.left
                                                ),
                                                margin: EdgeInsets.only(bottom: 3)
                                            )
                                        ]
                                    ),
                                    Container(
                                        width: 150,
                                        child: DropdownButton(
                                            isExpanded: true,
                                            items: _loadSongRowDropdownItems(),
                                            icon: Icon(Icons.more_horiz),
                                            onChanged: (value) async {
                                                if (value == "addToPlaylist") {
                                                    _addToPlaylist(widget.songs[index]);
                                                } else if (value == "addToPlayQueue") {
                                                    _addToPlayQueue(widget.songs[index]);
                                                } else if (value == "generateRadioStation") {
                                                    _generateRadioStation(widget.songs[index]);
                                                } else if (value == "deleteFromPlaylist") {
                                                    _deleteFromPlaylist(widget.songs[index]);
                                                }
                                            }
                                        )
                                    )
                                ]
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, 
                                        width: 0.3
                                    )
                                )
                            )
                        )
                    )
                );
            }
        );
    }

    List<DropdownMenuItem<String>> _loadSongRowDropdownItems() {
        List<DropdownMenuItem<String>> items = [
            DropdownMenuItem(
                child: Text(
                    "Agregar a una lista de reproducción", 
                    style: TextStyle(fontSize: 14)
                ),
                value: "addToPlaylist"
            ),
            DropdownMenuItem(
                child: Text(
                    "Agregar a la cola de reproducción", 
                    style: TextStyle(fontSize: 14)
                ),
                value: "addToPlayQueue"
            ),
            DropdownMenuItem(
                child: Text(
                    "Generar estación de radio", 
                    style: TextStyle(fontSize: 14)
                ),
                value: "generateRadioStation"
            )
        ];
        if (widget.playlistAssociated != null) {
            items.add(
                DropdownMenuItem(
                    child: Text(
                        "Eliminar de lista de reproducción", 
                        style: TextStyle(fontSize: 14)
                    ),
                    value: "deleteFromPlaylist"
                )
            );
        }
        return items;
    }

    void _addToPlaylist(Song song) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddSongToPlaylistScreen(songToAdd: song)));
    }

    void _addToPlayQueue(Song song) {
        UI.createDialog(context, "Agregar a la cola", Text("Agregar ..."), [
            FlatButton(
                child: Text("A continuación"),
                onPressed: () {
                    List<String> songsIdPlayQueue = [song.songId.toString()];
                    songsIdPlayQueue.addAll(Session.songsIdPlayQueue);
                    Session.songsIdPlayQueue.clear();
                    Session.songsIdPlayQueue.addAll(songsIdPlayQueue);
                    Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                    Navigator.pop(context);
                }
            ),
            FlatButton(
                child: Text("Al final"),
                onPressed: () {
                    Session.songsIdPlayQueue.add(song.songId.toString());
                    Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                    Navigator.pop(context);
                }
            ),
            FlatButton(
                child: Text("Cancelar"),
                onPressed: () => Navigator.pop(context)
            )
        ]);
    }

    void _generateRadioStation(Song song) {
        if (Session.genresIdRadioStations.length == 0 || Session.genresIdRadioStations.firstWhere((element) => element == song.genreId.toString()) == null) {
            Session.genresIdRadioStations.add(song.genreId.toString());
            Session.preferences.setStringList("genresIdRadioStations" + Session.account.accountId.toString(), Session.genresIdRadioStations);
        } else {
            UI.createLoadingDialog(context);
            Navigator.pop(context);
            UI.createErrorDialog(context, "Ya existe la estación de radio de este género.");
        }
    }

    void _deleteFromPlaylist(Song song) {
        UI.createLoadingDialog(context);
        widget.playlistAssociated.deleteSong(song, () {
            Navigator.pop(context);
            setState(() {
            });
        }, (errorResponse) {
            Navigator.pop(context);
            UI.createErrorDialog(context, errorResponse.message);
        }, () {
            Navigator.pop(context);
            UI.createErrorDialog(context, "Error al establecer una conexión con el servidor.");
        });
    }
}
