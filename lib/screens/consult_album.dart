import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui/songlist.dart';

class ConsultAlbumScreen extends StatelessWidget {
    final Album album;

    ConsultAlbumScreen({@required this.album});

    @override
    Widget build(BuildContext context) {
        return _ConsultAlbumPage(album: this.album);
    }
}

class _ConsultAlbumPage extends StatefulWidget {
    final Album album;

    _ConsultAlbumPage({@required this.album});

    _ConsultAlbumPageState createState() => _ConsultAlbumPageState();
}

class _ConsultAlbumPageState extends State<_ConsultAlbumPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.album.name),
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
                margin: EdgeInsets.only(top: 10),
                child: Column(
                    children: <Widget>[
                        Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(right: 10),
                            child: widget.album.fetchImage(),
                        ),
                        Text(widget.album.type),
                        Text(widget.album.launchYear.toString() + " | " + widget.album.discography),
                        Text(widget.album.artistsNames()),
                        Container(
                            child: _songList()
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    FutureBuilder<List<Song>> _songList() {
        return FutureFactory<List<Song>>().networkFuture(widget.album.loadSongs(), (data) {
            return SongList(songs: data, isSearch: false);
        });
    }
}