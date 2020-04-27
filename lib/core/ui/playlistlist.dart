import 'package:flutter/material.dart';
import 'package:musify/core/models/playlist.dart';

class PlaylistList extends StatefulWidget {
    final List<Playlist> playlists;
    final Function onTap;

    PlaylistList({@required this.playlists, @required this.onTap});

    @override
    State<StatefulWidget> createState() {
        return _PlaylistListState();
    }
}

class _PlaylistListState extends State<PlaylistList> {
    @override
    Widget build(BuildContext context) {
        return Expanded(
            child: _createListView()
        );
    }

    ListView _createListView() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.playlists.length,
            itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () {
                            widget.onTap(widget.playlists[index]);
                        },
                        child: Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Container(
                                        child: Text(
                                            widget.playlists[index].name,
                                            textAlign: TextAlign.left,
                                        ),
                                        margin: EdgeInsets.only(bottom: 3),
                                    ),
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
