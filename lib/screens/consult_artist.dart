import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/session.dart';
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
    List<Widget> _albumsUI = <Widget>[];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.artist.artisticName),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Session.homePop()
                )
            ),
            body: SingleChildScrollView(
                child: Container(
                    child: _loadAlbums(),
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 15)
                )
            )
        );
    }

    FutureBuilder<List<Album>> _loadAlbums() {
        return FutureFactory<List<Album>>().networkFuture(widget.artist.fetchAlbums(), (data) {
            _albumsUI.clear();
            for (Album album in data) {
                _albumsUI.add(
                    Container(
                        child: AlbumPanel(album: album),
                        margin: EdgeInsets.only(bottom: 15)
                    )
                );
            }
            return Column(children: _albumsUI);
        }, () {
            return Center(child: Text("Ocurrió un error al cargar las canciones."));
        });
    }
}
