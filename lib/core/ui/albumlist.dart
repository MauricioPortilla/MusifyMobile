import 'package:flutter/material.dart';
import 'package:musify/core/models/album.dart';

class AlbumList extends StatefulWidget {
    final List<Album> albums;

    AlbumList({@required this.albums});

    @override
    State<StatefulWidget> createState() {
        return _AlbumListState();
    }
}

class _AlbumListState extends State<AlbumList> {
    @override
    Widget build(BuildContext context) {
        return Expanded(
            child: _createListView()
        );
    }

    ListView _createListView() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.albums.length,
            itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () {
                            
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
                                                    widget.albums[index].name,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontWeight: FontWeight.bold)
                                                ),
                                                margin: EdgeInsets.only(bottom: 3),
                                            ),
                                            Row(
                                                children: <Widget>[
                                                    Text("Álbum - ", style: TextStyle(fontSize: 13)),
                                                    Text(widget.albums[index].artistsNames())
                                                ],
                                            )
                                        ],
                                    ),
                                    InkWell(
                                        child: Icon(Icons.more_horiz),
                                        onTap: () {
                                        }
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
