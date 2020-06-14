import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/ui/albumlist.dart';
import 'package:musify/core/ui/artistlist.dart';
import 'package:musify/core/ui/songlist.dart';

class SearchScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _SearchPage();
    }
}

class _SearchPage extends StatefulWidget {
    _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
    final TextEditingController _searchTextFieldController = new TextEditingController();
    TabController _tabController;

    @override
    bool get wantKeepAlive => true;

    @override
    void initState() {
        _tabController = TabController(length: 3, vsync: this);
        super.initState();
    }
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white
                    ),
                    child: TextField(
                        controller: _searchTextFieldController,
                        decoration: InputDecoration(
                            hintText: "Buscar",
                        ),
                        onChanged: (text) {
                            setState(() {
                            });
                        },
                    ),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                bottom: TabBar(
                    controller: _tabController,
                    tabs: <Widget>[
                        Tab(child: Text("Canción")),
                        Tab(child: Text("Álbum")),
                        Tab(child: Text("Artista")),
                    ],
                ),
            ),
            body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                        child: Column(
                            children: <Widget>[
                                _songList(_searchTextFieldController.text)
                            ]
                        ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                        child: Column(
                            children: <Widget>[
                                _albumList(_searchTextFieldController.text)
                            ]
                        ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                        child: Column(
                            children: <Widget>[
                                _artistList(_searchTextFieldController.text)
                            ]
                        ),
                    ),
                ],
            ),
        );
    }

    FutureBuilder<List<Song>> _songList(String title) {
        return FutureFactory<List<Song>>().networkFuture(Song.fetchSongByTitleCoincidences(title), (data) {
            return SongList(songs: data);
        });
    }

    FutureBuilder<List<Album>> _albumList(String name) {
        return FutureFactory<List<Album>>().networkFuture(Album.fetchAlbumByNameCoincidences(name), (data) {
            return AlbumList(albums: data);
        });
    }

    FutureBuilder<List<Artist>> _artistList(String artisticName) {
        return FutureFactory<List<Artist>>().networkFuture(Artist.fetchAlbumByArtisticNameCoincidences(artisticName), (data) {
            return ArtistList(artists: data);
        });
    }
}
