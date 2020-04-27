import 'package:flutter/material.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui/player.dart';
import 'package:musify/screens/search_screen.dart';
import 'package:musify/screens/history_screen.dart';

class MainMenuScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _MainMenuPage();
    }
}

class _MainMenuPage extends StatefulWidget {
    _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<_MainMenuPage> with SingleTickerProviderStateMixin {
    TabController _tabController;
    @override
    void initState() {
        super.initState();
        _tabController = TabController(length: 4, vsync: this);
    }

    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                body: TabBarView(
                    controller: _tabController,
                    children: [
                        Container(
                            child: ListView(
                                children: <Widget>[
                                ],
                            )
                        ),
                        Container(
                            child: SearchScreen()
                        ),
                        Container(
                            child: ListView(
                                
                            ),
                        ),
                        Container(
                            child: HistoryScreen()
                        ),
                    ],
                ),
                bottomNavigationBar: Container(
                    child: Wrap(
                        children: <Widget>[
                            Session.player,
                            Container(
                                color: Color(0xFF3F5AA6),
                                child: TabBar(
                                    controller: _tabController,
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
}
