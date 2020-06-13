import 'package:flutter/material.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/screens/add_song_to_playlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongList extends StatefulWidget {
    final List<Song> songs;

    SongList({@required this.songs});

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
                                        items: [
                                            DropdownMenuItem(
                                                child: Text("Agregar a una lista de reproducción", style: TextStyle(fontSize: 14)),
                                                value: "addToPlaylist",
                                            ),
                                            DropdownMenuItem(
                                                child: Text("Agregar a la cola de reproducción", style: TextStyle(fontSize: 14)),
                                                value: "addToPlayQueue",
                                            )
                                        ],
                                        icon: Icon(Icons.more_horiz),
                                        onChanged: (value) async {
                                            if (value == "addToPlaylist") {
                                                Navigator.push(
                                                    context, MaterialPageRoute(
                                                        builder: (context) => AddSongToPlaylistScreen(
                                                            songToAdd: widget.songs[index]
                                                        )
                                                    )
                                                );
                                            }
                                            if (value == "addToPlayQueue") {
                                                Session.songsIdPlayQueue.add(widget.songs[index].songId.toString());
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                prefs.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
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
}
