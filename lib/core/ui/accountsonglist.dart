import 'package:flutter/material.dart';
import 'package:musify/core/models/accountsong.dart';

class AccountSongList extends StatefulWidget {
    final List<AccountSong> accountSongs;

    AccountSongList({@required this.accountSongs});

    @override
    State<StatefulWidget> createState() {
        return _AccountSongListState();
    }
}

class _AccountSongListState extends State<AccountSongList> {
    @override
    Widget build(BuildContext context) {
        return Expanded(
            child: _createListView()
        );
    }

    ListView _createListView() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.accountSongs.length,
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
                                    Container(
                                        child: Text(
                                            widget.accountSongs[index].title,
                                            textAlign: TextAlign.left,
                                        ),
                                        margin: EdgeInsets.only(bottom: 3),
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
