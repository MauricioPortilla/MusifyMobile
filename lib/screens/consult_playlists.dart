import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/core/ui/playlistlist.dart';
import 'package:musify/screens/consult_playlist.dart';

class ConsultPlaylistsScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _ConsultPlaylistsPage();
    }
}

class _ConsultPlaylistsPage extends StatefulWidget {
    _ConsultPlaylistsPageState createState() => _ConsultPlaylistsPageState();
}

class _ConsultPlaylistsPageState extends State<_ConsultPlaylistsPage> {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Menú principal"),
                centerTitle: true,
                automaticallyImplyLeading: false,
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    RaisedButton(
                                        child: Text("Suscribirse"),
                                        onPressed: () {},
                                    ),
                                    RaisedButton(
                                        child: Text("Nueva lista de reproducción"),
                                        onPressed: _createNewPlaylistButton,
                                    ),
                                ],
                            ),
                        ),
                        Text(
                            "Listas de reproducción",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        Container(
                            child: _playlistListUI(),
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    void _onSelectPlaylist(Playlist playlist) {
        Session.homePush(ConsultPlaylistScreen(playlist: playlist));
    }

    FutureBuilder<List<Playlist>> _playlistListUI() {
        return FutureFactory<List<Playlist>>().networkFuture(Session.account.loadPlaylists(), (data) {
            return PlaylistList(playlists: data, onTap: _onSelectPlaylist);
        });
    }

    void _createNewPlaylistButton() {
        var playlistNameTextFieldController = TextEditingController();
        UI.createDialog(
            context, 
            "Nueva lista de reproducción", 
            Column(
                children: <Widget>[
                    TextField(
                        controller: playlistNameTextFieldController,
                        decoration: InputDecoration(
                            labelText: "Nombre"
                        ),
                        maxLength: 20,
                        maxLengthEnforced: true,
                    ),
                ],
            ), [
                FlatButton(
                    child: Text("Crear"),
                    onPressed: () {
                        Playlist newPlaylist = Playlist(
                            accountId: Session.account.accountId, 
                            name: playlistNameTextFieldController.text
                        );
                        try {
                            newPlaylist.save((playlist) {
                                setState(() {
                                });
                                Navigator.pop(context);
                            }, (errorResponse) {
                                UI.createErrorDialog(context, "Ocurrió un error al crear la lista de reproducción.");
                            });
                        } catch (exception) {
                            UI.createErrorDialog(context, "Ocurrió un error al crear la lista de reproducción.");
                        }
                    },
                ),
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                        Navigator.pop(context);
                    },
                )
            ]);
    }
}
