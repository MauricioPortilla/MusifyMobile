import 'package:flutter/material.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/screens/add_song_to_playlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongList extends StatefulWidget {
    final List<Song> songs;
    final Playlist playlistAssociated;

    SongList({@required this.songs, this.playlistAssociated});

    @override
    State<StatefulWidget> createState() {
        return _SongListState();
    }
}

class _SongListState extends State<SongList> {
    @override
    Widget build(BuildContext context) {
        return Expanded(
            child: _createListView()
        );
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
                            Session.player.state.playSong(song: widget.songs[index]);
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
                                                margin: EdgeInsets.only(bottom: 3),
                                            ),
                                            Row(
                                                children: <Widget>[
                                                    Text("Canción - ", style: TextStyle(fontSize: 13)),
                                                    Text(widget.songs[index].artistsNames())
                                                ],
                                            ),
                                            Container(
                                                child: Text(
                                                    widget.songs[index].genre.name,
                                                    textAlign: TextAlign.left,
                                                ),
                                                margin: EdgeInsets.only(bottom: 3),
                                            ),
                                        ],
                                    ),
                                    DropdownButton(
                                        items: _loadSongRowDropdownItems(),
                                        icon: Icon(Icons.more_horiz),
                                        onChanged: (value) async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            if (value == "addToPlaylist") {
                                                Navigator.push(
                                                    context, MaterialPageRoute(
                                                        builder: (context) => AddSongToPlaylistScreen(
                                                            songToAdd: widget.songs[index]
                                                        )
                                                    )
                                                );
                                            } else if (value == "addToPlayQueue") {
                                                Session.songsIdPlayQueue.add(widget.songs[index].songId.toString());
                                                prefs.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                                            } else if (value == "generateRadioStation") {
                                                if (Session.genresIdRadioStations.length == 0 || Session.genresIdRadioStations.firstWhere((element) => element == widget.songs[index].genreId.toString()) == null) {
                                                    Session.genresIdRadioStations.add(widget.songs[index].genreId.toString());
                                                    prefs.setStringList("genresIdRadioStations" + Session.account.accountId.toString(), Session.genresIdRadioStations);
                                                } else {
                                                    UI.createLoadingDialog(context);
                                                    Navigator.pop(context);
                                                    UI.createErrorDialog(context, "Ya existe la estación de radio de este género.");
                                                }
                                            } else if (value == "deleteFromPlaylist") {
                                                UI.createLoadingDialog(context);
                                                widget.playlistAssociated.deleteSong(widget.songs[index], () {
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
                                        },
                                    )
                                ],
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.black, width: 0.3))
                            ),
                        )
                    )
                );
            }
        );
    }

    List<DropdownMenuItem<String>> _loadSongRowDropdownItems() {
        List<DropdownMenuItem<String>> items = [
            DropdownMenuItem(
                child: Text("Agregar a una lista de reproducción", style: TextStyle(fontSize: 14)),
                value: "addToPlaylist",
            ),
            DropdownMenuItem(
                child: Text("Agregar a la cola de reproducción", style: TextStyle(fontSize: 14)),
                value: "addToPlayQueue",
            ),
            DropdownMenuItem(
                child: Text("Generar estación de radio", style: TextStyle(fontSize: 14)),
                value: "generateRadioStation",
            ),
        ];
        if (widget.playlistAssociated != null) {
            items.add(
                DropdownMenuItem(
                    child: Text("Eliminar de lista de reproducción", style: TextStyle(fontSize: 14)),
                    value: "deleteFromPlaylist",
                )
            );
        }
        return items;
    }
}
