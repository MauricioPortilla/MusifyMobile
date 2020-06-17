import 'package:flutter/material.dart';
import 'package:musify/core/session.dart';

class PlayerSettingsScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _PlayerSettingsPage();
    }
}

class _PlayerSettingsPage extends StatefulWidget {
    _PlayerSettingsPageState createState() => _PlayerSettingsPageState();
}

class _PlayerSettingsPageState extends State<_PlayerSettingsPage> {
    bool lowSelected = false;
    bool mediumSelected = false;
    bool highSelected = false;
    bool automaticSelected = false;

    @override
    Widget build(BuildContext context) {
        _loadQuality();
        return Scaffold(
            appBar: AppBar(
                title: Text("Configuración del reproductor"),
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
                child: Column(
                    children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Text(
                                    "Calidad de la música",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    )
                                ),
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Checkbox(
                                    value: lowSelected,
                                    onChanged: (value) {
                                      if (value){
                                        _saveQuality();
                                        setState(() {
                                            lowSelected = true;
                                            mediumSelected = false;
                                            highSelected = false;
                                            automaticSelected = false;
                                        });
                                      }
                                    },
                                ),
                                Text("Baja")
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Checkbox(
                                    value: mediumSelected,
                                    onChanged: (value) {
                                      if (value){
                                        _saveQuality();
                                        setState(() {
                                            lowSelected = false;
                                            mediumSelected = true;
                                            highSelected = false;
                                            automaticSelected = false;
                                        });
                                      }
                                    },
                                ),
                                Text("Media")
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Checkbox(
                                    value: highSelected,
                                    onChanged: (value) {
                                      if (value){
                                        _saveQuality();
                                        setState(() {
                                            lowSelected = false;
                                            mediumSelected = false;
                                            highSelected = true;
                                            automaticSelected = false;
                                        });
                                      }
                                    },
                                ),
                                Text("Alta")
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Checkbox(
                                    value: automaticSelected,
                                    onChanged: (value) {
                                      if (value){
                                        _saveQuality();
                                        setState(() {
                                            lowSelected = false;
                                            mediumSelected = false;
                                            highSelected = false;
                                            automaticSelected = true;
                                        });
                                      }
                                    },
                                ),
                                Text("Automática")
                            ],
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    void _loadQuality() {
        if (Session.songStreamingQuality == "lowquality") {
            lowSelected = true;
        } else if (Session.songStreamingQuality == "mediumquality") {
            mediumSelected = true;
        } else if (Session.songStreamingQuality == "highquality") {
            highSelected = true;
        } else {
            automaticSelected = true;
        }
    }

    Future<void> _saveQuality() async {
        if (lowSelected) {
            Session.songStreamingQuality = "lowquality";
        } else if (mediumSelected) {
            Session.songStreamingQuality = "mediumquality";
        } else if (highSelected) {
            Session.songStreamingQuality = "highquality";
        } else {
            // TODO: Set automatic quality
            //Session.songStreamingQuality = "automaticquality";
        }
        Session.preferences.setString("songStreamingQuality" + Session.account.accountId.toString(), Session.songStreamingQuality);
    }
}
