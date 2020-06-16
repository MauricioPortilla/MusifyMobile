import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui/songlist.dart';

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
                                    onPressed: () => _deletePlayQueueButton(),
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

    FutureBuilder<List<Song>> _songList() {
        List<int> songsId = List<int>();
        for (String songId in Session.songsIdPlayQueue){
            songsId.add(int.parse(songId));
        }
        return FutureFactory<List<Song>>().networkFuture(Song.fetchSongById(songsId), (data) {
            return SongList(songs: data);
        });
    }

    void _deletePlayQueueButton() async {
        Session.songsIdPlayQueue = List<String>();
        setState(() {
            build(context);
        });
    }
}
