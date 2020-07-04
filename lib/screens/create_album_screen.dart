import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/album.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';

import 'add_song_to_album.dart';

class CreateAlbumScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _CreateAlbumPage();
    }
}

class _CreateAlbumPage extends StatefulWidget {
    _CreateAlbumPageState createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<_CreateAlbumPage> {
    TextEditingController _nameTextFieldController = TextEditingController();
    TextEditingController _discographyTextFieldController = TextEditingController();
    TextEditingController _searchTextFieldController = TextEditingController();
    String imageName = "";
    int launchYear;
    List<Artist> artists = [Session.account.artist];
    List<Song> songs = List<Song>();
    File imageFile;
    List<File> songsFile = List<File>();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Crear album"),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Session.homePop()
                )
            ),
            body: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                        TextField(
                            controller: _nameTextFieldController,
                            decoration: InputDecoration(labelText: "Nombre"),
                            maxLength: 25,
                            maxLengthEnforced: true
                        ),
                        TextField(
                            controller: _discographyTextFieldController,
                            decoration: InputDecoration(labelText: "Discografía"),
                            maxLength: 50,
                            maxLengthEnforced: true
                        ),
                        Container(
                            child: Row(
                                children: <Widget>[
                                    Container(
                                        child: Text(
                                            "Año de lanzamiento:", 
                                            style: TextStyle(fontSize: 15)
                                        ),
                                        margin: EdgeInsets.only(right: 10)
                                    ),
                                    DropdownButton(
                                        items: _loadYears(),
                                        value: launchYear,
                                        onChanged: (value) {
                                            setState(() {
                                                launchYear = value;
                                            });
                                        }
                                    )
                                ]
                            ),
                            margin: EdgeInsets.only(top: 15, bottom: 25)
                        ),
                        Row(
                            children: <Widget>[
                                Container(
                                    child: RaisedButton(
                                        child: Text("Seleccionar imagen"),
                                        onPressed: () => _selectImage()
                                    ),
                                    margin: EdgeInsets.only(right: 10, bottom: 25)
                                ),
                                Text(imageName, style: TextStyle(color: Colors.blue, fontSize: 10))
                            ]
                        ),
                        TextField(
                            controller: _searchTextFieldController,
                            decoration: InputDecoration(hintText: "Artista"),
                            onChanged: (text) {
                                setState(() {
                                });
                            }
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
                            child: Text("Agregar canción"),
                            onPressed: () => _addSong(context)
                        ),
                        Container(
                            child: _createSongsListView(),
                            height: 150,
                            margin: EdgeInsets.only(bottom: 25)
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Container(
                                    child: RaisedButton(
                                        child: Text("Cancelar"),
                                        onPressed: () => Session.homePop()
                                    ),
                                    margin: EdgeInsets.only(right: 10)
                                ),
                                RaisedButton(
                                    child: Text("Aceptar"),
                                    onPressed: () => _accept()
                                )
                            ]
                        )
                    ]
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15)
            )
        );
    }

    List<DropdownMenuItem<int>> _loadYears() {
        List<DropdownMenuItem<int>> items = [];
        for (int i = DateTime.now().year; i >= 1900; i--) {
            items.add(
                DropdownMenuItem(
                    child: Text(i.toString()),
                    value: i
                )
            );
        }
        return items;
    }

    void _selectImage() async {
        imageFile = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['png']);
        if (imageFile != null) {
            imageName = imageFile.toString().split('/').last.substring(0, imageFile.toString().split('/').last.length - 1);
            setState(() {
            });
        }
    }

    FutureBuilder<List<Artist>> _artistList(String artisticName) {
        return FutureFactory<List<Artist>>().networkFuture(Artist.fetchAlbumByArtisticNameCoincidences(artisticName), (data) {
            return _artistsFoundListView(data);
        }, () {
            return Center(child: Text("Ocurrió un error al cargar los artistas."));
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
                                ]
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10)
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
                                                child: Text(
                                                    "Eliminar artista", 
                                                    style: TextStyle(fontSize: 14)
                                                ),	
                                                value: "deleteArtist"
                                            )	
                                        ],
                                        icon: Icon(Icons.more_horiz),
                                        onChanged: (value) {
                                            if (value == "deleteArtist") {
                                                artists.remove(artists[index]);
                                                setState(() {
                                                });
                                            }
                                        }
                                    )
                                ]
                            ),
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

    Future<void> _addSong(BuildContext context) async {
        final song = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddSongToAlbumScreen())) as Map<Song, File>;
        if (song != null) {
            songs.add(song.keys.elementAt(0));
            songsFile.add(song.values.elementAt(0));
            setState(() {
            });
        }
    }

    ListView _createSongsListView() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: songs.length,
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
                                            songs[index].title,
                                            textAlign: TextAlign.left
                                        )
                                    ),
                                    DropdownButton(
                                        items: [
                                            DropdownMenuItem(	
                                                child: Text(
                                                    "Eliminar canción", 
                                                    style: TextStyle(fontSize: 14)
                                                ),	
                                                value: "deleteSong"
                                            )	
                                        ],
                                        icon: Icon(Icons.more_horiz),
                                        onChanged: (value) {
                                            if (value == "deleteSong") {
                                                songs.remove(songs[index]);
                                                setState(() {
                                                });
                                            }
                                        }
                                    )
                                ]
                            ),
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

    void _accept() {
        if (_nameTextFieldController.text.isNotEmpty && _discographyTextFieldController.text.isNotEmpty && 
        launchYear != null && imageFile != null && artists.length > 0 && songs.length > 0) {
            String type = "Álbum";
            if (songs.length == 1) {
                type = "Sencillo";
            }
            Album album = Album(
                type: type,
                name: _nameTextFieldController.text,
                launchYear: launchYear,
                discography: _discographyTextFieldController.text
            );
            album.artists = artists;
            album.songs = songs;
            UI.createLoadingDialog(context);
            album.save(imageFile, songsFile, () {
                Navigator.pop(context);
                UI.createDialog(context, "Álbum creado", Text("Se creó el álbum con éxito. Las canciones aún se están procesando."), [
                    FlatButton(
                        child: Text("Cerrar"),
                        onPressed: () {
                            _nameTextFieldController.text = "";
                            _discographyTextFieldController.text = "";
                            launchYear = null;
                            imageName = "";
                            imageFile = null;
                            _searchTextFieldController.text = "";
                            artists.clear();
                            artists.add(Session.account.artist);
                            songs.clear();
                            songsFile.clear();
                            setState(() {
                            });
                            Navigator.pop(context);
                            return;
                        }
                    )
                ]);
            }, (errorResponse) {
                Navigator.pop(context);
                UI.createErrorDialog(context, errorResponse.message);
            }, () {
                Navigator.pop(context);
                UI.createErrorDialog(context, "Error al crear el álbum.");
            });
            return;
        }
        UI.createLoadingDialog(context);
        Navigator.pop(context);
        UI.createErrorDialog(context, "Faltan campos por completar.");
    }
}
