import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui/songlist.dart';

class HistoryScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _HistoryPage();
    }
}

class _HistoryPage extends StatefulWidget {
    _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<_HistoryPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Historial de reproducción"),
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
        for (int i = Session.songsIdPlayHistory.length - 1; i >= 0; i--){
            songsId.add(int.parse(Session.songsIdPlayHistory.elementAt(i)));
        }
        return FutureFactory<List<Song>>().networkFuture(Song.fetchSongById(songsId), (data) {
            return SongList(songs: data);
        });
    }
}
