import 'package:flutter/material.dart';
import 'package:musify/core/models/accountsong.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';

class AccountSongList extends StatefulWidget {
    final List<AccountSong> accountSongs;

    AccountSongList({@required this.accountSongs});

    @override
    State<StatefulWidget> createState() {
        return _AccountSongListState();
    }
}

class _AccountSongListState extends State<AccountSongList> {
    @override
    Widget build(BuildContext context) {
        return Expanded(
            child: _createListView()
        );
    }

    ListView _createListView() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.accountSongs.length,
            itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () {
                            Session.player.state.playSong(accountSong: widget.accountSongs[index]);
                        },
                        child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Container(
                                        child: Text(
                                            widget.accountSongs[index].title,
                                            textAlign: TextAlign.left,
                                        ),
                                        margin: EdgeInsets.only(bottom: 3),
                                    ),
                                    DropdownButton(
                                        items: [
                                            DropdownMenuItem(
                                                child: Text("Agregar a la cola de reproducción", style: TextStyle(fontSize: 14)),
                                                value: "addToPlayQueue",
                                            ),
                                            DropdownMenuItem(
                                                child: Text("Eliminar", style: TextStyle(fontSize: 14)),
                                                value: "delete",
                                            )
                                        ],
                                        icon: Icon(Icons.more_horiz),
                                        onChanged: (value) {
                                            if (value == "addToPlayQueue") {
                                                Session.songsIdPlayQueue.add((widget.accountSongs[index].accountSongId * -1).toString());
                                                Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                                            } else if (value == "delete") {
                                                UI.createDialog(context, "Eliminar canción", Text("¿Deseas eliminar esta canción?"), [
                                                    FlatButton(
                                                        child: Text("Sí"),
                                                        onPressed: () {
                                                            Navigator.pop(context);
                                                            UI.createLoadingDialog(context);
                                                            Session.account.deleteAccountSong(widget.accountSongs[index], () {
                                                                Navigator.pop(context);
                                                                UI.createSuccessDialog(context, "Canción eliminada.");
                                                                setState(() {
                                                                });
                                                            }, (errorResponse) {
                                                                Navigator.pop(context);
                                                                UI.createErrorDialog(context, errorResponse.message);
                                                            }, () {
                                                                Navigator.pop(context);
                                                                UI.createErrorDialog(context, "No se pudo establecer una conexión con el servidor.");
                                                            });
                                                        },
                                                    ),
                                                    FlatButton(
                                                        child: Text("No"),
                                                        onPressed: () => Navigator.pop(context),
                                                    )
                                                ]);
                                            }
                                        },
                                    )
                                ],
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.black, width: 0.3))
                            ),
                        )
                    )
                );
            }
        );
    }
}
