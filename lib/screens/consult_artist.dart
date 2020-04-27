import 'package:flutter/material.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/ui/album_panel.dart';

class ConsultArtistScreen extends StatelessWidget {
    final Artist artist;

    ConsultArtistScreen({@required this.artist});

    @override
    Widget build(BuildContext context) {
        return _ConsultArtistPage(artist: this.artist);
    }
}

class _ConsultArtistPage extends StatefulWidget {
    final Artist artist;

    _ConsultArtistPage({@required this.artist});

    _ConsultArtistPageState createState() => _ConsultArtistPageState();
}

class _ConsultArtistPageState extends State<_ConsultArtistPage> {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.artist.artisticName),
                centerTitle: true,
                automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
                child: Container(
                    child: Column(
                        children: _loadAlbums()
                    ),
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                )
            )
        );
    }

    List<Widget> _loadAlbums() {
        List<Widget> albumsUI = <Widget>[];
        for (Album album in widget.artist.albums) {
            albumsUI.add(
                Container(
                    child: AlbumPanel(album: album),
                    margin: EdgeInsets.only(bottom: 15)
                )
            );
        }
        return albumsUI;
    }
}
