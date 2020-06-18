import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musify/core/session.dart';
import 'package:musify/screens/consult_account_songs.dart';
import 'package:musify/screens/create_album_screen.dart';
import 'package:musify/screens/home_screen.dart';
import 'package:musify/screens/play_queue_screen.dart';
import 'package:musify/screens/player_settings_screen.dart';
import 'package:musify/screens/radio_stations_screen.dart';
import 'package:musify/screens/search_screen.dart';
import 'package:musify/screens/history_screen.dart';

class MainMenuScreen extends StatelessWidget {
    final page = _MainMenuPage();

    @override
    Widget build(BuildContext context) {
        return page;
    }
}

class _MainMenuPage extends StatefulWidget {
    final _MainMenuPageState state = _MainMenuPageState();
    final StreamController<Widget> controller = StreamController<Widget>();
    Stream<Widget> controllerStreamBroadcast;
    
    _MainMenuPage() {
        controllerStreamBroadcast = controller.stream.asBroadcastStream();
    }

    _MainMenuPageState createState() => state;
}

class _MainMenuPageState extends State<_MainMenuPage> with SingleTickerProviderStateMixin {
    TabController tabController;

    @override
    void initState() {
        super.initState();
        tabController = TabController(length: 4, vsync: this);
    }

    @override
    void dispose() {
        widget.controller.close();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                body: TabBarView(
                    controller: tabController,
                    children: [
                        Container(
                            child: HomeScreen(stream: widget.controllerStreamBroadcast)
                        ),
                        Container(
                            child: SearchScreen()
                        ),
                        Container(
                            child: RadioStationsScreen()
                        ),
                        Container(
                            child: ListView(
                                children: _loadOptions()
                            )
                        )
                    ],
                ),
                bottomNavigationBar: Container(
                    child: Wrap(
                        children: <Widget>[
                            Session.player,
                            Container(
                                color: Color(0xFF3F5AA6),
                                child: TabBar(
                                    controller: tabController,
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.white70,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicatorPadding: EdgeInsets.all(5.0),
                                    indicatorColor: Colors.blue,
                                    tabs: [
                                        Tab(icon: Icon(Icons.home)),
                                        Tab(icon: Icon(Icons.search)),
                                        Tab(icon: Icon(Icons.radio)),
                                        Tab(icon: Icon(Icons.account_circle)),
                                    ],
                                ),
                            )
                        ],
                    )
                )
            )
        );
    }

    List<FlatButton> _loadOptions() {
        List<FlatButton> items = [
            FlatButton(
                child: Text("Consultar biblioteca propia"),
                onPressed: () {
                    Session.homePush(ConsultAccountSongsScreen());
                },
            ),
            FlatButton(
                child: Text("Consultar cola de reproducción"),
                onPressed: () {
                    Session.homePush(PlayQueueScreen());
                },
            ),
            FlatButton(
                child: Text("Consultar historial"),
                onPressed: () {
                    Session.homePush(HistoryScreen());
                },
            ),
            FlatButton(
                child: Text("Configuración del reproductor"),
                onPressed: () {
                    Session.homePush(PlayerSettingsScreen());
                },
            )
        ];
        if (Session.account.artist != null) {
            items.add(
                FlatButton(
                    child: Text("Crear álbum"),
                    onPressed: () {
                        Session.homePush(CreateAlbumScreen());
                    },
                )
            );
        }
        items.add(
            FlatButton(
                child: Text("Cerrar sesión"),
                onPressed: () {
                    Navigator.pop(context);
                },
            )
        );
        return items;
    }
}
