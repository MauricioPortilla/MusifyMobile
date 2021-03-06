import 'package:flutter/material.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/session.dart';
import 'package:musify/screens/consult_artist.dart';

class ArtistList extends StatefulWidget {
    final List<Artist> artists;

    ArtistList({@required this.artists});

    @override
    State<StatefulWidget> createState() {
        return _ArtistListState();
    }
}

class _ArtistListState extends State<ArtistList> {
    @override
    Widget build(BuildContext context) {
        return Expanded(child: _createListView());
    }

    ListView _createListView() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.artists.length,
            itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () {
                            FocusScope.of(context).unfocus();
                            Session.homePush(ConsultArtistScreen(artist: widget.artists[index]));
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
                                                    widget.artists[index].artisticName,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontWeight: FontWeight.bold)
                                                ),
                                                margin: EdgeInsets.only(bottom: 3)
                                            ),
                                            Row(
                                                children: <Widget>[
                                                    Text(
                                                        "Artista", 
                                                        style: TextStyle(fontSize: 13)
                                                    ),
                                                ]
                                            )
                                        ]
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
}
