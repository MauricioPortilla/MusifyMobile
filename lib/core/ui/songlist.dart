import 'package:flutter/material.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/screens/add_song_to_playlist.dart';

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
                                                    Text(widget.songs[index].album.artistsNames())
                                                ],
                                            )
                                        ],
                                    ),
                                    DropdownButton(
                                        items: [
                                            DropdownMenuItem(
                                                child: Text("Agregar a lista de reproducción", style: TextStyle(fontSize: 14)),
                                                value: "addToPlaylist",
                                            )
                                        ],
                                        icon: Icon(Icons.more_horiz),
                                        onChanged: (value) {
                                            if (value == "addToPlaylist") {
                                                Navigator.push(
                                                    context, MaterialPageRoute(
                                                        builder: (context) => AddSongToPlaylistScreen(
                                                            songToAdd: widget.songs[index]
                                                        )
                                                    )
                                                );
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
