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
                automaticallyImplyLeading: false
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Session.account.subscription == null ? RaisedButton(
                                        child: Text("Suscribirse"),
                                        onPressed: () => _subscribeButton(),
                                    ) : Container(child: Text("Suscrito")),
                                    RaisedButton(
                                        child: Text("Nueva lista de reproducción"),
                                        onPressed: _createNewPlaylistButton,
                                    )
                                ]
                            )
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
                        )
                    ]
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15)
            )
        );
    }

    void _onSelectPlaylist(Playlist playlist) {
        Session.homePush(ConsultPlaylistScreen(playlist: playlist));
    }

    FutureBuilder<List<Playlist>> _playlistListUI() {
        return FutureFactory<List<Playlist>>().networkFuture(Session.account.fetchPlaylists(), (data) {
            return PlaylistList(playlists: data, onTap: _onSelectPlaylist);
        }, () {
            return Center(child: Text("Ocurrió un error al cargar las listas de reproducción."));
        });
    }

    void _createNewPlaylistButton() {
        var playlistNameTextFieldController = TextEditingController();
        UI.createDialog(
            context, 
            "Nueva lista de reproducción", 
            Expanded(
                child: TextField(
                    controller: playlistNameTextFieldController,
                    decoration: InputDecoration(labelText: "Nombre"),
                    maxLength: 20,
                    maxLengthEnforced: true
                )
            ), [
                FlatButton(
                    child: Text("Crear"),
                    onPressed: () {
                        if (playlistNameTextFieldController.text.isEmpty) {
                            UI.createErrorDialog(context, "Debes introducir un nombre.");
                            return;
                        }
                        Playlist newPlaylist = Playlist(accountId: Session.account.accountId, name: playlistNameTextFieldController.text);
                        try {
                            newPlaylist.save((playlist) {
                                setState(() {
                                });
                                Navigator.pop(context);
                            }, (errorResponse) {
                                UI.createErrorDialog(context, errorResponse.message);
                            }, () {
                                UI.createErrorDialog(context, "Ocurrió un error al crear la lista de reproducción.");
                            });
                        } catch (exception) {
                            UI.createErrorDialog(context, "Ocurrió un error al crear la lista de reproducción.");
                        }
                    }
                ),
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () => Navigator.pop(context)
                )
            ]
        );
    }

    void _subscribeButton() {
        UI.createDialog(context, "Suscribirse", Text("¿Desea suscribirse?"), [
            FlatButton(
                child: Text("Sí"),
                onPressed: () {
                    Navigator.pop(context);
                    _subscribe();
                }
            ),
            FlatButton(
                child: Text("No"),
                onPressed: () => Navigator.pop(context)
            )
        ]);
    }

    void _subscribe() {
        UI.createLoadingDialog(context);
        Session.account.subscribe(() {
            Navigator.pop(context);
            UI.createSuccessDialog(context, "Cuenta suscrita.");
            setState(() {
            });
        }, (errorResponse) {
            Navigator.pop(context);
            UI.createErrorDialog(context, errorResponse.message);
        }, () {
            Navigator.pop(context);
            UI.createErrorDialog(context, "Ocurrió un error al intentar suscribirse.");
        });
    }
}
