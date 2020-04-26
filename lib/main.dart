import 'package:flutter/material.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui/player.dart';
import 'package:musify/main_menu.dart';
import 'package:musify/screens/search_screen.dart';

void main() => runApp(Musify());

class Musify extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Musify',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: HomeScreen(title: 'Musify'),
        );
    }
}

class HomeScreen extends StatefulWidget {
    HomeScreen({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        FlatButton(
                            child: Text("Main menu"),
                            onPressed: () {
                                Session.player = Player();
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => MainMenuScreen()
                                ));
                            },
                        )
                    ],
                ),
            )
        );
    }
}
