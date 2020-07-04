import 'package:flutter/material.dart';
import 'package:musify/core/core.dart';
import 'package:musify/core/models/songtable.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/screens/add_song_to_playlist.dart';

class SongTableList extends StatefulWidget {
    final List<SongTable> songs;
    final bool isPlayQueue;
    final Function onTap;

    SongTableList({@required this.songs, @required this.onTap, this.isPlayQueue});

    @override
    State<StatefulWidget> createState() {
        return _SongTableListState();
    }
}

class _SongTableListState extends State<SongTableList> {
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
                            if (widget.songs[index].song != null) {
                                Session.player.state.playSong(song: widget.songs[index].song);
                            } else {
                                Session.player.state.playSong(accountSong: widget.songs[index].accountSong);
                            }
                            if (widget.isPlayQueue) {
                                for (int i = 0; i <= index; i++) {
                                    if (Session.songsIdPlayQueue.length > 0) { 
                                        Session.songsIdPlayQueue.removeAt(0);
                                    } else {
                                        Session.songsIdSongList.removeAt(0);
                                    }
                                }
                                Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                            } else {
                                Session.songsIdSongList.clear();
                            }
                            widget.onTap();
                        },
                        child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    _loadSongColumn(index),
                                    Container(
                                        width: 150,
                                        child: DropdownButton(
                                            isExpanded: true,
                                            items: _loadSongRowDropdownItems(index),
                                            icon: Icon(Icons.more_horiz),
                                            onChanged: (value) async {
                                                if (value == "addToPlaylist") {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddSongToPlaylistScreen(songToAdd: widget.songs[index].song)));
                                                } else if (value == "addToPlayQueue") {
                                                    UI.createDialog(context, "Agregar a la cola", Text("Agregar ..."), [
                                                        FlatButton(
                                                            child: Text("A continuación"),
                                                            onPressed: () {
                                                                List<String> songsIdPlayQueue = List<String>();
                                                                if (widget.songs[index].song != null) {
                                                                    songsIdPlayQueue.add(widget.songs[index].song.songId.toString());
                                                                } else {
                                                                    songsIdPlayQueue.add((widget.songs[index].accountSong.accountSongId * -1).toString());
                                                                }
                                                                songsIdPlayQueue.addAll(Session.songsIdPlayQueue);
                                                                Session.songsIdPlayQueue.clear();
                                                                Session.songsIdPlayQueue.addAll(songsIdPlayQueue);
                                                                Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                                                                Navigator.pop(context);
                                                                if (widget.isPlayQueue) {
                                                                    widget.onTap();
                                                                }
                                                            }
                                                        ),
                                                        FlatButton(
                                                            child: Text("Al final"),
                                                            onPressed: () {
                                                                if (widget.songs[index].song != null) {
                                                                    Session.songsIdPlayQueue.add(widget.songs[index].song.songId.toString());
                                                                } else {
                                                                    Session.songsIdPlayQueue.add((widget.songs[index].accountSong.accountSongId * -1).toString());
                                                                }
                                                                Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                                                                Navigator.pop(context);
                                                                if (widget.isPlayQueue) {
                                                                    widget.onTap();
                                                                }
                                                            }
                                                        ),
                                                        FlatButton(
                                                            child: Text("Cancelar"),
                                                            onPressed: () => Navigator.pop(context)
                                                        )
                                                    ]);
                                                } else if (value == "generateRadioStation") {
                                                    if (Session.genresIdRadioStations.length == 0 || Session.genresIdRadioStations.firstWhere((element) => element == widget.songs[index].song.genreId.toString()) == null) {
                                                        Session.genresIdRadioStations.add(widget.songs[index].song.genreId.toString());
                                                        Session.preferences.setStringList("genresIdRadioStations" + Session.account.accountId.toString(), Session.genresIdRadioStations);
                                                    } else {
                                                        UI.createLoadingDialog(context);
                                                        Navigator.pop(context);
                                                        UI.createErrorDialog(context, "Ya existe la estación de radio de este género.");
                                                    }
                                                } else if (value == "deleteFromPlayQueue") {
                                                    if (index < Session.songsIdPlayQueue.length) {
                                                        Session.songsIdPlayQueue.removeAt(index);
                                                        Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                                                    } else {
                                                        Session.songsIdSongList.removeAt(index - Session.songsIdPlayQueue.length);
                                                    }
                                                    widget.onTap();
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

    Column _loadSongColumn(int index) {
        if (widget.songs[index].song != null) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Container(
                        child: Text(
                            widget.songs[index].song.title,
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
                            Text(widget.songs[index].song.artistsNames())
                        ]
                    ),
                    Container(
                        child: Text(
                            widget.songs[index].song.genre.name,
                            textAlign: TextAlign.left,
                        ),
                        margin: EdgeInsets.only(bottom: 3)
                    )
                ]
            );
        } else {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Container(
                        child: Text(
                            widget.songs[index].accountSong.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        margin: EdgeInsets.only(bottom: 3)
                    ),
                    Row(
                        children: <Widget>[
                            Text(
                                "Canción de la cuenta", 
                                style: TextStyle(fontSize: 13)
                            )
                        ]
                    )
                ]
            );
        }
    }

    List<DropdownMenuItem<String>> _loadSongRowDropdownItems(int index) {
        List<DropdownMenuItem<String>> items = [];
        if (widget.songs[index].song != null){
            items.add(
                DropdownMenuItem(
                    child: Text(
                        "Agregar a una lista de reproducción", 
                        style: TextStyle(fontSize: 14)
                    ),
                    value: "addToPlaylist"
                )
            );
        }
        items.add(
            DropdownMenuItem(
                child: Text(
                    "Agregar a la cola de reproducción", 
                    style: TextStyle(fontSize: 14)
                ),
                value: "addToPlayQueue"
            )
        );
        if (widget.songs[index].song != null){
            items.add(
                DropdownMenuItem(
                    child: Text(
                        "Generar estación de radio", 
                        style: TextStyle(fontSize: 14)
                    ),
                    value: "generateRadioStation"
                )
            );
        }
        if (widget.isPlayQueue) {
            items.add(
                DropdownMenuItem(
                    child: Text(
                        "Eliminar canción de la cola", 
                        style: TextStyle(fontSize: 14)
                    ),
                    value: "deleteFromPlayQueue"
                )
            );
        }
        return items;
    }
}
