import 'package:flutter/material.dart';
import 'package:musify/core/core.dart';
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
        return Expanded(child: _createListView());
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
                            Session.historyIndex = Session.songsIdPlayHistory.length - 1;
                            if (Session.songsIdPlayHistory.length == Core.MAX_SONGS_IN_PLAY_HISTORY){
                                Session.historyIndex--;
                            }
                            Session.player.state.playSong(accountSong: widget.accountSongs[index]);
                            Session.songsIdSongList.clear();
                            for (int i = index + 1; i < widget.accountSongs.length; i++) {
                                Session.songsIdSongList.add(widget.accountSongs[i].accountSongId * -1);
                            }
                        },
                        child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Container(
                                        width: MediaQuery.of(context).size.width / 1.8,
                                        child: Text(
                                            widget.accountSongs[index].title,
                                            textAlign: TextAlign.left
                                        )
                                    ),
                                    Container(
                                        width: 150,
                                        child: DropdownButton(
                                            isExpanded: true,
                                            items: <DropdownMenuItem<String>>[
                                                DropdownMenuItem(
                                                    child: Text(
                                                        "Agregar a la cola de reproducción", 
                                                        style: TextStyle(fontSize: 14)
                                                    ),
                                                    value: "addToPlayQueue"
                                                ),
                                                DropdownMenuItem(
                                                    child: Text(
                                                        "Eliminar", 
                                                        style: TextStyle(fontSize: 14)
                                                    ),
                                                    value: "delete"
                                                )
                                            ],
                                            icon: Icon(Icons.more_horiz),
                                            onChanged: (value) {
                                                if (value == "addToPlayQueue") {
                                                    _addToPlayQueue(widget.accountSongs[index]);
                                                } else if (value == "delete") {
                                                    _deleteAccountSong(widget.accountSongs[index]);
                                                }
                                            }
                                        )
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

    void _addToPlayQueue(AccountSong accountSong) {
        UI.createDialog(context, "Agregar a la cola", Text("Agregar ..."), [
            FlatButton(
                child: Text("A continuación"),
                onPressed: () {
                    List<String> songsIdPlayQueue = [(accountSong.accountSongId * -1).toString()];
                    songsIdPlayQueue.addAll(Session.songsIdPlayQueue);
                    Session.songsIdPlayQueue.clear();
                    Session.songsIdPlayQueue.addAll(songsIdPlayQueue);
                    Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                    Navigator.pop(context);
                }
            ),
            FlatButton(
                child: Text("Al final"),
                onPressed: () {
                    Session.songsIdPlayQueue.add((accountSong.accountSongId * -1).toString());
                    Session.preferences.setStringList("songsIdPlayQueue" + Session.account.accountId.toString(), Session.songsIdPlayQueue);
                    Navigator.pop(context);
                }
            ),
            FlatButton(
                child: Text("Cancelar"),
                onPressed: () => Navigator.pop(context)
            )
        ]);
    }

    void _deleteAccountSong(AccountSong accountSong) {
        UI.createDialog(context, "Eliminar canción", Text("¿Deseas eliminar esta canción?"), [
            FlatButton(
                child: Text("Sí"),
                onPressed: () {
                    Navigator.pop(context);
                    UI.createLoadingDialog(context);
                    Session.account.deleteAccountSong(accountSong, () {
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
                }
            ),
            FlatButton(
                child: Text("No"),
                onPressed: () => Navigator.pop(context)
            )
        ]);
    }
}
