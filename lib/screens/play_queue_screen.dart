import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/songtable.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui/songtablelist.dart';

class PlayQueueScreen extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return _PlayQueuePage();
    }
}

class _PlayQueuePage extends StatefulWidget {
    _PlayQueuePageState createState() => _PlayQueuePageState();
}

class _PlayQueuePageState extends State<_PlayQueuePage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Cola de reproducción"),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                        Session.homePop();
                    },
                ),
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                                RaisedButton(
                                    child: Text("Eliminar cola"),
                                    onPressed: Session.songsIdPlayQueue.length > 0 ? () => _deletePlayQueueButton() : null,
                                ),
                            ],
                        ),
                        Container(
                            child: _songList(),
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }
    
    void _onPlaySong() {
        setState(() {
        });
    }

    FutureBuilder<List<SongTable>> _songList() {
        List<int> songsId = List<int>();
        for (String songId in Session.songsIdPlayQueue){
            songsId.add(int.parse(songId));
        }
        for (int songId in Session.songsIdSongList){
            songsId.add(songId);
        }
        return FutureFactory<List<SongTable>>().networkFuture(SongTable.fetchSongsById(songsId), (data) {
            return SongTableList(songs: data, onTap: _onPlaySong, isPlayQueue: true);
        });
    }

    void _deletePlayQueueButton() async {
        Session.songsIdPlayQueue = List<String>();
        Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
        setState(() {
        });
    }
}
