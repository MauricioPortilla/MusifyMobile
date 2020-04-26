import 'package:flutter/material.dart';
import 'package:musify/core/models/song.dart';

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
            itemCount: widget.songs.length,
            itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () {
                        },
                        child: Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Container(
                                        child: Text(
                                            widget.songs[index].title,
                                            textAlign: TextAlign.left,
                                        ),
                                        margin: EdgeInsets.only(bottom: 3),
                                    ),
                                    Row(
                                        children: <Widget>[
                                            Text("Canción - "),
                                            Text(widget.songs[index].album.artistsNames())
                                        ],
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
