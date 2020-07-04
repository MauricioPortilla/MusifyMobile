import 'package:flutter/material.dart';
import 'package:musify/core/models/genre.dart';

class GenreList extends StatefulWidget {
    final List<Genre> genres;
    final Function onTap;

    GenreList({@required this.genres, @required this.onTap});

    @override
    State<StatefulWidget> createState() {
        return _GenreListState();
    }
}

class _GenreListState extends State<GenreList> {
    @override
    Widget build(BuildContext context) {
        return Expanded(child: _createListView());
    }

    ListView _createListView() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.genres.length,
            itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () => widget.onTap(widget.genres[index]),
                        child: Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Container(
                                        child: Text(
                                            widget.genres[index].name,
                                            textAlign: TextAlign.left
                                        ),
                                        margin: EdgeInsets.only(bottom: 3)
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