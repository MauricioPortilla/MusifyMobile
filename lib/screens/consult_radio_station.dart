import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/genre.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/core/ui/songlist.dart';

class ConsultRadioStationScreen extends StatelessWidget {
    final Genre genre;

    ConsultRadioStationScreen({@required this.genre});

    @override
    Widget build(BuildContext context) {
        return _ConsultRadioStationScreenPage(genre: this.genre);
    }
}

class _ConsultRadioStationScreenPage extends StatefulWidget {
    final Genre genre;

    _ConsultRadioStationScreenPage({@required this.genre});

    _ConsultRadioStationScreenPageState createState() => _ConsultRadioStationScreenPageState();
}

class _ConsultRadioStationScreenPageState extends State<_ConsultRadioStationScreenPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Estación de radio"),
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
                        Text(
                            widget.genre.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    RaisedButton(
                                        child: Text("Eliminar estación"),
                                        onPressed: () => deleteRadioStation(),
                                    ),
                                ],
                            ),
                        ),
                        Container(
                            child: _songList(),
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    FutureBuilder<List<Song>> _songList() {
        return FutureFactory<List<Song>>().networkFuture(widget.genre.fetchSongs(), (data) {
            return SongList(songs: data);
        });
    }

    void deleteRadioStation() {
        UI.createDialog(context, "Eliminar estación", Text("¿Desea eliminar esta estación?"), [
            FlatButton(
                child: Text("Sí"),
                onPressed: () async {
                    Navigator.pop(context);
                    UI.createLoadingDialog(context);
                    Session.genresIdRadioStations.remove(widget.genre.genreId.toString());
                    Session.preferences.setStringList("genresIdRadioStations" + Session.account.accountId.toString(), Session.genresIdRadioStations);
                    Navigator.pop(context);
                    Session.homePop();
                },
            ),
            FlatButton(
                child: Text("No"),
                onPressed: () => Navigator.pop(context),
            )
        ]);
    }
}
