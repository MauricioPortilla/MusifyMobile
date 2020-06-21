import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/genre.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';

class AddSongToAlbumScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _AddSongToAlbumPage();
    }
}

class _AddSongToAlbumPage extends StatefulWidget {
    _AddSongToAlbumPageState createState() => _AddSongToAlbumPageState();
}

class _AddSongToAlbumPageState extends State<_AddSongToAlbumPage> {
    TextEditingController _nameTextFieldController = TextEditingController();
    TextEditingController _searchTextFieldController = TextEditingController();
    String songName = "";
    Genre genre;
    List<Artist> artists = [Session.account.artist];
    List<Genre> genres = List<Genre>();
    File songFile;

    @override
    Widget build(BuildContext context) {
        if (genres.length == 0) {
            _loadGenres();
        }
        return Scaffold(
            appBar: AppBar(
                title: Text("Agregar canción"),
                centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                        Row(
                            children: <Widget>[
                                Container(
                                    child: RaisedButton(
                                        child: Text("Seleccionar canción"),
                                        onPressed: () => _selectSong()
                                    ),
                                    margin: EdgeInsets.only(right: 10, bottom: 25)
                                ),
                                Text(songName, style: TextStyle(color: Colors.blue, fontSize: 10)),
                            ],
                        ),
                        TextField(
                            controller: _nameTextFieldController,
                            decoration: InputDecoration(
                                labelText: "Nombre"
                            ),
                            maxLength: 255,
                            maxLengthEnforced: true,
                        ),
                        Container(
                            child: Row(
                                children: <Widget>[
                                    Container(
                                        child: Text("Género:", style: TextStyle(fontSize: 15)),
                                        margin: EdgeInsets.only(right: 10)
                                    ),
                                    DropdownButton(
                                        items: _genreList(),
                                        value: genre,
                                        onChanged: (value) {
                                            setState(() {
                                                genre = value;
                                            });
                                        }
                                    )
                                ],
                            ),
                            margin: EdgeInsets.only(top: 15, bottom: 25),
                        ),
                        TextField(
                            controller: _searchTextFieldController,
                            decoration: InputDecoration(
                                hintText: "Artista",
                            ),
                            onChanged: (text) {
                                setState(() {
                                });
                            },
                        ),
                        Container(
                            child: _artistList(_searchTextFieldController.text),
                            margin: EdgeInsets.only(bottom: 25)
                        ),
                        Container(
                            child: _createArtistsListView(),
                            height: 150,
                            margin: EdgeInsets.only(bottom: 25)
                        ),
                        RaisedButton(
                            child: Text("Aceptar"),
                            onPressed: () => _accept()
                        )
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    Future<void> _loadGenres() async {
        List<Genre> allGenres = await Genre.fetchAll();
        for (Genre genre in allGenres) {
            genres.add(genre);
        }
        setState(() {
        });
    }

    List<DropdownMenuItem<Genre>> _genreList() {
        List<DropdownMenuItem<Genre>> items = [];
        for (Genre genre in genres) {
            items.add(
                DropdownMenuItem(
                    child: Text(genre.name),
                    value: genre
                )
            );
        }
        return items;
    }

    void _selectSong() async {
        songFile = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['mp3', 'wav']);
        if (songFile != null) {
            songName = songFile.toString().split('/').last.substring(0, songFile.toString().split('/').last.length - 1);
            if (songName.length > 255) {
                _nameTextFieldController.text = songName.split('.').first.substring(0, 255);
            } else {
                _nameTextFieldController.text = songName.split('.').first;
            }
            setState(() {
            });
        }
    }

    FutureBuilder<List<Artist>> _artistList(String artisticName) {
        return FutureFactory<List<Artist>>().networkFuture(Artist.fetchAlbumByArtisticNameCoincidences(artisticName), (data) {
            return _artistsFoundListView(data);
        });
    }

    ListView _artistsFoundListView(List<Artist> artistslist) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: artistslist.length,
            itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () {
                            if (artists.length == 0 || artists.firstWhere((element) => element.artisticName == artistslist[index].artisticName) == null) {
                                artists.add(artistslist[index]);
                            } else {
                                UI.createLoadingDialog(context);
                                Navigator.pop(context);
                                UI.createErrorDialog(context, "Este artista ya se encuentra agregado.");
                            }
                            _searchTextFieldController.text = "";
                            setState(() {
                            });
                        },
                        child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Container(
                                        child: Text(
                                            artistslist[index].artisticName,
                                            textAlign: TextAlign.left
                                        )
                                    )
                                ],
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                        )
                    )
                );
            }
        );
    }

    ListView _createArtistsListView() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: artists.length,
            itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: double.infinity,
                    child: InkWell(
                        child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Container(
                                        child: Text(
                                            artists[index].artisticName,
                                            textAlign: TextAlign.left
                                        )
                                    ),
                                    DropdownButton(
                                        items: [
                                            DropdownMenuItem(	
                                                child: Text("Eliminar artista", style: TextStyle(fontSize: 14)),	
                                                value: "deleteArtist",	
                                            )	
                                        ],
                                        icon: Icon(Icons.more_horiz),
                                        onChanged: (value) {
                                            if (value == "deleteArtist") {
                                                artists.remove(artists[index]);
                                                setState(() {
                                                });
                                            }
                                        },
                                    )
                                ],
                            ),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.black, width: 0.3))
                            ),
                        )
                    )
                );
            } 
        );
    }

    void _accept() {
        if (_nameTextFieldController.text.isNotEmpty && genre != null && songFile != null && artists.length > 0) {
            Song song = Song(
                genreId: genre.genreId,
                title: _nameTextFieldController.text
            );
            song.artists = artists;
            Map<Song, File> songAndFile = {song: songFile};
            Navigator.pop(context, songAndFile);
            return;
        } 
        UI.createLoadingDialog(context);
        Navigator.pop(context);
        UI.createErrorDialog(context, "Faltan campos por completar.");
    }
}